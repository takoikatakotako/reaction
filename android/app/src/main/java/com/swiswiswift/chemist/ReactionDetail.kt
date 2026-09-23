package com.swiswiswift.chemist

import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import coil3.compose.AsyncImage
import java.net.URI

import android.content.Intent
import android.net.Uri
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.ui.platform.LocalContext


@Composable
fun ReactionDetail(navController: NavController, reaction: Reaction?) {
    Scaffold(
        topBar = {
            TopBar(reaction?.english ?: "")
        },
    ) { padding ->
        when {
            reaction != null -> {
                Column(
                    modifier = Modifier
                        .padding(padding)
                        .padding(8.dp)
                        .fillMaxSize()
                ) {
                    LazyColumn(modifier = Modifier.fillMaxHeight()) {
                        item {
                            Text(
                                reaction.english,
                                fontSize = 24.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }

                        if (reaction.generalFormulas.isNotEmpty()) {
                            item {
                                Text(
                                    "General Formula",
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }

                            items(reaction.generalFormulas) { generalFormula ->
                                AsyncImage(
                                    model = "${IMAGE_URL}${reaction.directoryName}/${generalFormula.imageName}",
                                    placeholder = painterResource(R.drawable.placeholder),
                                    contentDescription = null,
                                    contentScale = ContentScale.FillWidth,
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(4.dp),
                                )
                            }
                        }

                        if (reaction.mechanisms.isNotEmpty()) {
                            item {
                                Text(
                                    "Mechanism",
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }

                            items(reaction.mechanisms) { mechanism ->
                                AsyncImage(
                                    model = "${IMAGE_URL}${reaction.directoryName}/${mechanism.imageName}",
                                    placeholder = painterResource(R.drawable.placeholder),
                                    contentDescription = null,
                                    contentScale = ContentScale.FillWidth,
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(4.dp),
                                )
                            }
                        }

                        if (reaction.examples.isNotEmpty()) {
                            item {
                                Text(
                                    "Example",
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }

                            items(reaction.examples) { example ->
                                AsyncImage(
                                    model = "${IMAGE_URL}${reaction.directoryName}/${example.imageName}",
                                    placeholder = painterResource(R.drawable.placeholder),
                                    contentDescription = null,
                                    contentScale = ContentScale.FillWidth,
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(4.dp),
                                )
                            }
                        }

                        if (reaction.supplements.isNotEmpty()) {
                            item {
                                Text(
                                    "Supplements",
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }

                            items(reaction.supplements) { supplement ->
                                AsyncImage(
                                    model = "${IMAGE_URL}${reaction.directoryName}/${supplement.imageName}",
                                    placeholder = painterResource(R.drawable.placeholder),
                                    contentDescription = null,
                                    contentScale = ContentScale.FillWidth,
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(4.dp),
                                )
                            }
                        }

                        if (reaction.youtubeLinks.isNotEmpty()) {
                            item {
                                Text(
                                    "Youtube",
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }

                            items(reaction.youtubeLinks) { youtubeLink ->
                                val uri = URI(youtubeLink)
                                val path: String = uri.path
                                val context = LocalContext.current

                                AsyncImage(
                                    model = "https://img.youtube.com/vi${path}/0.jpg",
                                    placeholder = painterResource(R.drawable.placeholder),
                                    contentDescription = null,
                                    contentScale = ContentScale.FillWidth,
                                    modifier = Modifier
                                        .fillMaxWidth()
                                        .padding(4.dp)
                                        .clickable(
                                            onClick = {
                                                val browserIntent = Intent(
                                                    Intent.ACTION_VIEW,
                                                    Uri.parse(youtubeLink)
                                                )
                                                context.startActivity(browserIntent)
                                            }
                                        )
                                )
                            }
                        }
                    }
                }
            }

            else -> {
                Column(
                    modifier = Modifier
                        .padding(padding)
                        .padding(8.dp)
                        .fillMaxSize()
                ) {
                    Text("Loading")
                }
            }
        }
    }
}
