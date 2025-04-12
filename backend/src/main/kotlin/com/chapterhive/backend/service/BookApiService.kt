package com.chapterhive.backend.service

import com.chapterhive.backend.model.Book
import com.chapterhive.backend.repository.BookRepository
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import org.springframework.web.util.UriComponentsBuilder

@Service
class BookApiService(
    private val restTemplate: RestTemplate,
    private val bookRepository: BookRepository,
    @Value("\${google.books.api.key}") private val apiKey: String
) {
    private val apiUrl = "https://www.googleapis.com/books/v1/volumes"

    fun getBook(title: String): Book? {
        // Check the local database
        val localBook = bookRepository.findByTitleIgnoreCase(title)
        if (localBook != null) {
            return localBook
        }

        // Fetch from Google Books API
        val apiBook = fetchBookFromApi(title) ?: return null

        return bookRepository.save(apiBook)
    }

    private fun fetchBookFromApi(title: String): Book? {
        return try {
            val uri = UriComponentsBuilder
                .fromUriString(apiUrl)
                .queryParam("q", title)
                .queryParam("key", apiKey)
                .build()
                .toUriString()

            val response = restTemplate.getForEntity(uri, Map::class.java)
            val body = response.body ?: return null

            val items = (body["items"] as? List<*>)?.filterIsInstance<Map<String, Any>>() ?: return null
            val bookData = items.firstOrNull() ?: return null
            val volumeInfo = (bookData["volumeInfo"] as? Map<*, *>)?.mapKeys { it.key.toString() } ?: emptyMap()

            val isbnList = (volumeInfo["industryIdentifiers"] as? List<*>)
                ?.mapNotNull { it as? Map<*, *> }
                ?.mapNotNull { it["identifier"] as? String }
                ?: emptyList()

            Book(
                googleBookId = bookData["id"] as? String,
                title = volumeInfo["title"] as? String ?: "Unknown Title",
                author = (volumeInfo["authors"] as? List<*>)?.joinToString(", ") ?: "Unknown Author",
                pages = volumeInfo["pageCount"] as? Int,
                coverImage = (volumeInfo["imageLinks"] as? Map<*, *>)?.get("thumbnail") as? String ?: "",
                publicationYear = (volumeInfo["publishedDate"] as? String)?.take(4)?.toIntOrNull(),
                genre = (volumeInfo["categories"] as? List<*>)?.joinToString(", "),
                description = volumeInfo["description"] as? String,
                publisher = volumeInfo["publisher"] as? String,
                language = volumeInfo["language"] as? String,
                isbnList = isbnList,
                source = "api"
            )
        } catch (ex: Exception) {
            null
        }
    }
}
