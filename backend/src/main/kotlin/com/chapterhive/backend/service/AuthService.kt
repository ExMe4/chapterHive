package com.chapterhive.backend.service

import com.chapterhive.backend.model.User
import com.chapterhive.backend.model.User.Provider
import com.chapterhive.backend.repository.UserRepository
import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate

@Service
class AuthService(
    private val restTemplate: RestTemplate,
    private val userRepository: UserRepository
) {

    fun verifyGoogleToken(token: String): OAuthUser? {
        val url = "https://oauth2.googleapis.com/tokeninfo?id_token=$token"
        try {
            val response = restTemplate.getForObject(url, String::class.java)
            println("Google token verification response: $response")
            val jsonNode: JsonNode = ObjectMapper().readTree(response)

            return if (jsonNode.has("email") && jsonNode.has("sub")) {
                OAuthUser(
                    id = jsonNode.get("sub").asText(),
                    email = jsonNode.get("email").asText(),
                    username = jsonNode.get("name")?.asText(),
                    profilePicture = jsonNode.get("picture")?.asText()
                )
            } else {
                println("Token missing fields: $jsonNode")
                null
            }
        } catch (e: Exception) {
            println("Token verification error: ${e.message}")
            return null
        }
    }

    fun verifyAppleToken(token: String): OAuthUser? {
        // TODO Apple token validation
        return null
    }

    fun findOrCreateUser(id: String, email: String, username: String?, profilePicture: String?, provider: String): User {
        val existingUser = userRepository.findById(id)
        return if (existingUser.isPresent) {
            existingUser.get()
        } else {
            userRepository.save(
                User(
                    id = id,
                    email = email,
                    username = username,
                    profilePicture = profilePicture,
                    provider = Provider.valueOf(provider.uppercase()),
                    role = User.Role.USER
                )
            )
        }
    }
}

data class OAuthUser(
    val id: String,
    val email: String,
    val username: String?,
    val profilePicture: String?
)
