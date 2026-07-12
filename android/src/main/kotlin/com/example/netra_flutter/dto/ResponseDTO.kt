package com.example.netra_flutter.dto

import com.netra.library.NetraResponse

data class ResponseDTO(
    val data: Any?,
    val statusCode: Int,
    val statusMessage: String?,
    val isCache: Boolean?,
    val headers: Map<String, String>?,
) {
    companion object {
        fun<T> fromDataModel(response: NetraResponse<T>): ResponseDTO {
            return ResponseDTO(
                data = response.data,
                isCache = response.isCache,
                statusCode = response.statusCode,
                statusMessage = response.statusMessage,
                headers = response.headers,
            )
        }
    }

    fun toDataModel(): NetraResponse<Any?> {
        return NetraResponse(
            data = data,
            isCache = isCache,
            statusCode = statusCode,
            statusMessage = statusMessage,
            headers = headers,
        )
    }
}
