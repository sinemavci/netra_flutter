import 'package:netra_flutter/common/observers/client_event.dart';

sealed class RequestEvent implements ClientEvent {
  final OnRequestExecuted? onRequestExecuted;
  final OnRequestSuccess? onRequestSuccess;
  final OnRequestFailed? onRequestFailed;

  const RequestEvent({
    this.onRequestExecuted,
    this.onRequestSuccess,
    this.onRequestFailed,
  });

  factory RequestEvent.requestExecuted(OnRequestExecuted? onRequestExecuted) = RequestExecuted;

  factory RequestEvent.requestSuccess(OnRequestSuccess? onRequestSuccess) = RequestSuccess;

  factory RequestEvent.requestFailed(OnRequestFailed? onRequestFailed) = RequestFailed;
}

final class RequestExecuted extends RequestEvent {
  const RequestExecuted(OnRequestExecuted? onRequestExecuted) : super(onRequestExecuted: onRequestExecuted);

  @override
  String get eventName => 'RequestExecuted';
}

final class RequestSuccess extends RequestEvent {
  const RequestSuccess(OnRequestSuccess? onRequestSuccess): super(onRequestSuccess: onRequestSuccess);

  @override
  String get eventName => 'RequestSuccess';
}

final class RequestFailed extends RequestEvent {
  const RequestFailed(OnRequestFailed? onRequestFailed)
      : super(onRequestFailed: onRequestFailed);

  @override
  String get eventName => 'RequestFailed';
}