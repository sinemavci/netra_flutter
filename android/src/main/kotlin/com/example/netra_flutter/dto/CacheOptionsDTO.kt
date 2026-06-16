package com.example.netra_flutter.dto

import com.netra.library.Cache

data class CacheOptionsDTO(
    val ttl: Double? = 600000.0,
) {
    fun toDataModel(): Cache {
        return Cache(ttl?.toLong())
    }

    companion object {
        fun fromDataModel(cache: Cache): CacheOptionsDTO {
            return CacheOptionsDTO(
                ttl = cache.ttl?.toDouble()
            )
        }
    }
}
