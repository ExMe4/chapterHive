package com.chapterhive.backend.service

import com.chapterhive.backend.model.Book
import com.chapterhive.backend.repository.BookRepository
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.BDDMockito.*
import org.mockito.Mock
import org.mockito.junit.jupiter.MockitoExtension
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.client.RestTemplate

@ExtendWith(MockitoExtension::class)
class BookApiServiceTest {

    @Mock
    lateinit var restTemplate: RestTemplate

    @Mock
    lateinit var bookRepository: BookRepository

    lateinit var bookApiService: BookApiService

    @BeforeEach
    fun setUp() {
        bookApiService = BookApiService(restTemplate, bookRepository, "mockApiKey")
    }

    @Test
    fun shouldReturnLocalBookIfExists() {
        // given
        val localBook = Book(title = "Test Book", author = "John Doe")
        given(bookRepository.findByTitleIgnoreCase("Test Book")).willReturn(localBook)

        // when
        val result = bookApiService.getBook("Test Book")

        // then
        assertEquals(localBook, result)
        verify(bookRepository, times(1)).findByTitleIgnoreCase("Test Book")
        verifyNoInteractions(restTemplate)
    }

    @Test
    fun shouldFetchFromApiAndSaveIfNotInLocalDb() {
        // given
        given(bookRepository.findByTitleIgnoreCase("New Book")).willReturn(null)

        val apiResponseBody = mapOf(
            "items" to listOf(
                mapOf(
                    "id" to "abc123",
                    "volumeInfo" to mapOf(
                        "title" to "New Book",
                        "authors" to listOf("Jane Doe"),
                        "pageCount" to 250,
                        "publishedDate" to "2021-01-01",
                        "categories" to listOf("Fiction"),
                        "description" to "A great new book",
                        "publisher" to "Test Publisher",
                        "language" to "en",
                        "imageLinks" to mapOf("thumbnail" to "http://image.com/cover.jpg"),
                        "industryIdentifiers" to listOf(
                            mapOf("identifier" to "9876543210")
                        )
                    )
                )
            )
        )

        given(restTemplate.getForEntity(anyString(), eq(Map::class.java)))
            .willReturn(ResponseEntity(apiResponseBody, HttpStatus.OK))

        val savedBook = Book(title = "New Book", author = "Jane Doe")
        given(bookRepository.save(any(Book::class.java))).willReturn(savedBook)

        // when
        val result = bookApiService.getBook("New Book")

        // then
        assertNotNull(result)
        assertEquals("New Book", result?.title)
        verify(bookRepository).save(any(Book::class.java))
    }

    @Test
    fun shouldReturnNullIfApiReturnsNoItems() {
        // given
        given(bookRepository.findByTitleIgnoreCase("Empty")).willReturn(null)
        val emptyResponse = mapOf("items" to emptyList<Any>())

        given(restTemplate.getForEntity(anyString(), eq(Map::class.java)))
            .willReturn(ResponseEntity(emptyResponse, HttpStatus.OK))

        // when
        val result = bookApiService.getBook("Empty")

        // then
        assertNull(result)
    }

    @Test
    fun shouldReturnNullIfApiStructureIsMalformed() {
        // given
        given(bookRepository.findByTitleIgnoreCase("Broken")).willReturn(null)
        val brokenResponse = mapOf("items" to listOf("not-a-map"))

        given(restTemplate.getForEntity(anyString(), eq(Map::class.java)))
            .willReturn(ResponseEntity(brokenResponse, HttpStatus.OK))

        // when
        val result = bookApiService.getBook("Broken")

        // then
        assertNull(result)
    }

    @Test
    fun shouldReturnNullIfApiCallThrowsException() {
        // given
        given(bookRepository.findByTitleIgnoreCase("Crash")).willReturn(null)
        given(restTemplate.getForEntity(anyString(), eq(Map::class.java)))
            .willThrow(RuntimeException("API down"))

        // when
        val result = bookApiService.getBook("Crash")

        // then
        assertNull(result)
    }
}
