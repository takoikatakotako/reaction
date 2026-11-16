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
) : ViewModel() {
    var notices by mutableStateOf<List<Notice>>(emptyList())
        private set
    var isFetching by mutableStateOf(true)
        private set
    var isError by mutableStateOf(false)
        private set

    // タイトル・本文・対象言語の判定は端末の言語に従う
    val language: String
        get() = Locale.getDefault().language

    fun fetchNotices() {
        viewModelScope.launch {
            isFetching = true
            try {
                // 対象 OS の絞り込みは配信側（android.json）で済んでいるので、ここでは言語だけ見る
                notices = noticeService.getNotices().notices.orEmpty().filter { it.isTarget(language) }
                isError = false
            } catch (e: Exception) {
                isError = true
            } finally {
                isFetching = false
            }
        }
    }

    fun getNotice(id: String): Notice? = notices.find { it.id == id }
}
