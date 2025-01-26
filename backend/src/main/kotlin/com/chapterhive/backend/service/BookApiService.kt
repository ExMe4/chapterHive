package com.chapterhive.backend.service

import com.chapterhive.backend.model.Book
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import org.springframework.web.util.UriComponentsBuilder

@Service
class BookApiService {
    private val restTemplate = RestTemplate()
    private val apiUrl = "https://www.googleapis.com/books/v1/volumes"

    @Value("\${google.books.api.key}")
    private lateinit var apiKey: String

    fun fetchBookDetails(title: String): Book? {
        val uri = UriComponentsBuilder.fromHttpUrl(apiUrl)
            .queryParam("q", title)
            .queryParam("key", apiKey)
            .toUriString()

        val response = restTemplate.getForEntity(uri, Map::class.java)
        val items = response.body?.get("items") as? List<*> ?: return null

        val firstItem = items.firstOrNull() as? Map<*, *> ?: return null
        val volumeInfo = firstItem["volumeInfo"] as? Map<*, *> ?: return null

        return Book(
            title = volumeInfo["title"] as String,
            author = (volumeInfo["authors"] as? List<*>)?.joinToString(", ") ?: "Unknown",
            pages = volumeInfo["pageCount"] as? Int,
            coverImage = (volumeInfo["imageLinks"] as? Map<*, *>)?.get("thumbnail") as? String,
            source = "API"
        )
    }
}