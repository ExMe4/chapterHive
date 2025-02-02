package com.chapterhive.backend.service

import com.chapterhive.backend.model.Book
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import org.springframework.web.util.UriComponentsBuilder

@Service
class BookApiService(
    private val restTemplate: RestTemplate // ✅ Now Spring injects RestTemplate
) {
    private val apiUrl = "https://www.googleapis.com/books/v1/volumes"

    @Value("\${google.books.api.key}")
    private lateinit var apiKey: String

    fun fetchBookDetails(title: String): Book? {
        val uri = UriComponentsBuilder
            .fromUriString(apiUrl) // ✅ Fixes deprecated method
            .queryParam("q", title)
            .queryParam("key", apiKey)
            .build()
            .toUriString()

        val response = restTemplate.getForEntity(uri, Map::class.java)
        val items = response.body?.get("items") as? List<Map<String, Any>> ?: return null

        return items.firstOrNull()?.let { bookData ->
            val volumeInfo = bookData["volumeInfo"] as? Map<String, Any> ?: emptyMap()

            Book(
                googleBookId = bookData["id"] as? String,
                title = volumeInfo["title"] as? String ?: "Unknown Title",
                author = (volumeInfo["authors"] as? List<*>)?.filterIsInstance<String>()?.joinToString(", ") ?: "Unknown Author",
                pages = volumeInfo["pageCount"] as? Int,
                coverImage = (volumeInfo["imageLinks"] as? Map<*, *>)?.get("thumbnail") as? String,
                publicationYear = (volumeInfo["publishedDate"] as? String)?.take(4)?.toIntOrNull(),
                genre = (volumeInfo["categories"] as? List<*>)?.filterIsInstance<String>()?.joinToString(", "),
                description = volumeInfo["description"] as? String,
                publisher = volumeInfo["publisher"] as? String,
                language = volumeInfo["language"] as? String
            )
        }
    }
}
