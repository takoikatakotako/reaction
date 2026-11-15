package com.swiswiswift.chemist

import java.time.OffsetDateTime
import java.time.ZoneOffset
import java.time.format.DateTimeFormatter
import java.time.format.DateTimeParseException
import java.time.format.FormatStyle
import java.util.Locale

// 配信 JSON（resource/notice/android.json）の形。
// 項目が欠けた JSON でも落ちないよう、すべて nullable にしている。
// R8 で名前が変わると Gson が読めないので proguard-rules.pro で保持している。
data class NoticesResponse(
    val notices: List<Notice>?,
)

data class Notice(
    val id: String,
    val englishTitle: String?,
    val japaneseTitle: String?,
    val englishBody: String?,
    val japaneseBody: String?,
    val publishedAt: String?,
    // 対象言語（"ja" / "en"）。null や空はすべての言語が対象
    val languages: List<String>?,
) {
    /** language は端末の言語コード。"ja" なら日本語、それ以外は英語として扱う。 */
    fun isTarget(language: String): Boolean {
        if (languages.isNullOrEmpty()) {
            return true
        }
        return languages.contains(noticeLanguage(language))
    }

    fun displayTitle(language: String): String =
        if (noticeLanguage(language) == "ja") japaneseTitle.orEmpty() else englishTitle.orEmpty()

    fun displayBody(language: String): String =
        if (noticeLanguage(language) == "ja") japaneseBody.orEmpty() else englishBody.orEmpty()

    /**
     * 表示用の日付。管理画面は選択された日付を 00:00:00Z で保存するため、
     * 端末のタイムゾーンで解釈すると UTC より西で前日になる。UTC 基準で日付を取り出す。
     */
    fun displayDate(locale: Locale = Locale.getDefault()): String {
        val value = publishedAt ?: return ""
        return try {
            val date = OffsetDateTime.parse(value).withOffsetSameInstant(ZoneOffset.UTC).toLocalDate()
            date.format(DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM).withLocale(locale))
        } catch (e: DateTimeParseException) {
            ""
        }
    }
}

private fun noticeLanguage(language: String): String = if (language.startsWith("ja")) "ja" else "en"
