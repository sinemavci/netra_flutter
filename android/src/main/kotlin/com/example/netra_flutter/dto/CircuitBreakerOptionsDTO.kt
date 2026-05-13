package com.example.netra_flutter.dto

data class CircuitBreakerOptionsDTO(
    val failureThreshold: Int? = 5,
    val retryDelayMs: Long? = 1000L
)
