package com.chapterhive.backend.service

import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate

@Service
class GoogleBooksService {
    private val googleBooksApiUrl = "https://www.googleapis.com/books/v1/volumes?q="
    private val logger = LoggerFactory.getLogger(GoogleBooksService::class.java)

    fun searchBooks(query: String): List<Map<String, Any>> {
        logger.info("Searching Google Books API for: $query")

        val restTemplate = RestTemplate()
        val url = "$googleBooksApiUrl$query"

        return try {
            val response = restTemplate.getForEntity(url, Map::class.java)
            logger.info("Google Books API Response: $response")

            (response.body?.get("items") as? List<*>)?.mapNotNull { item ->
                (item as? Map<*, *>)?.let { book ->
                    val volumeInfo = book["volumeInfo"] as? Map<*, *>
                    volumeInfo?.let {
                        mapOf(
                            "title" to (it["title"] as? String ?: "Unknown Title"),
                            "authors" to (it["authors"] as? List<*> ?: emptyList<String>()),
                            "description" to (it["description"] as? String ?: ""),
                            "thumbnail" to ((it["imageLinks"] as? Map<*, *>)?.get("thumbnail") as? String ?: ""),
                            "googleBookId" to (book["id"] as? String ?: "")
                        )
                    }
                }
            } ?: emptyList()
        } catch (e: Exception) {
            logger.error("Error fetching from Google Books API: ${e.message}")
            emptyList()
        }
    }
}
