package com.chapterhive.backend.model.response

import java.time.LocalDateTime

data class UserResponse(
    val id: String,
    val email: String,
    val username: String?,
    val profilePicture: String?,
    val provider: String,
    val role: String,
    val createdAt: LocalDateTime
)