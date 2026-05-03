package com.example.netra_flutter.dto

import com.netra.library.NetraResponse

data class NetraResponseDTO(
    val data: Map<String, Any?>?,
    val statusCode: Int,
    val error: String?,
) {
    companion object {
        fun fromDataModel(response: NetraResponse): NetraResponseDTO {
            return NetraResponseDTO(
                data = response.data,
                statusCode = response.statusCode,
                error = response.error,
            )
        }
    }

    fun toDataModel(): NetraResponse {
        return NetraResponse(
            data = data,
            statusCode = statusCode,
            error = error,
        )
    }
}
