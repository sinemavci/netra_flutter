package com.example.netra_flutter.controller

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.example.netra_flutter.ClientEventHandler
import com.example.netra_flutter.NetraControllerPigeon.NetraHostApi
import com.example.netra_flutter.StreamResponseEventHandler
import com.example.netra_flutter.observers
import com.example.netra_flutter.clientEventHandlers
import com.example.netra_flutter.dto.CircuitBreakerOptionsDTO
import com.example.netra_flutter.dto.RequestBodyDTO
import com.example.netra_flutter.dto.ResponseDTO
import com.example.netra_flutter.dto.RequestOptionsDTO
import com.example.netra_flutter.observers.NetraObserver
import com.example.netra_flutter.streamResponseEventHandlers
import com.google.gson.Gson
import com.netra.library.Cache
import com.netra.library.NetraClient
import com.netra.library.NetraClientList
import com.netra.library.NetraRequestBody
import com.netra.library.converter.NetraGsonConverter
import com.netra.library.converter.NetraKotlinxConverter
import com.netra.library.converter.NetraMoshiConverter
import com.netra.library.enums.OfflinePolicyAction
import com.netra.library.enums.SlowNetworkPolicyAction
import io.flutter.plugin.common.BinaryMessenger
import kotlin.text.set

class NetraServiceController(val context: Context, val binaryMessenger: BinaryMessenger) : NetraHostApi {
    val gson = Gson()
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun get(
        clientId: String,
        requestOptions: String,
        callback: (Result<String?>) -> Unit
    ) {
        val client = NetraClientList.getClients().find { it.id == clientId }
        val requestOptionsDto = requestOptions.let {
            gson.fromJson(it, RequestOptionsDTO::class.java)
        }
        val offlinePolicyAction: OfflinePolicyAction? =
            requestOptionsDto?.offlinePolicyAction?.toDataModel()
        val slowNetworkPolicyAction: SlowNetworkPolicyAction? =
            requestOptionsDto?.slowNetworkPolicyAction?.toDataModel()
        val cache: Cache? = requestOptionsDto?.cacheOptions?.toDataModel()
        val headers = requestOptionsDto?.headers
        val path = requestOptionsDto.url

        if (client != null) {
            val requestBuilder = client.get(path).addHeaders(headers ?: emptyMap()).asObject<Any>()
            offlinePolicyAction?.let {
                requestBuilder.whenOffline(offlinePolicyAction)
            }
            slowNetworkPolicyAction?.let {
                requestBuilder.whenSlowNetwork(slowNetworkPolicyAction)
            }
            cache?.let {
                requestBuilder.withCache(it)
            }
            val response = requestBuilder.execute()
            val result = gson.toJson(ResponseDTO.fromDataModel(response))
            callback.invoke(Result.success(result))

        } else {
            callback.invoke(Result.failure(Exception("Client not found!")))
        }
    }

    override fun post(
        clientId: String,
        data: String?,
        requestOptions: String,
        callback: (Result<String?>) -> Unit
    ) {
        val client = NetraClientList.getClients().find { it.id == clientId }
        val requestOptionsDto = requestOptions.let {
            gson.fromJson(it, RequestOptionsDTO::class.java)
        }
        val requestBody = data?.let {
            gson.fromJson(it, RequestBodyDTO::class.java).toDataModel()
        } ?: NetraRequestBody.EMPTY
        val offlinePolicyAction: OfflinePolicyAction? =
            requestOptionsDto?.offlinePolicyAction?.toDataModel()
        val slowNetworkPolicyAction: SlowNetworkPolicyAction? =
            requestOptionsDto?.slowNetworkPolicyAction?.toDataModel()
        val cache: Cache? = requestOptionsDto?.cacheOptions?.toDataModel()
        val headers = requestOptionsDto?.headers
        val path = requestOptionsDto.url

        if (client != null) {
            val requestBuilder =
                client.post(path, requestBody).addHeaders(headers ?: emptyMap()).asObject<Any>()
            offlinePolicyAction?.let {
                requestBuilder.whenOffline(offlinePolicyAction)
            }
            slowNetworkPolicyAction?.let {
                requestBuilder.whenSlowNetwork(slowNetworkPolicyAction)
            }
            cache?.let {
                requestBuilder.withCache(it)
            }
            val response = requestBuilder.execute()
            val result = gson.toJson(ResponseDTO.fromDataModel(response))
            callback.invoke(Result.success(result))

        } else {
            callback.invoke(Result.failure(Exception("Client not found!")))
        }
    }

