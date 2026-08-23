import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ruya/core/localization/locale_cubit.dart';
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

class TestRequestInterceptorHandler extends RequestInterceptorHandler {
  final Completer<void> _completer = Completer<void>();
  Future<void> get completed => _completer.future;

  @override
  void next(RequestOptions requestOptions) {
    if (!_completer.isCompleted) _completer.complete();
  }

  @override
  void reject(DioException error, [bool callNext = false]) {
    if (!_completer.isCompleted) _completer.complete();
  }

  @override
  void resolve(Response response, [bool callNext = false]) {
    if (!_completer.isCompleted) _completer.complete();
  }
}

class TestErrorInterceptorHandler extends ErrorInterceptorHandler {
  final Completer<void> _completer = Completer<void>();
  Future<void> get completed => _completer.future;

  @override
  void next(DioException err) {
    if (!_completer.isCompleted) _completer.complete();
  }

  @override
  void reject(DioException error, [bool callNext = false]) {
    if (!_completer.isCompleted) _completer.complete();
  }

  @override
  void resolve(Response response) {
    if (!_completer.isCompleted) _completer.complete();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeStorage fakeStorage;
  late TokenLocalDataSource tokenDataSource;
  late LocaleCubit localeCubit;
  late SharedPreferences prefs;

  setUp(() async {
    dotenv.testLoad(mergeWith: {'BASE_URL': 'https://ruya.runasp.net'});
    DioClient.resetInstance();
    fakeStorage = FakeStorage();
    tokenDataSource = TokenLocalDataSource(fakeStorage);
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    localeCubit = LocaleCubit(prefs);
  });

  group('DioClient Auth Interceptor', () {
    test('attaches Bearer Authorization header when token exists', () async {
      await tokenDataSource.saveToken('test-jwt-token');

      final dio = DioClient.getInstance(tokenDataSource, localeCubit);

      final options = RequestOptions(path: '/Chat/message');
      final handler = TestRequestInterceptorHandler();

      for (final interceptor in dio.interceptors) {
        if (interceptor is InterceptorsWrapper) {
          interceptor.onRequest(options, handler);
          await handler.completed;
          break;
        }
      }

      expect(options.headers['Authorization'], 'Bearer test-jwt-token');
    });

    test('prevents duplicate Bearer prefix if token is already prefixed', () async {
      await tokenDataSource.saveToken('Bearer already-prefixed-token');

      final dio = DioClient.getInstance(tokenDataSource, localeCubit);
      final options = RequestOptions(path: '/Chat/message');
      final handler = TestRequestInterceptorHandler();

      for (final interceptor in dio.interceptors) {
        if (interceptor is InterceptorsWrapper) {
          interceptor.onRequest(options, handler);
          await handler.completed;
          break;
        }
      }

      expect(options.headers['Authorization'], 'Bearer already-prefixed-token');
    });

    test('does not attach Authorization header when token is null or empty', () async {
      final dio = DioClient.getInstance(tokenDataSource, localeCubit);
      final options = RequestOptions(path: '/Chat/message');
      final handler = TestRequestInterceptorHandler();

      for (final interceptor in dio.interceptors) {
        if (interceptor is InterceptorsWrapper) {
          interceptor.onRequest(options, handler);
          await handler.completed;
          break;
        }
      }

      expect(options.headers['Authorization'], isNull);
    });

    test('clears token on 401 response in error interceptor', () async {
      await tokenDataSource.saveToken('expired-token');
      expect(await tokenDataSource.getToken(), 'expired-token');

      final dio = DioClient.getInstance(tokenDataSource, localeCubit);
      final reqOptions = RequestOptions(path: '/Chat/message');

      final dioError = DioException(
        requestOptions: reqOptions,
        response: Response(
          requestOptions: reqOptions,
          statusCode: 401,
        ),
      );

      for (final interceptor in dio.interceptors) {
        if (interceptor is InterceptorsWrapper) {
          final reqHandler = TestErrorInterceptorHandler();
          interceptor.onError(dioError, reqHandler);
          try {
            await reqHandler.completed;
          } catch (_) {}
        }
      }
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(await tokenDataSource.getToken(), isNull);
    });
  });

  group('DioClient Language Interceptor', () {
    test('injects default lang=en for /AdminSites request', () async {
      final dio = DioClient.getInstance(tokenDataSource, localeCubit);
      final options = RequestOptions(path: '/AdminSites');

      for (final interceptor in dio.interceptors) {
        if (interceptor is InterceptorsWrapper) {
          final handler = TestRequestInterceptorHandler();
          interceptor.onRequest(options, handler);
          try {
            await handler.completed;
          } catch (_) {}
        }
      }

      expect(options.queryParameters['lang'], 'en');
    });

    test('injects lang=ar for /AdminSites after locale change', () async {
      localeCubit.setLocale(const Locale('ar'));
      final dio = DioClient.getInstance(tokenDataSource, localeCubit);
      final options = RequestOptions(path: '/AdminSites/12');

      for (final interceptor in dio.interceptors) {
        if (interceptor is InterceptorsWrapper) {
          final handler = TestRequestInterceptorHandler();
          interceptor.onRequest(options, handler);
          try {
            await handler.completed;
          } catch (_) {}
        }
      }

      expect(options.queryParameters['lang'], 'ar');
    });

    test('injects lang=ar for /AdminArtifacts endpoints', () async {
      localeCubit.setLocale(const Locale('ar'));
      final dio = DioClient.getInstance(tokenDataSource, localeCubit);
      final options = RequestOptions(path: '/AdminArtifacts/5');

      for (final interceptor in dio.interceptors) {
        if (interceptor is InterceptorsWrapper) {
          final handler = TestRequestInterceptorHandler();
          interceptor.onRequest(options, handler);
          try {
            await handler.completed;
          } catch (_) {}
        }
      }

      expect(options.queryParameters['lang'], 'ar');
    });

    test('does not inject lang parameter on non-multilingual endpoints', () async {
      final dio = DioClient.getInstance(tokenDataSource, localeCubit);
      final options = RequestOptions(path: '/Chat/message');

      for (final interceptor in dio.interceptors) {
        if (interceptor is InterceptorsWrapper) {
          final handler = TestRequestInterceptorHandler();
          interceptor.onRequest(options, handler);
          try {
            await handler.completed;
          } catch (_) {}
        }
      }

      expect(options.queryParameters.containsKey('lang'), isFalse);
    });
  });
}
