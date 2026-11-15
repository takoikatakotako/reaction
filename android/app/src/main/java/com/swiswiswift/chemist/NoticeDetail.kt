package com.swiswiswift.chemist

import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun NoticeDetail(notice: Notice?, language: String) {
    Scaffold(
        topBar = {
            TopBar(stringResource(R.string.notice_title))
        },
    ) { padding ->
        LazyColumn(
            modifier = Modifier
                .padding(padding)
                .padding(16.dp)
                .fillMaxSize(),
        ) {
            if (notice == null) {
                item { Text(stringResource(R.string.notice_error)) }
                return@LazyColumn
            }
            item {
                Text(notice.displayDate(), fontSize = 12.sp, color = Color.Gray)
                Text(notice.displayTitle(language), fontSize = 20.sp, fontWeight = FontWeight.Bold)
                Spacer(modifier = Modifier.height(16.dp))
                Text(notice.displayBody(language), fontSize = 15.sp)
            }
        }
    }
}
