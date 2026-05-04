package com.example.netra_flutter.controller

import android.content.Context
import android.util.Log
import com.example.netra_flutter.NetraControllerPigeon.NetraHostApi
import com.example.netra_flutter.dto.NetraResponseDTO
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.netra.library.NetraClient
import com.netra.library.NetraClientList
import com.netra.library.NetraResponse
import com.netra.library.converter.NetraGsonConverter
import com.netra.library.converter.NetraKotlinxConverter
import com.netra.library.converter.NetraMoshiConverter
import com.netra.library.enums.OfflinePolicyAction
import com.netra.library.enums.Status
class NetraServiceController(val context: Context) : NetraHostApi {
    override fun get(
        clientId: String,
        path: String,
        requestOptions: String?,
        callback: (Result<String?>) -> Unit
    ) {
        val gson = Gson()
        val client = NetraClientList.getClients().find { it.id == clientId }
        val type = object : TypeToken<Map<String, Any>>() {}.type
        val parsedMap = gson.fromJson<Map<String, Any>>(requestOptions, type)

        val _offlinePolicyAction = parsedMap["offlinePolicyAction"] as? Map<*, *>
        val identifier = _offlinePolicyAction?.get("identifier") as? String
        val retries = (_offlinePolicyAction?.get("retries") as? Double)?.toInt()
        var offlinePolicyAction: OfflinePolicyAction? = null
        if (_offlinePolicyAction != null && identifier != null) {
            offlinePolicyAction =
                OfflinePolicyAction.fromIdentifier(identifier, retries)
        }
        Log.e(
            "offlinePolicyAction: ",
            "_offlinePolicyAction: ${_offlinePolicyAction} _retries: ${retries} offlinePolicyAction: ${offlinePolicyAction}"
        )
        if (client != null) {
            val requestBuilder = client.get(path).asObject<Any>()
            offlinePolicyAction?.let {
                requestBuilder.whenOffline(offlinePolicyAction)
            }
            requestBuilder.enqueue { result ->
                if (result is Status.Success<*>) {
                    //todo
                    // callback.invoke(Result.success(result.response))
                    val response =
                        NetraResponse(
                            data = mapOf("data" to gson.toJson(result.response)),
                            statusCode = 200,
                            error = null
                        )
                    val result = gson.toJson(NetraResponseDTO.fromDataModel(response))
                    Log.e("result is success", result)
                    callback.invoke(Result.success(result))
                } else if (result is Status.Retrying) {
                    Log.e("result is Retrying", result.code.toString())
                } else if (result is Status.Error) {
                    Log.e("result is Error", result.code.toString())
                } else {
                    Log.e("result is Failure", (result as Status.Failure).message.toString())
                }
            }
        } else {
            //todo: throw client not found
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