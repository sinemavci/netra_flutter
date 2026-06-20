package com.example.netra_flutter.observers

import com.example.netra_flutter.clientEventHandlers
import com.example.netra_flutter.dto.RequestOptionsDTO
import com.example.netra_flutter.dto.ResponseDTO
import com.google.gson.Gson
import com.netra.library.observers.CacheEvent
import com.netra.library.observers.INetraObserver
import com.netra.library.observers.NetworkEvent
import com.netra.library.observers.QueueEvent
import com.netra.library.observers.RequestEvent

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
                                    "ageMs" to event.ageMs,
                                    "ttlMs" to event.ttlMs,
                                    "request" to RequestOptionsDTO.fromDataModel(event.request.toConfig()),
                                )
                            }

                            is CacheEvent.StaleCacheUsed -> {
                                mutableMapOf(
                                    "ageMs" to event.ageMs,
                                    "ttlMs" to event.ttlMs,
                                    "expiredByMs" to event.expiredByMs,
                                    "request" to RequestOptionsDTO.fromDataModel(event.request.toConfig()),
                                )
                            }

                            is CacheEvent.CacheMiss -> {
                                mutableMapOf(
                                    "request" to RequestOptionsDTO.fromDataModel(event.request.toConfig()),
                                )
                            }

                            is CacheEvent.CacheExpired -> {
                                mutableMapOf(
                                    "ageMs" to event.ageMs,
                                    "ttlMs" to event.ttlMs,
                                    "expiredByMs" to event.expiredByMs,
                                    "request" to RequestOptionsDTO.fromDataModel(event.request.toConfig()),
                                )
                            }

                            is CacheEvent.CacheStored -> {
                                mutableMapOf(
                                    "ageMs" to event.ageMs,
                                    "sizeByte" to event.sizeByte,
                                    "request" to RequestOptionsDTO.fromDataModel(event.request.toConfig()),
                                )
                            }
                        }
            )
            val clientEventHandler = clientEventHandlers[clientId]
            clientEventHandler?.send(gson.toJson(sender))
        }
    }

    override fun onRequestChanged(event: RequestEvent) {
        val parsedEventName = event::class.simpleName

        if (listenerEvents.any { item -> item.value == parsedEventName }) {
            val sender = mutableMapOf(
                "EventName" to parsedEventName,
                "Value" to
                        when (event) {
                            is RequestEvent.RequestExecuted -> {
                                mutableMapOf(
                                    "request" to RequestOptionsDTO.fromDataModel(event.request.toConfig()),
                                )
                            }

                            is RequestEvent.RequestSuccess -> {
                                mutableMapOf(
                                    "response" to ResponseDTO.fromDataModel(event.response),
                                    "request" to RequestOptionsDTO.fromDataModel(event.request.toConfig()),
                                )
                            }

                            is RequestEvent.RequestFailed -> {
                                mutableMapOf(
                                    "response" to ResponseDTO.fromDataModel(event.response),
                                    "request" to RequestOptionsDTO.fromDataModel(event.request.toConfig()),
                                )
                            }
                        }
            )
            val clientEventHandler = clientEventHandlers[clientId]
            clientEventHandler?.send(gson.toJson(sender))
        }
    }

    override fun onQueueChanged(event: QueueEvent) {
        val parsedEventName = event::class.simpleName

        if (listenerEvents.any { item -> item.value == parsedEventName }) {
            val sender = mutableMapOf(
                "EventName" to parsedEventName,
                "Value" to
                        when (event) {
                            is QueueEvent.RequestQueued -> {
                                mutableMapOf(
                                    "url" to event.url,
                                    "queueOrder" to event.queueOrder,
                                    "createdAt" to event.createdAt,
                                )
                            }

                            is QueueEvent.QueuedRequestRestored -> {
                                mutableMapOf("url" to event.url)
                            }

                            is QueueEvent.QueuedRequestExecuted -> {
                                mutableMapOf(
                                    "url" to event.url,
                                    "response" to ResponseDTO.fromDataModel(event.response),
                                )
                            }

                            is QueueEvent.QueuedRequestFailed -> {
                                mutableMapOf("url" to event.url)
                            }
                        }
            )
            val clientEventHandler = clientEventHandlers[clientId]
            clientEventHandler?.send(gson.toJson(sender))
        }
    }
}