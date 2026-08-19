import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ruya/core/network/dio_client.dart';
import 'package:ruya/core/session/token_local_data_source.dart';

class FakeStorage implements FlutterSecureStorage {
  final Map<String, String> _map = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _map.remove(key);
    } else {
      _map[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _map[key];
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _map.remove(key);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeStorage fakeStorage;
  late TokenLocalDataSource tokenDataSource;

  setUp(() async {
    await dotenv.load(mergeWith: {'BASE_URL': 'https://ruya.runasp.net'});
    DioClient.resetInstance();
    fakeStorage = FakeStorage();
    tokenDataSource = TokenLocalDataSource(fakeStorage);
  });

  group('DioClient Auth Interceptor', () {
    test('attaches Bearer Authorization header when token exists', () async {
      await tokenDataSource.saveToken('test-jwt-token');

      final dio = DioClient.getInstance(tokenDataSource);

      final options = RequestOptions(path: '/Chat/message');
      final handler = RequestInterceptorHandler();

      for (final interceptor in dio.interceptors) {
        if (interceptor is InterceptorsWrapper) {
          interceptor.onRequest(options, handler);
          await handler.future;
          break;
        }
      }

      expect(options.headers['Authorization'], 'Bearer test-jwt-token');
    });

    test('prevents duplicate Bearer prefix if token is already prefixed', () async {
      await tokenDataSource.saveToken('Bearer already-prefixed-token');

      final dio = DioClient.getInstance(tokenDataSource);
      final options = RequestOptions(path: '/Chat/message');
      final handler = RequestInterceptorHandler();

      for (final interceptor in dio.interceptors) {
        if (interceptor is InterceptorsWrapper) {
          interceptor.onRequest(options, handler);
          await handler.future;
          break;
        }
      }

      expect(options.headers['Authorization'], 'Bearer already-prefixed-token');
    });

    test('does not attach Authorization header when token is null or empty', () async {
      final dio = DioClient.getInstance(tokenDataSource);
      final options = RequestOptions(path: '/Chat/message');
      final handler = RequestInterceptorHandler();

      for (final interceptor in dio.interceptors) {
        if (interceptor is InterceptorsWrapper) {
          interceptor.onRequest(options, handler);
          await handler.future;
          break;
        }
      }

      expect(options.headers['Authorization'], isNull);
    });

    test('clears token on 401 response in error interceptor', () async {
      await tokenDataSource.saveToken('expired-token');
      expect(await tokenDataSource.getToken(), 'expired-token');

      final dio = DioClient.getInstance(tokenDataSource);
      final reqOptions = RequestOptions(path: '/Chat/message');
      final errHandler = ErrorInterceptorHandler();

      final dioError = DioException(
        requestOptions: reqOptions,
        response: Response(
          requestOptions: reqOptions,
          statusCode: 401,
        ),
      );

      for (final interceptor in dio.interceptors) {
        if (interceptor is InterceptorsWrapper) {
          final reqHandler = ErrorInterceptorHandler();
          interceptor.onError(dioError, reqHandler);
          try {
            await reqHandler.future;
          } catch (_) {}
        }
      }
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(await tokenDataSource.getToken(), isNull);
    });
  });
}
