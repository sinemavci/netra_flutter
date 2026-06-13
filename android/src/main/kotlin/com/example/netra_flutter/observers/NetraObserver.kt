package com.example.netra_flutter.observers

import android.util.Log
import com.example.netra_flutter.clientEventHandlers
import com.example.netra_flutter.dto.ResponseDTO
import com.google.gson.Gson
import com.netra.library.observers.CacheEvent
import com.netra.library.observers.INetraObserver
import com.netra.library.observers.NetworkEvent
import com.netra.library.observers.RequestEvent
import com.netra.library.observers.RequestQueuedEvent
import com.netra.library.observers.ResponseEvent


class NetraObserver(val clientId: String): INetraObserver {
    private val gson = Gson()
    private val listenerEvents = mutableMapOf<String, String>()

    fun on(eventName: String, eventId: String) {
        if (!listenerEvents.containsKey(eventId)) {
            listenerEvents[eventId] = eventName
        }
    }

    fun off(eventId: String) {
        listenerEvents.remove(eventId)
    }

    fun hasNoListeners(): Boolean {
        return listenerEvents.isEmpty()
    }

    override fun onNetworkChanged(event: NetworkEvent) {
        val parsedEventName = event::class.simpleName

        if (listenerEvents.any { item -> item.value == parsedEventName }) {
            val sender = mutableMapOf(
                "EventName" to parsedEventName,
            )
            val clientEventHandler = clientEventHandlers[clientId]
            clientEventHandler?.send(gson.toJson(sender))
        }
    }

    override fun onCacheChanged(event: CacheEvent) {
        val parsedEventName = event::class.simpleName

        if (listenerEvents.any { item -> item.value == parsedEventName }) {
            val sender = mutableMapOf(
                "EventName" to parsedEventName,
                "Value" to
                        when (event) {
                            is CacheEvent.CacheHit -> {
                                mutableMapOf(
                                    "key" to event.key,
                                    "ageMs" to event.ageMs,
                                    "ttlMs" to event.ttlMs,
                                )
                            }

                            is CacheEvent.StaleCacheUsed -> {
                                mutableMapOf(
                                    "key" to event.key,
                                    "ageMs" to event.ageMs,
                                    "ttlMs" to event.ttlMs,
                                    "expiredByMs" to event.expiredByMs,
                                )
                            }

                            is CacheEvent.CacheMiss -> {
                                mutableMapOf(
                                    "key" to event.key,
                                )
                            }

                            is CacheEvent.CacheExpired -> {
                                mutableMapOf(
                                    "key" to event.key,
                                    "ageMs" to event.ageMs,
                                    "ttlMs" to event.ttlMs,
                                    "expiredByMs" to event.expiredByMs,
                                )
                            }

                            is CacheEvent.CacheStored -> {
                                mutableMapOf(
                                    "key" to event.key,
                                    "ageMs" to event.ageMs,
                                    "sizeByte" to event.sizeByte,
                                )
                            }
                        }
            )
            val clientEventHandler = clientEventHandlers[clientId]
            clientEventHandler?.send(gson.toJson(sender))
        }
    }

    override fun onQueueChanged(event: RequestQueuedEvent) {
        val parsedEventName = event::class.simpleName

        if (listenerEvents.any { item -> item.value == parsedEventName }) {
            val sender = mutableMapOf(
                "EventName" to parsedEventName,
                "Value" to
                        when (event) {
                            is RequestQueuedEvent.RequestQueued -> {
                                mutableMapOf(
                                    "key" to event.key,
                                    "queueOrder" to event.queueOrder,
                                    "createdAt" to event.createdAt,
                                )
                            }

                            is RequestQueuedEvent.QueuedRequestRestored -> {
                                mutableMapOf("key" to event.key)
                            }

                            is RequestQueuedEvent.QueuedRequestExecuted -> {
                                mutableMapOf(
                                    "key" to event.key,
                                    "response" to ResponseDTO.fromDataModel(event.response),
                                )
                            }

                            is RequestQueuedEvent.QueuedRequestFailed -> {
                                mutableMapOf("key" to event.key)
                            }
                        }
            )
            val clientEventHandler = clientEventHandlers[clientId]
            clientEventHandler?.send(gson.toJson(sender))
        }
    }

    override fun onRequestExecuted(event: RequestEvent) {
        TODO("Not yet implemented")
    }

    override fun onResponseReceived(event: ResponseEvent) {
        val parsedEventName = event::class.simpleName

        if (listenerEvents.any { item -> item.value == parsedEventName }) {
            val sender = mutableMapOf(
                "EventName" to parsedEventName,
                "Value" to when (event) {
                    is ResponseEvent.ResponseReceived -> {
                        mutableMapOf(
                            "key" to event.key,
                            "response" to ResponseDTO.fromDataModel(event.response),
                        )
                    }
                }
            )

            val clientEventHandler = clientEventHandlers[clientId]
            clientEventHandler?.send(gson.toJson(sender))
        }
    }
}