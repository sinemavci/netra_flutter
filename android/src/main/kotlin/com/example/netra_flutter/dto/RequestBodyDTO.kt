package com.example.netra_flutter.dto

import android.util.Log
import com.google.gson.Gson
import com.netra.library.NetraRequestBody
import java.util.ArrayList

data class RequestBodyDTO(
    val content: Any,
    val contentType: String = "application/json; charset=utf-8",
    val isMultipart: Boolean = false,
    val type: String,
) {
    fun toDataModel(): NetraRequestBody {
        Log.e("", "NetraRequestBody type: ${type}")
        return when (type) {
            "map" -> NetraRequestBody.create(content as Map<String, Any?>)
            "raw" -> NetraRequestBody.create((content as ArrayList<Int>).map { it.toByte() }.toByteArray(), contentType)
            else -> NetraRequestBody.create(content as String, contentType)
        }
    }
}
