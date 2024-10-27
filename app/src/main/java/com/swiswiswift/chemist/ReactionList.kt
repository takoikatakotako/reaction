package com.swiswiswift.chemist

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
/*import androidx.compose.material.Scaffold
import androidx.compose.material.Text
import androidx.compose.material.TopAppBar*/
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController

@Composable
fun ReactionList(navController: NavController, reactionListViewModel: ReactionListViewModel) {
    LaunchedEffect(Unit, block = {
        reactionListViewModel.getReactions()
    })

    Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
        if (reactionListViewModel.errorMessage.isEmpty()) {
            Column(modifier = Modifier.padding(16.dp)) {
                LazyColumn(modifier = Modifier.fillMaxHeight()) {
                    items(reactionListViewModel.reactionList) { todo ->
                        ReactionCard(navController = navController, todo)
                    }
                }
            }
        } else {
            Text(reactionListViewModel.errorMessage)
        }
    }
}