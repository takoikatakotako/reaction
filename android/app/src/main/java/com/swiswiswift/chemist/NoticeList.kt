package com.swiswiswift.chemist

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController

@Composable
fun NoticeList(navController: NavController, viewModel: NoticeListViewModel) {
    LaunchedEffect(Unit) {
        viewModel.fetchNotices()
    }

    Scaffold(
        topBar = {
            TopBar(stringResource(R.string.notice_title))
        },
    ) { padding ->
        Box(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize(),
        ) {
            when {
                viewModel.isFetching && viewModel.notices.isEmpty() -> {
                    CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
                }

                viewModel.isError -> {
                    Text(
                        stringResource(R.string.notice_error),
                        modifier = Modifier.align(Alignment.Center),
                    )
                }

                viewModel.notices.isEmpty() -> {
                    Text(
                        stringResource(R.string.notice_empty),
                        modifier = Modifier.align(Alignment.Center),
                    )
                }

                else -> {
                    LazyColumn(modifier = Modifier.fillMaxSize()) {
                        items(viewModel.notices, key = { it.id }) { notice ->
                            NoticeListRow(notice, viewModel.language) {
                                navController.navigate("notice/${notice.id}")
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun NoticeListRow(notice: Notice, language: String, onClick: () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick),
    ) {
        Column(modifier = Modifier.padding(horizontal = 16.dp, vertical = 12.dp)) {
            Text(notice.displayDate(), fontSize = 12.sp, color = Color.Gray)
            Text(notice.displayTitle(language), fontSize = 16.sp, fontWeight = FontWeight.Bold)
        }
        HorizontalDivider(thickness = 1.dp)
    }
}
