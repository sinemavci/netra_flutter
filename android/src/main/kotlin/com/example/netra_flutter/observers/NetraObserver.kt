package com.example.netra_flutter.observers

import android.util.Log
import com.example.netra_flutter.clientEventHandlers
import com.google.gson.Gson
import com.netra.library.CacheEvent
import com.netra.library.INetraObserver
import com.netra.library.NetworkEvent
import com.netra.library.RequestQueuedEvent


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
        when (event) {
            is RequestQueuedEvent.RequestQueued -> {

            }

            is RequestQueuedEvent.QueuedRequestRestored -> {

            }

            is RequestQueuedEvent.QueuedRequestExecuted -> {

            }

            is RequestQueuedEvent.QueuedRequestFailed -> {

            }
        }
    }
}