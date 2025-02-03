package com.chapterhive.backend.security

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier
import com.google.api.client.http.javanet.NetHttpTransport
import com.google.api.client.json.gson.GsonFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import java.util.Collections

@Service
class GoogleTokenVerifier {

    @Value("\${spring.security.oauth2.client.registration.google-web.client-id}")
    private lateinit var googleClientId: String

    fun verifyGoogleIdToken(idTokenString: String): Map<String, Any?>? { // Allow nullable values
        return try {
            val verifier = GoogleIdTokenVerifier.Builder(NetHttpTransport(), GsonFactory.getDefaultInstance())
                .setAudience(Collections.singletonList(googleClientId))
                .build()

            val idToken: GoogleIdToken? = verifier.verify(idTokenString)
            idToken?.payload?.let { payload ->
                mapOf(
                    "email" to (payload.email ?: ""),
                    "name" to (payload["name"]?.toString() ?: "Unknown"),
                    "picture" to (payload["picture"]?.toString() ?: "")
                )
            }
        } catch (ex: Exception) {
            null
        }
    }
}
