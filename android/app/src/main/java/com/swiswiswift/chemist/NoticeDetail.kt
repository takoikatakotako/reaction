package com.swiswiswift.chemist

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.CircularProgressIndicator
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

@Composable
fun NoticeDetail(noticeId: String, viewModel: NoticeListViewModel) {
    // プロセスが作り直されて詳細画面だけ復元された場合は、一覧を経由しないので
    // お知らせを持っていない。その場合はここで取得し直す。
    LaunchedEffect(noticeId) {
        if (viewModel.getNotice(noticeId) == null) {
            viewModel.fetchNotices()
        }
    }

    val notice = viewModel.getNotice(noticeId)
    val language = viewModel.language

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
                notice != null -> {
                    LazyColumn(modifier = Modifier.fillMaxSize().padding(16.dp)) {
                        item {
                            Text(notice.displayDate(), fontSize = 12.sp, color = Color.Gray)
                            Text(notice.displayTitle(language), fontSize = 20.sp, fontWeight = FontWeight.Bold)
                            Spacer(modifier = Modifier.height(16.dp))
                            Text(notice.displayBody(language), fontSize = 15.sp)
                        }
                    }
                }

                viewModel.isFetching -> {
                    CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
                }

                else -> {
                    Text(
                        stringResource(R.string.notice_error),
                        modifier = Modifier.align(Alignment.Center),
                    )
                }
            }
        }
    }
}
