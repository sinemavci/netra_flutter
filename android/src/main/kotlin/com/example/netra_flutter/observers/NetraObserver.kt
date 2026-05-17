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
        print("_startListening in kt: ${clientId}");
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
            Log.e("clientEventHandler", "clientEventHandler: ${clientId} ${clientEventHandler}")
            clientEventHandler?.send(gson.toJson(sender))
        }
    }

    override fun onCacheChanged(event: CacheEvent) {
        when (event) {
            is CacheEvent.CacheHit -> {

            }

            is CacheEvent.StaleCacheUsed -> {

            }

            is CacheEvent.CacheMiss -> {

            }

            is CacheEvent.CacheExpired -> {

            }

            is CacheEvent.CacheStored -> {

            }
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