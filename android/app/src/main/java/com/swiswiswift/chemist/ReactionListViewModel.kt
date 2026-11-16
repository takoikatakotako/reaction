package com.swiswiswift.chemist

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch

class ReactionListViewModel : ViewModel() {
    private val _reactionList = mutableStateListOf<Reaction>()
    val reactionList: List<Reaction>
        get() = _reactionList
    var errorMessage by mutableStateOf("")
        private set
    var isFetching by mutableStateOf(true)
        private set

    fun getReactions() {
        viewModelScope.launch {
            isFetching = true
            val apiService = APIService.getInstance()
            try {
                val reactions = apiService.getReactions()
                _reactionList.clear()
                _reactionList.addAll(reactions)
                errorMessage = ""
            } catch (e: Exception) {
                errorMessage = e.message.toString()
            } finally {
                isFetching = false
            }
        }
    }

    fun getReaction(directoryName: String): Reaction? {
        return _reactionList.find { it.directoryName == directoryName }
    }
}
