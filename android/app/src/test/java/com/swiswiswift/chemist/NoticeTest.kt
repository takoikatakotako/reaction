package com.swiswiswift.chemist

import com.google.gson.Gson
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import java.util.Locale

class NoticeTest {
    private fun notice(
        languages: List<String>? = listOf("ja", "en"),
        publishedAt: String? = "2026-09-24T00:00:00Z",
    ) = Notice(
        id = "n1",
        englishTitle = "Maintenance",
        japaneseTitle = "メンテナンスのお知らせ",
        englishBody = "We will perform maintenance.",
        japaneseBody = "メンテナンスを行います。",
        publishedAt = publishedAt,
        languages = languages,
    )

    @Test
    fun decodeJson() {
        val json = """
            {"notices": [{
              "id": "n1",
              "englishTitle": "Maintenance",
              "japaneseTitle": "メンテナンスのお知らせ",
              "publishedAt": "2026-09-24T00:00:00Z",
              "platforms": ["android"],
              "languages": ["ja"]
            }]}
        """.trimIndent()

        val notice = Gson().fromJson(json, NoticesResponse::class.java).notices!!.first()
        assertEquals("n1", notice.id)
        assertEquals("メンテナンスのお知らせ", notice.japaneseTitle)
        assertNull(notice.englishBody)
        assertEquals(listOf("ja"), notice.languages)
    }

    @Test
    fun isTargetForAllLanguages() {
        assertTrue(notice().isTarget("ja"))
        assertTrue(notice().isTarget("en"))
    }

    @Test
    fun isTargetForJapaneseOnly() {
        val notice = notice(languages = listOf("ja"))
        assertTrue(notice.isTarget("ja"))
        assertFalse(notice.isTarget("en"))
        // 日本語以外は英語として扱う
        assertFalse(notice.isTarget("fr"))
    }

    @Test
    fun isTargetForEnglishOnly() {
        val notice = notice(languages = listOf("en"))
        assertFalse(notice.isTarget("ja"))
        assertTrue(notice.isTarget("en"))
        assertTrue(notice.isTarget("fr"))
    }

    @Test
    fun isTargetWhenLanguagesMissing() {
        assertTrue(notice(languages = null).isTarget("en"))
        assertTrue(notice(languages = emptyList()).isTarget("ja"))
    }

    @Test
    fun displayTextFollowsLanguage() {
        assertEquals("メンテナンスのお知らせ", notice().displayTitle("ja"))
        assertEquals("Maintenance", notice().displayTitle("en"))
        assertEquals("Maintenance", notice().displayTitle("fr"))
        assertEquals("メンテナンスを行います。", notice().displayBody("ja"))
        assertEquals("We will perform maintenance.", notice().displayBody("en"))
    }

    @Test
    fun displayDateUsesUtcDate() {
        // UTC の 0 時を表す値は、どのタイムゾーンでも同じ日付で表示する
        assertEquals("Sep 24, 2026", notice().displayDate(Locale.US))
        assertEquals("2026/09/24", notice().displayDate(Locale.JAPAN))
    }

    @Test
    fun displayDateIsEmptyForInvalidValues() {
        assertEquals("", notice(publishedAt = null).displayDate(Locale.US))
        assertEquals("", notice(publishedAt = "2026/09/24").displayDate(Locale.US))
    }
}
