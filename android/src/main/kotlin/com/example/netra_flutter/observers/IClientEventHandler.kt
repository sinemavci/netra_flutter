package com.example.netra_flutter.observers

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

abstract class IClientEventHandler(
    eventName: String,
    messenger: BinaryMessenger
) : EventChannel.StreamHandler {

    private val eventChannel = EventChannel(messenger, eventName)

    private var eventSink: EventChannel.EventSink? = null

    private val cachedEvents = mutableListOf<Any>()

    init {
        eventChannel.setStreamHandler(this)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        cachedEvents.forEach {
            eventSink?.success(it)
        }

        cachedEvents.clear()
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun endOfStream() {
        eventSink?.endOfStream()
    }

    fun send(data: Any) {
        if (eventSink == null) {
            cachedEvents.add(data)
        } else {
            eventSink?.success(data)
        }
    }
}