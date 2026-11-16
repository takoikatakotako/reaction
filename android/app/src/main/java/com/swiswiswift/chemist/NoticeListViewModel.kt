package com.swiswiswift.chemist

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
import java.util.Locale

class NoticeListViewModel(
    private val noticeService: NoticeService = NoticeService.instance,
    private val languageProvider: () -> String = { Locale.getDefault().language },
) : ViewModel() {
    // 取得したままのお知らせ。対象 OS の絞り込みは配信側（android.json）で済んでいる。
    // 言語では絞り込まずに持っておき、読むたびに現在の言語で絞り込む。
    // ViewModel は端末の言語変更をまたいで残るため、取得時の言語で絞り込んだ結果を
    // 持っていると、対象外になったお知らせを表示してしまう。
    private var fetchedNotices by mutableStateOf<List<Notice>>(emptyList())

    var isFetching by mutableStateOf(true)
        private set
    var isError by mutableStateOf(false)
        private set

    // タイトル・本文・対象言語の判定は端末の言語に従う
    val language: String
        get() = languageProvider()

    val notices: List<Notice>
        get() {
            val language = language
            return fetchedNotices.filter { it.isTarget(language) }
        }

    fun fetchNotices() {
        viewModelScope.launch {
            isFetching = true
            try {
                fetchedNotices = noticeService.getNotices().notices.orEmpty()
                isError = false
            } catch (e: Exception) {
                isError = true
            } finally {
                isFetching = false
            }
        }
    }

    /** 現在の言語で表示できるお知らせ。対象外の言語なら null。 */
    fun getNotice(id: String): Notice? = notices.find { it.id == id }

    /** 言語にかかわらず、取得済みのデータに含まれているか。 */
    fun hasFetched(id: String): Boolean = fetchedNotices.any { it.id == id }
}
