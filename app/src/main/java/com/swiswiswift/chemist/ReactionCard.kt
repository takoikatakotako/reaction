package com.swiswiswift.chemist

import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
// import androidx.compose.material.Card
// import androidx.compose.material.MaterialTheme
// import androidx.compose.material.Text
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import coil.compose.rememberImagePainter
import coil.size.OriginalSize
import coil.size.Scale
import coil.size.SizeResolver
import coil.transform.CircleCropTransformation
import java.nio.file.Files
import java.nio.file.Files.size
//
//
//
//
//
@Composable
fun ReactionCard(navController: NavController, reaction: Reaction) {
    Card(
        modifier = Modifier
            .padding(8.dp)
            .fillMaxWidth()
            .wrapContentHeight()
            .clickable {
                navController.navigate("detail/${reaction.directoryName}")
            },
        shape = MaterialTheme.shapes.medium,
        // elevation = 4.dp,
        // backgroundColor = MaterialTheme.colors.surface
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Column(Modifier.padding(4.dp)) {
                Text(
                    text = reaction.english,
                    // style = MaterialTheme.typography.body2,
                    // color = MaterialTheme.colors.onSurface,
                )

                val imageUrl = "${
                    IMAGE_URL
                }${reaction.directoryName}/${reaction.thmbnailName}"
                Image(
                    painter = rememberImagePainter(
                        imageUrl,
                        builder = {
                            this.placeholder(R.drawable.placeholder)
                                .size(SizeResolver(OriginalSize))
                        },
                    ),
                    contentDescription = null,
                    contentScale = ContentScale.FillWidth,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(4.dp),

                    )
            }
        }
    }
}
