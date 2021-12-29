package com.swiswiswift.chemist

import androidx.compose.runtime.mutableStateListOf
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch

class ReactionListViewModel : ViewModel() {
    private val _reactionList = mutableStateListOf<Reaction>()
    var errorMessage: String = ""
    val reactionList: List<Reaction>
        get() = _reactionList

    fun getReactions() {
        viewModelScope.launch {
            val apiService = APIService.getInstance()
            try {
                _reactionList.clear()
                _reactionList.addAll(apiService.getReactions())

            } catch (e: Exception) {
                errorMessage = e.message.toString()
            }
        }
    }
}