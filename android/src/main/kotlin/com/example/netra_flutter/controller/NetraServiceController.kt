package com.example.netra_flutter.controller

import android.content.Context
import android.util.Log
import com.example.netra_flutter.NetraControllerPigeon.NetraHostApi
import com.example.netra_flutter.dto.RequestBodyDTO
import com.example.netra_flutter.dto.ResponseDTO
import com.example.netra_flutter.dto.RequestOptionsDTO
import com.google.gson.Gson
import com.netra.library.NetraClient
import com.netra.library.NetraClientList
import com.netra.library.NetraRequestBody
import com.netra.library.converter.NetraGsonConverter
import com.netra.library.converter.NetraKotlinxConverter
import com.netra.library.converter.NetraMoshiConverter
import com.netra.library.enums.OfflinePolicyAction
import com.netra.library.enums.SlowNetworkPolicyAction

class NetraServiceController(val context: Context) : NetraHostApi {
    override fun get(
        clientId: String,
        path: String,
        requestOptions: String?,
        callback: (Result<String?>) -> Unit
    ) {
        val gson = Gson()
        val client = NetraClientList.getClients().find { it.id == clientId }
        val requestOptionsDto = requestOptions?.let {
            gson.fromJson(it, RequestOptionsDTO::class.java)
        }
        val offlinePolicyAction: OfflinePolicyAction? = requestOptionsDto?.offlinePolicyAction?.toDataModel()
        val slowNetworkPolicyAction: SlowNetworkPolicyAction? = requestOptionsDto?.slowNetworkPolicyAction?.toDataModel()

        if (client != null) {
            val requestBuilder = client.get(path).asObject<Any>()
            offlinePolicyAction?.let {
                Log.e("", "bridge setted offline policy action as: ${offlinePolicyAction.identifier}")
                requestBuilder.whenOffline(offlinePolicyAction)
            }
            slowNetworkPolicyAction?.let {
                Log.e("", "bridge setted slow network policy action as: ${slowNetworkPolicyAction.identifier}")
                requestBuilder.whenSlowNetwork(slowNetworkPolicyAction)
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
        path: String,
        data: String?,
        requestOptions: String?,
        callback: (Result<String?>) -> Unit
    ) {
        val gson = Gson()
        val client = NetraClientList.getClients().find { it.id == clientId }
        val requestOptionsDto = requestOptions?.let {
            gson.fromJson(it, RequestOptionsDTO::class.java)
        }
        val requestBody = data?.let {
            gson.fromJson(it, RequestBodyDTO::class.java).toDataModel()
        } ?: NetraRequestBody.EMPTY
        val offlinePolicyAction: OfflinePolicyAction? = requestOptionsDto?.offlinePolicyAction?.toDataModel()
        val slowNetworkPolicyAction: SlowNetworkPolicyAction? = requestOptionsDto?.slowNetworkPolicyAction?.toDataModel()

        if (client != null) {
            val requestBuilder = client.post(path, requestBody).asObject<Any>()
            offlinePolicyAction?.let {
                Log.e("", "bridge setted offline policy action as: ${offlinePolicyAction.identifier}")
                requestBuilder.whenOffline(offlinePolicyAction)
            }
            slowNetworkPolicyAction?.let {
                Log.e("", "bridge setted slow network policy action as: ${slowNetworkPolicyAction.identifier}")
                requestBuilder.whenSlowNetwork(slowNetworkPolicyAction)
            }
            val response = requestBuilder.execute()
            val result = gson.toJson(ResponseDTO.fromDataModel(response))
            callback.invoke(Result.success(result))

        } else {
            callback.invoke(Result.failure(Exception("Client not found!")))
        }
    }

    override fun build(
        baseUrl: String,
        convertedType: String?,
        callback: (Result<String?>) -> Unit
    ) {
        try {
            val clientBuilder: NetraClient.Builder = NetraClient.Builder(context)
                .baseUrl(baseUrl)
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
            callback(Result.success(client.id))
        } catch (e: Error) {
            Log.e("", "build error: ${e}")
            //todo
            // Result.failure(Throwable(e));
        }
    }
}