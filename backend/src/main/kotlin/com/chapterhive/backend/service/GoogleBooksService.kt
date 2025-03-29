package com.chapterhive.backend.service

import com.chapterhive.backend.model.response.BookResponse
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate

@Service
class GoogleBooksService {
    private val googleBooksApiUrl = "https://www.googleapis.com/books/v1/volumes?q="
    private val logger = LoggerFactory.getLogger(GoogleBooksService::class.java)

    fun searchBooks(query: String): List<BookResponse> {
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
                        BookResponse(
                            title = it["title"] as? String ?: "Unknown Title",
                            author = (it["authors"] as? List<*>)?.joinToString(", ") ?: "Unknown Author",
                            description = it["description"] as? String ?: "",
                            coverImage = (it["imageLinks"] as? Map<*, *>)?.get("thumbnail") as? String ?: "",
                            publicationYear = (it["publishedDate"] as? String)?.take(4)?.toIntOrNull(),
                            language = it["language"] as? String ?: "Unknown",
                            publisher = it["publisher"] as? String ?: "Unknown",
                            genre = (it["categories"] as? List<*>)?.joinToString(", ") ?: "Unknown",
                            pages = it["pageCount"] as? Int ?: 0,
                            source = "API"
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
