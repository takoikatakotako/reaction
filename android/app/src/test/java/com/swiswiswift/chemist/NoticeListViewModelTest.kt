package com.swiswiswift.chemist

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.UnconfinedTestDispatcher
import kotlinx.coroutines.test.resetMain
import kotlinx.coroutines.test.setMain
import org.junit.After
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Before
import org.junit.Test

@OptIn(ExperimentalCoroutinesApi::class)
class NoticeListViewModelTest {
    private class FakeNoticeService(
        private val result: () -> NoticesResponse,
    ) : NoticeService {
        var callCount = 0
        override suspend fun getNotices(cacheControl: String): NoticesResponse {
            callCount++
            return result()
        }
    }

    private fun notice(id: String, languages: List<String>?) = Notice(
        id = id,
        englishTitle = "title-$id",
        japaneseTitle = "タイトル-$id",
        englishBody = null,
        japaneseBody = null,
        publishedAt = "2026-09-24T00:00:00Z",
        languages = languages,
    )

    private val response = NoticesResponse(
        listOf(
            notice("all", listOf("ja", "en")),
            notice("ja-only", listOf("ja")),
            notice("en-only", listOf("en")),
            notice("legacy", null),
        )
    )

    @Before
    fun setUp() {
        Dispatchers.setMain(UnconfinedTestDispatcher())
    }

    @After
    fun tearDown() {
        Dispatchers.resetMain()
    }

    @Test
    fun noticesAreFilteredByCurrentLanguage() {
        var language = "ja"
        val viewModel = NoticeListViewModel(FakeNoticeService { response }) { language }
        viewModel.fetchNotices()

        assertEquals(listOf("all", "ja-only", "legacy"), viewModel.notices.map { it.id })

        // 端末の言語が変わっても ViewModel は残る。取得し直さずに現在の言語で絞り込み直す
        language = "en"
        assertEquals(listOf("all", "en-only", "legacy"), viewModel.notices.map { it.id })
    }

    @Test
    fun noticeOutOfTargetAfterLanguageChangeIsNotShown() {
        var language = "ja"
        val viewModel = NoticeListViewModel(FakeNoticeService { response }) { language }
        viewModel.fetchNotices()
        assertNotNull(viewModel.getNotice("ja-only"))

        language = "en"
        assertNull(viewModel.getNotice("ja-only"))
        // 取得済みではあるので、詳細画面は取得し直さずにエラーを出す
        assertTrue(viewModel.hasFetched("ja-only"))
    }

    @Test
    fun hasFetchedIsFalseBeforeFetch() {
        val viewModel = NoticeListViewModel(FakeNoticeService { response }) { "ja" }
        assertFalse(viewModel.hasFetched("all"))
        assertTrue(viewModel.isFetching)
    }

    @Test
    fun fetchFailureSetsError() {
        val service = FakeNoticeService { throw RuntimeException("network") }
        val viewModel = NoticeListViewModel(service) { "ja" }
        viewModel.fetchNotices()

        assertTrue(viewModel.isError)
        assertFalse(viewModel.isFetching)
        assertTrue(viewModel.notices.isEmpty())
    }
}
