package com.chapterhive.backend.service

import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate

@Service
class GoogleBooksService {
    private val googleBooksApiUrl = "https://www.googleapis.com/books/v1/volumes?q="

    fun searchBooks(query: String): List<Map<String, Any>> {
        val restTemplate = RestTemplate()
        val url = "$googleBooksApiUrl$query"
        val response = restTemplate.getForEntity(url, Map::class.java)

        return (response.body?.get("items") as? List<*>)?.mapNotNull { item ->
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
    }
}