    override fun put(
        clientId: String,
        data: String?,
        requestOptions: String,
        callback: (Result<String?>) -> Unit
    ) {
        val client = NetraClientList.getClients().find { it.id == clientId }
        val requestOptionsDto = requestOptions.let {
            gson.fromJson(it, RequestOptionsDTO::class.java)
        }
        val requestBody = data?.let {
            gson.fromJson(it, RequestBodyDTO::class.java).toDataModel()
        } ?: NetraRequestBody.EMPTY
        val offlinePolicyAction: OfflinePolicyAction? =
            requestOptionsDto?.offlinePolicyAction?.toDataModel()
        val slowNetworkPolicyAction: SlowNetworkPolicyAction? =
            requestOptionsDto?.slowNetworkPolicyAction?.toDataModel()
        val headers = requestOptionsDto?.headers
        val cache: Cache? = requestOptionsDto?.cacheOptions?.toDataModel()
        val path = requestOptionsDto.url

        if (client != null) {
            val requestBuilder =
                client.put(path, requestBody).addHeaders(headers ?: emptyMap()).asObject<Any>()
            offlinePolicyAction?.let {
                requestBuilder.whenOffline(offlinePolicyAction)
            }
            slowNetworkPolicyAction?.let {
                requestBuilder.whenSlowNetwork(slowNetworkPolicyAction)
            }
            cache?.let {
                requestBuilder.withCache(it)
            }
            val response = requestBuilder.execute()
            val result = gson.toJson(ResponseDTO.fromDataModel(response))
            callback.invoke(Result.success(result))

        } else {
            callback.invoke(Result.failure(Exception("Client not found!")))
        }
    }

    override fun patch(
        clientId: String,
        data: String?,
        requestOptions: String,
        callback: (Result<String?>) -> Unit
    ) {
        val client = NetraClientList.getClients().find { it.id == clientId }
        val requestOptionsDto = requestOptions.let {
            gson.fromJson(it, RequestOptionsDTO::class.java)
        }
        val requestBody = data?.let {
            gson.fromJson(it, RequestBodyDTO::class.java).toDataModel()
        } ?: NetraRequestBody.EMPTY
        val offlinePolicyAction: OfflinePolicyAction? =
            requestOptionsDto?.offlinePolicyAction?.toDataModel()
        val slowNetworkPolicyAction: SlowNetworkPolicyAction? =
            requestOptionsDto?.slowNetworkPolicyAction?.toDataModel()
        val cache: Cache? = requestOptionsDto?.cacheOptions?.toDataModel()
        val headers = requestOptionsDto?.headers
        val path = requestOptionsDto.url

        if (client != null) {
            val requestBuilder =
                client.patch(path, requestBody).addHeaders(headers ?: emptyMap()).asObject<Any>()
            offlinePolicyAction?.let {
                requestBuilder.whenOffline(offlinePolicyAction)
            }
            slowNetworkPolicyAction?.let {
                requestBuilder.whenSlowNetwork(slowNetworkPolicyAction)
            }
            cache?.let {
                requestBuilder.withCache(it)
            }
            val response = requestBuilder.execute()
            val result = gson.toJson(ResponseDTO.fromDataModel(response))
            callback.invoke(Result.success(result))

        } else {
            callback.invoke(Result.failure(Exception("Client not found!")))
        }
    }

    override fun delete(
        clientId: String,
        data: String?,
        requestOptions: String,
        callback: (Result<String?>) -> Unit
    ) {
        val client = NetraClientList.getClients().find { it.id == clientId }
        val requestOptionsDto = requestOptions.let {
            gson.fromJson(it, RequestOptionsDTO::class.java)
        }
        val requestBody = data?.let {
            gson.fromJson(it, RequestBodyDTO::class.java).toDataModel()
        } ?: NetraRequestBody.EMPTY
        val offlinePolicyAction: OfflinePolicyAction? =
            requestOptionsDto?.offlinePolicyAction?.toDataModel()
        val slowNetworkPolicyAction: SlowNetworkPolicyAction? =
            requestOptionsDto?.slowNetworkPolicyAction?.toDataModel()
        val cache: Cache? = requestOptionsDto?.cacheOptions?.toDataModel()
        val headers = requestOptionsDto?.headers
        val path = requestOptionsDto.url

        if (client != null) {
            val requestBuilder =
                client.delete(path, requestBody).addHeaders(headers ?: emptyMap()).asObject<Any>()
            offlinePolicyAction?.let {
                requestBuilder.whenOffline(offlinePolicyAction)
            }
            slowNetworkPolicyAction?.let {
                requestBuilder.whenSlowNetwork(slowNetworkPolicyAction)
            }
            cache?.let {
                requestBuilder.withCache(it)
            }
            val response = requestBuilder.execute()
            val result = gson.toJson(ResponseDTO.fromDataModel(response))
            callback.invoke(Result.success(result))

        } else {
            callback.invoke(Result.failure(Exception("Client not found!")))
        }
    }

    fun getStreamResponseEventHandler(id: String): StreamResponseEventHandler? {
        return streamResponseEventHandlers.getOrPut(id) {
            StreamResponseEventHandler(binaryMessenger, id)
        }
    }

