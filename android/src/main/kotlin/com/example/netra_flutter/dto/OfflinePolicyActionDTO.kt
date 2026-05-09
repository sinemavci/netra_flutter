package com.example.netra_flutter.dto

import com.netra.library.enums.OfflinePolicyAction

data class OfflinePolicyActionDTO(
    val identifier: String,
    val retries: Double?,
) {
    companion object {
        fun fromDataModel(offlinePolicyAction: OfflinePolicyAction): OfflinePolicyActionDTO {
            return OfflinePolicyActionDTO(
                identifier = offlinePolicyAction.identifier,
                retries = ((if (offlinePolicyAction is OfflinePolicyAction.RETRY) {
                    offlinePolicyAction.retries
                } else {
                    null
                })?.toDouble())
            )
        }
    }

    fun toDataModel(): OfflinePolicyAction {
        return OfflinePolicyAction.fromIdentifier(identifier, retries?.toInt())
    }
}
