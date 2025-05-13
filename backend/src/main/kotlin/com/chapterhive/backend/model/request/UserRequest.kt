package com.chapterhive.backend.model.request

data class UpdateUserRequest(
    val username: String?,
    val profilePicture: String?
)