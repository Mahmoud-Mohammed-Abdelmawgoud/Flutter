part of 'popular_info_cubit.dart';

@immutable
abstract class PopularInfoState {}

class PopularInfoInitial extends PopularInfoState {}

class PopularInfoLoading extends PopularInfoState {}

class PopularInfoDone extends PopularInfoState {
  final PopularInfoModel info;
  PopularInfoDone(this.info);
}

class PopularInfoError extends PopularInfoState {
  final String message;
  PopularInfoError(this.message);
}
