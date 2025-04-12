package com.chapterhive.backend.model.response

import java.time.LocalDateTime
import java.util.*

data class UserResponse(
    val id: UUID,
    val email: String,
    val username: String?,
    val profilePicture: String?,
    val provider: String,
    val role: String,
    val createdAt: LocalDateTime
)