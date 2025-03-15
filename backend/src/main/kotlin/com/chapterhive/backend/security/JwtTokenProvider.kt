package com.chapterhive.backend.security

import io.jsonwebtoken.Jwts
import io.jsonwebtoken.io.Decoders
import io.jsonwebtoken.security.Keys
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Component
import java.security.Key
import java.util.*

@Component
class JwtTokenProvider(
    @Value("\${jwt.secret}") private val jwtSecret: String,
    @Value("\${jwt.expirationMs}") private val jwtExpirationMs: Long
) {
    private val logger = LoggerFactory.getLogger(JwtTokenProvider::class.java)

    private fun getSigningKey(): Key {
        val keyBytes = Decoders.BASE64.decode(jwtSecret)
        return Keys.hmacShaKeyFor(keyBytes)
    }

    fun validateToken(token: String): Boolean {
        return try {
            Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
            true
        } catch (e: Exception) {
            logger.error("JWT validation failed: ${e.message}")
            false
        }
    }

    fun generateToken(email: String): String {
        val now = Date()
        val expiryDate = Date(now.time + jwtExpirationMs)

        return Jwts.builder()
            .setSubject(email)
            .setIssuedAt(now)
            .setExpiration(expiryDate)
            .signWith(getSigningKey())
            .compact()
    }
}
