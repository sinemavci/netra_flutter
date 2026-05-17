package com.example.netra_flutter.observers

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

abstract class IClientEventHandler(eventName: String, messenger: BinaryMessenger) : EventChannel.StreamHandler {
    private val eventChannel = EventChannel(messenger, eventName)
    private var eventSink: EventChannel.EventSink? = null

    private var cachedEvent: Any? = null

    init {
        eventChannel.setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        if (cachedEvent != null) {
            eventSink?.success(cachedEvent)
            cachedEvent = null
        }
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun send(data: Any) {
        if (eventSink == null) {
            cachedEvent = data
        } else {
            eventSink?.success(data)
        }
    }
}