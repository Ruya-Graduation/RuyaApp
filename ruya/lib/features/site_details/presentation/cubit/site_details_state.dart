import 'package:equatable/equatable.dart';
import 'package:ruya/features/site_details/domain/entities/site_detail_entity.dart';

enum SiteDetailsStatus { initial, loading, loaded, error }

class SiteDetailsState extends Equatable {
  final SiteDetailsStatus status;
  final SiteDetailEntity? site;
  final String? errorMessage;

  const SiteDetailsState({
    this.status = SiteDetailsStatus.initial,
    this.site,
    this.errorMessage,
  });

  SiteDetailsState copyWith({
    SiteDetailsStatus? status,
    SiteDetailEntity? site,
    Object? errorMessage = _keep,
  }) {
    return SiteDetailsState(
      status: status ?? this.status,
      site: site ?? this.site,
      errorMessage:
          errorMessage == _keep ? this.errorMessage : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, site, errorMessage];
}

/// Sentinel value used in [SiteDetailsState.copyWith] to distinguish
/// between "don't change" and "set to null".
const Object _keep = Object();
