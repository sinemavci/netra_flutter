import 'package:netra_flutter/common/observers/client_event.dart';

sealed class QueueEvent implements ClientEvent {
  final OnRequestQueued? onRequestQueued;
  final OnQueuedRequestFailed? onQueuedRequestFailed;
  final OnQueuedRequestExecuted? onQueuedRequestExecuted;
  final OnQueuedRequestRestored? onQueuedRequestRestored;

  const QueueEvent({
    this.onRequestQueued,
    this.onQueuedRequestFailed,
    this.onQueuedRequestExecuted,
    this.onQueuedRequestRestored,
  });

  factory QueueEvent.requestQueued(
      OnRequestQueued? onRequestQueued) = RequestQueued;

  factory QueueEvent.queuedRequestFailed(
      OnQueuedRequestFailed? onQueuedRequestFailed) = QueuedRequestFailed;

  factory QueueEvent.queuedRequestExecuted(
      OnQueuedRequestExecuted? onQueuedRequestExecuted) = QueuedRequestExecuted;

  factory QueueEvent.queuedRequestRestored(
      OnQueuedRequestRestored? onQueuedRequestRestored) = QueuedRequestRestored;
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

final class QueuedRequestExecuted extends QueueEvent {
  const QueuedRequestExecuted(OnQueuedRequestExecuted? onQueuedRequestExecuted)
      : super(onQueuedRequestExecuted: onQueuedRequestExecuted);

  @override
  String get eventName => 'QueuedRequestExecuted';
}

final class QueuedRequestRestored extends QueueEvent {
  const QueuedRequestRestored(OnQueuedRequestRestored? onQueuedRequestRestored)
      : super(onQueuedRequestRestored: onQueuedRequestRestored);

  @override
  String get eventName => 'QueuedRequestRestored';
}