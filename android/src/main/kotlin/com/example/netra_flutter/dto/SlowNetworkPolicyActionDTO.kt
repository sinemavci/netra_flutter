package com.example.netra_flutter.dto

import com.netra.library.enums.SlowNetworkPolicyAction
import java.util.concurrent.TimeUnit

data class SlowNetworkPolicyActionDTO(
    val identifier: String,
    val delay: Double?,
    val timeout: Double?,
    val timeUnit: TimeUnit?,
) {
    companion object {
        fun fromDataModel(slowNetworkPolicyAction: SlowNetworkPolicyAction): SlowNetworkPolicyActionDTO {
            return SlowNetworkPolicyActionDTO(
                identifier = slowNetworkPolicyAction.identifier,
                delay = ((if (slowNetworkPolicyAction is SlowNetworkPolicyAction.WAIT) {
                    slowNetworkPolicyAction.delay
                } else {
                    null
                })?.toDouble()),
                timeout = ((if (slowNetworkPolicyAction is SlowNetworkPolicyAction.TIMEOUT) {
                    slowNetworkPolicyAction.timeout
                } else {
                    null
                })?.toDouble()),
                timeUnit = ((if (slowNetworkPolicyAction is SlowNetworkPolicyAction.TIMEOUT) {
                    slowNetworkPolicyAction.timeUnit
                } else {
                    null
                }))
            )
        }
    }

    fun toDataModel(): SlowNetworkPolicyAction {
        return SlowNetworkPolicyAction.fromIdentifier(
            identifier,
            delay?.toLong(),
            timeout?.toLong(),
            timeUnit
        )
    }
}
