package com.swiswiswift.chemist

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import coil3.compose.AsyncImage

@Composable
fun ReactionListRow(navController: NavController, reaction: Reaction) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .wrapContentHeight()
            .clickable {
                navController.navigate("detail/${reaction.directoryName}")
            },
    ) {
        Text(
            text = reaction.english,
            modifier = Modifier
                .padding(top = 8.dp)
                .padding(start = 8.dp)
        )

        val imageUrl = "${IMAGE_URL}${reaction.directoryName}/${reaction.thmbnailName}"
        AsyncImage(
            model = imageUrl,
            contentDescription = null,
            contentScale = ContentScale.FillWidth,
            modifier = Modifier
                .fillMaxWidth()
                .padding(4.dp),
        )

        HorizontalDivider(thickness = 1.dp)
    }
}