    override fun stream(
        clientId: String,
        requestOptions: String,
        callback: (Result<Unit>) -> Unit
    ) {
        val client = NetraClientList.getClients().find { it.id == clientId }
        val requestOptionsDto = requestOptions.let {
            gson.fromJson(it, RequestOptionsDTO::class.java)
        }
        val offlinePolicyAction: OfflinePolicyAction? =
            requestOptionsDto?.offlinePolicyAction?.toDataModel()
        val slowNetworkPolicyAction: SlowNetworkPolicyAction? =
            requestOptionsDto?.slowNetworkPolicyAction?.toDataModel()
        val cache: Cache? = requestOptionsDto?.cacheOptions?.toDataModel()
        val headers = requestOptionsDto?.headers
        val path = requestOptionsDto.url
        val requestId = requestOptionsDto.id

        if (client != null) {
            val requestBuilder = client.get(path).addHeaders(headers ?: emptyMap()).asObject<Any>()
            offlinePolicyAction?.let {
                requestBuilder.whenOffline(offlinePolicyAction)
            }
            slowNetworkPolicyAction?.let {
                requestBuilder.whenSlowNetwork(slowNetworkPolicyAction)
            }
            cache?.let {
                requestBuilder.withCache(it)
            }
            requestBuilder.executeStream(
                onStreamReady = { inputStream ->
                    val buffer = ByteArray(8192)
                    var bytesRead: Int

                    while (inputStream.read(buffer).also { bytesRead = it } != -1) {
                        val chunk = buffer.copyOfRange(0, bytesRead)
                        mainHandler.post {
                            streamResponseEventHandlers[requestId]?.send(chunk)
                        }
                    }
                    mainHandler.post {
                        streamResponseEventHandlers[requestId]?.endOfStream()
                    }
                                },
                onFailure = { exception ->
                    mainHandler.post {
                        streamResponseEventHandlers[requestId]?.onCancel(null)
                        callback.invoke(Result.failure(exception))
                    }
                })
        } else {
            callback.invoke(Result.failure(Exception("Client not found!")))
        }
    }

    override fun registerStream(
        requestId: String,
        callback: (Result<Boolean>) -> Unit
    ) {
        streamResponseEventHandlers[requestId] = getStreamResponseEventHandler(requestId)
        callback.invoke(Result.success(true))
    }

    override fun on(
        clientId: String,
        eventName: String,
        eventId: String,
        callback: (Result<Boolean>) -> Unit
    ) {
        if (observers.contains(clientId)) {
            observers[clientId]?.on(
                eventName,
                eventId
            )
        } else {
            val obs = NetraObserver(clientId)
            observers[clientId] = obs
            obs.on(eventName, eventId)
            val client = NetraClientList.getClients().find { client -> client.id == clientId }
            client?.addObserver(obs)
        }
        callback.invoke(Result.success(true))
    }

    override fun off(clientId: String, eventId: String, callback: (Result<Boolean>) -> Unit) {
        val observer = observers[clientId]
        observer?.let {
            it.off(eventId)
            if (it.hasNoListeners()) {
                val client =
                    NetraClientList.getClients().find { client -> client.id == clientId }
                client?.removeObserver(it)
                observers.remove(clientId)
            }
        }
        callback.invoke(Result.success(true))
    }

    override fun build(
        baseUrl: String,
        convertedType: String?,
        headers: Map<String, String>?,
        circuitBreakerOptions: String?,
        callback: (Result<String?>) -> Unit
    ) {
        try {
            val clientBuilder: NetraClient.Builder = NetraClient.Builder(context)
                .baseUrl(baseUrl)
            val circuitBreakerOptionsDto = circuitBreakerOptions?.let {
                gson.fromJson(it, CircuitBreakerOptionsDTO::class.java)
            }
            circuitBreakerOptionsDto.let {
                if (it?.failureThreshold != null && it.retryDelayMs != null) {
                    Log.e(
                        "",
                        "circuit breaker adding in bridge: failureThreshold${it?.failureThreshold} retryDelayMs${it?.retryDelayMs}"
                    )
                    clientBuilder.circuitBreaker(it.failureThreshold, it.retryDelayMs)
                }
            }
            headers?.let {
                clientBuilder.addHeaders(it)
            }
            if (convertedType !== null) {
                when (convertedType) {
                    NetraMoshiConverter().type -> {
                        clientBuilder.addConverterFactory(NetraMoshiConverter())
                    }

                    NetraGsonConverter().type -> {
                        clientBuilder.addConverterFactory(NetraGsonConverter())
                    }

                    NetraKotlinxConverter().type -> {
                        clientBuilder.addConverterFactory(NetraKotlinxConverter())
                    }
                }
            }

            val client = clientBuilder.build()
            NetraClientList.add(client)
            clientEventHandlers[client.id] = ClientEventHandler(binaryMessenger, client.id)
            callback(Result.success(client.id))
        } catch (e: Error) {
            Log.e("", "build error: ${e}")
            //todo
            // Result.failure(Throwable(e));
        }
    }
}