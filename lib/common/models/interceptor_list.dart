import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netra_flutter/common/controllers/netra_controller.dart';
import 'package:netra_flutter/common/models/interceptor.dart';

class InterceptorList {
  @protected
  final String clientId;

  InterceptorList({required this.clientId});

  @protected
  late final controller = NetraController();

  @protected
  final List<Interceptor> interceptors = [];

  List<Interceptor> getInterceptors() {
    return interceptors;
  }

  // FutureOr<void> add(Interceptor interceptor) async {
  //   try {
  //     await controller.addInterceptor(() {
  //       print("case 1");
  //      // interceptor.intercept(chain);
  //     });
  //   } catch (e) {
  //     print("error while add interceptor: ${e}");
  //   }
  // }
}