package com.swiswiswift.chemist

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import androidx.navigation.NavController

@Composable
fun ReactionList(navController: NavController, reactionListViewModel: ReactionListViewModel) {
    LaunchedEffect(Unit, block = {
        reactionListViewModel.getReactions()
    })

    Scaffold(
        topBar = {
            TopBar("反応機構一覧")
        },
    ) { padding ->
        if (reactionListViewModel.errorMessage.isEmpty()) {
            Column(
                modifier = Modifier
                    .padding(padding)
                    .fillMaxSize()
            ) {
                LazyColumn(modifier = Modifier.fillMaxHeight()) {
                    items(reactionListViewModel.reactionList) { todo ->
                        ReactionListRow(navController = navController, todo)
                    }
                }
            }
        } else {
            Text(reactionListViewModel.errorMessage)
        }
    }
}