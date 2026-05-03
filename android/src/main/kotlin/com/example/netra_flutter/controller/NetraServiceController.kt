package com.example.netra_flutter.controller

import android.content.Context
import android.util.Log
import com.example.netra_flutter.NetraControllerPigeon.NetraHostApi
import com.netra.library.NetraClient
import com.netra.library.NetraClientList
import com.netra.library.converter.NetraGsonConverter
import com.netra.library.converter.NetraKotlinxConverter
import com.netra.library.converter.NetraMoshiConverter
import com.netra.library.enums.Status

class NetraServiceController(val context: Context) : NetraHostApi {
    override fun get(
        clientId: String,
        path: String,
        callback: (Result<String?>) -> Unit
    ) {
        val client = NetraClientList.getClients().find { it.id == clientId }
        if (client != null) {
            val request = client.get(path)
//            .slowMode()
//            .addHeader("headercustom", "custom")
                .asObject<Any>()
//            .withCache(Cache(null))
//            .whenOffline(OfflinePolicyAction.RETRY(4))
//            .whenSlowNetwork(SlowNetworkPolicyAction.TIMEOUT(timeout = 3))

            request.enqueue { result ->
                if (result is Status.Success<*>) {
                    //todo
                    // callback.invoke(Result.success(result.response))
                    Log.e("result is success", result.response.toString())
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