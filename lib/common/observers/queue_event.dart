import 'package:netra_flutter/common/observers/client_event.dart';

sealed class QueueEvent implements ClientEvent {
  final OnRequestQueued? onRequestQueued;
  final OnQueuedRequestFailed? onQueuedRequestFailed;
  final OnQueuedRequestSuccess? onQueuedRequestSuccess;
  final OnQueuedRequestExecuted? onQueuedRequestExecuted;

  const QueueEvent({
    this.onRequestQueued,
    this.onQueuedRequestFailed,
    this.onQueuedRequestExecuted,
    this.onQueuedRequestSuccess,
  });

  factory QueueEvent.requestQueued(
      OnRequestQueued? onRequestQueued) = RequestQueued;

  factory QueueEvent.queuedRequestFailed(
      OnQueuedRequestFailed? onQueuedRequestFailed) = QueuedRequestFailed;

  factory QueueEvent.queuedRequestExecuted(
      OnQueuedRequestSuccess? onQueuedRequestExecuted) = QueuedRequestSuccess;

  factory QueueEvent.queuedRequestRestored(
      OnQueuedRequestExecuted? onQueuedRequestRestored) = QueuedRequestExecuted;
}

final class RequestQueued extends QueueEvent {
  const RequestQueued(OnRequestQueued? onRequestQueued)
      : super(onRequestQueued: onRequestQueued);

  @override
  String get eventName => 'RequestQueued';
}

final class QueuedRequestFailed extends QueueEvent {
  const QueuedRequestFailed(OnQueuedRequestFailed? onQueuedRequestFailed)
      : super(onQueuedRequestFailed: onQueuedRequestFailed);

  @override
  String get eventName => 'QueuedRequestFailed';
}

final class QueuedRequestSuccess extends QueueEvent {
  const QueuedRequestSuccess(OnQueuedRequestSuccess? onQueuedRequestSuccess)
      : super(onQueuedRequestSuccess: onQueuedRequestSuccess);

  @override
  String get eventName => 'QueuedRequestSuccess';
}

final class QueuedRequestExecuted extends QueueEvent {
  const QueuedRequestExecuted(OnQueuedRequestExecuted? onQueuedRequestExecuted)
      : super(onQueuedRequestExecuted: onQueuedRequestExecuted);

  @override
  String get eventName => 'QueuedRequestExecuted';
}