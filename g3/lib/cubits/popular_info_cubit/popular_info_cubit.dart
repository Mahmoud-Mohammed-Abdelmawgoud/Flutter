import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/popular_info_model.dart';
import '../../requests/popular_request.dart';

part 'popular_info_state.dart';

class PopularInfoCubit extends Cubit<PopularInfoState> {
  PopularInfoCubit() : super(PopularInfoInitial());

  static PopularInfoCubit get(context) => BlocProvider.of(context);

  PopularInfoModel popularInfoModel = PopularInfoModel();

  void getPopularInfo({required int id}) {
    emit(PopularInfoLoading());
    PopularRequest.getPopularInfo(
      id: id,
      onSuccess: (res) {
        popularInfoModel = res;
        emit(PopularInfoDone(popularInfoModel)); // Passing the required argument
      },
      onError: (statusCode) {
        emit(PopularInfoError(statusCode.toString())); // Passing the error message as required
        log(statusCode.toString());
      },
    );
  }
}
