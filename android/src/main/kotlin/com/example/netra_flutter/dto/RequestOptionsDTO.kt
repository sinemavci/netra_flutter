package com.example.netra_flutter.dto

data class RequestOptionsDTO(
    val url: String,
    val offlinePolicyAction: OfflinePolicyActionDTO? = null,
    val slowNetworkPolicyAction: SlowNetworkPolicyActionDTO? = null,
    val cacheOptions: CacheOptionsDTO? = null,
    val headers: Map<String, String>?
)
