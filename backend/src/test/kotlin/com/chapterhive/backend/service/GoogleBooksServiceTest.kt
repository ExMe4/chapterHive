package com.chapterhive.backend.service

import com.chapterhive.backend.model.response.BookResponse
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.ArgumentMatchers.any
import org.mockito.BDDMockito.given
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.jupiter.MockitoExtension
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.client.RestTemplate

@ExtendWith(MockitoExtension::class)
class GoogleBooksServiceTest {

    @Mock
    lateinit var restTemplate: RestTemplate

    @InjectMocks
    lateinit var googleBooksService: GoogleBooksService

    @Test
    fun shouldReturnEmptyListWhenNoItemsPresent() {
        // given
        val mockResponseBody = mapOf<String, Any>()

        given(restTemplate.getForEntity(any(String::class.java), any(Class::class.java)))
            .willReturn(ResponseEntity(mockResponseBody, HttpStatus.OK))

        // when
        val result = googleBooksService.searchBooks("Test")

        // then
        assertEquals(0, result.size)
    }

    @Test
    fun shouldReturnEmptyListOnMalformedVolumeInfo() {
        // given
        val mockResponseBody = mapOf(
            "items" to listOf(
                mapOf("volumeInfo" to "not-a-map") // broken type
            )
        )

        given(restTemplate.getForEntity(any(String::class.java), any(Class::class.java)))
            .willReturn(ResponseEntity(mockResponseBody, HttpStatus.OK))

        // when
        val result = googleBooksService.searchBooks("Broken")

        // then
        assertEquals(0, result.size)
    }

    @Test
    fun shouldReturnEmptyListOnRestTemplateException() {
        // given
        given(restTemplate.getForEntity(any(String::class.java), any(Class::class.java)))
            .willThrow(RuntimeException("Network error"))

        // when
        val result = googleBooksService.searchBooks("Crash")

        // then
        assertEquals(0, result.size)
    }

    @Test
    fun shouldReturnEarliestEditionWhenDuplicateISBNs() {
        // given
        val mockResponseBody = mapOf(
            "items" to listOf(
                mapOf(
                    "volumeInfo" to mapOf(
                        "title" to "Test Book",
                        "authors" to listOf("John Doe"),
                        "publishedDate" to "2022-01-01",
                        "language" to "en",
                        "publisher" to "Publisher",
                        "categories" to listOf("Fiction"),
                        "pageCount" to 300,
                        "description" to "Later edition",
                        "imageLinks" to mapOf("thumbnail" to "image1.jpg"),
                        "industryIdentifiers" to listOf(
                            mapOf("type" to "ISBN_13", "identifier" to "1234567890123")
                        )
                    )
                ),
                mapOf(
                    "volumeInfo" to mapOf(
                        "title" to "Test Book",
                        "authors" to listOf("John Doe"),
                        "publishedDate" to "2020-01-01",
                        "language" to "en",
                        "publisher" to "Publisher",
                        "categories" to listOf("Fiction"),
                        "pageCount" to 300,
                        "description" to "Original edition",
                        "imageLinks" to mapOf("thumbnail" to "image2.jpg"),
                        "industryIdentifiers" to listOf(
                            mapOf("type" to "ISBN_13", "identifier" to "1234567890123")
                        )
                    )
                )
            )
        )

        given(restTemplate.getForEntity(any(String::class.java), any(Class::class.java)))
            .willReturn(ResponseEntity(mockResponseBody, HttpStatus.OK))

        // when
        val result = googleBooksService.searchBooks("Duplicate")

        // then
        assertEquals(1, result.size)
        val book = result.first()
        assertEquals(2020, book.publicationYear)
        assertEquals("Original edition", book.description)
    }

    @Test
    fun shouldReturnListOfBooksFromGoogleBooksApi() {
        // given
        val mockResponseBody = mapOf(
            "items" to listOf(
                mapOf(
                    "volumeInfo" to mapOf(
                        "title" to "Test Book",
                        "authors" to listOf("John Doe"),
                        "description" to "A test book",
                        "imageLinks" to mapOf("thumbnail" to "http://image.com/cover.jpg"),
                        "publishedDate" to "2020-01-01",
                        "language" to "en",
                        "publisher" to "Test Publisher",
                        "categories" to listOf("Fiction"),
                        "pageCount" to 300,
                        "industryIdentifiers" to listOf(
                            mapOf("type" to "ISBN_13", "identifier" to "1234567890123")
                        )
                    )
                )
            )
        )

        given(restTemplate.getForEntity(any(String::class.java), any(Class::class.java)))
            .willReturn(ResponseEntity(mockResponseBody, HttpStatus.OK))

        // when
        val result: List<BookResponse> = googleBooksService.searchBooks("Test")

        // then
        assertEquals(1, result.size)
        val book = result[0]
        assertEquals("Test Book", book.title)
        assertEquals("John Doe", book.author)
        assertEquals("1234567890123", book.isbnList.first())
    }
}
