package com.swiswiswift.chemist

import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController
import coil.compose.rememberImagePainter
import coil.size.OriginalSize
import coil.size.SizeResolver
import java.net.URI

import android.content.Intent
import android.net.Uri
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.ui.platform.LocalContext


@Composable
fun ReactionDetail(navController: NavController, directoryName: String) {
    val exception: MutableState<Exception?> = remember { mutableStateOf(null) }
    val reaction: MutableState<Reaction?> = remember { mutableStateOf(null) }

    LaunchedEffect(Unit, block = {
        try {
            val apiService = APIService.getInstance()
            reaction.value = apiService.getReaction(directoryName)
        } catch (e: Exception) {
            exception.value = e
        }
    })

    Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
        when {
            exception.value != null -> {
                Text("Error: ${exception.value!!}")
            }

            reaction.value == null -> {
                Text("Loading")
            }

            else -> {
                Column(modifier = Modifier.padding(16.dp)) {
                    LazyColumn(modifier = Modifier.fillMaxHeight()) {
                        item {
                            Text(
                                reaction.value!!.english,
                                fontSize = 24.sp,
                                fontWeight = FontWeight.Bold
                            )
                        }

                        if (reaction.value!!.generalFormulas.isNotEmpty()) {
                            item {
                                Text(
                                    "General Formula",
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }

                            items(reaction.value!!.generalFormulas) { generalFormula ->
                                Image(
                                    painter = rememberImagePainter(
                                        "${IMAGE_URL}${reaction.value!!.directoryName}/${generalFormula.imageName}",
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

                        if (reaction.value!!.mechanisms.isNotEmpty()) {
                            item {
                                Text(
                                    "Mechanism",
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }

                            items(reaction.value!!.mechanisms) { mechanism ->
                                Image(
                                    painter = rememberImagePainter(
                                        "${IMAGE_URL}${reaction.value!!.directoryName}/${mechanism.imageName}",
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

                        if (reaction.value!!.examples.isNotEmpty()) {
                            item {
                                Text(
                                    "Example",
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }

                            items(reaction.value!!.examples) { example ->
                                Image(
                                    painter = rememberImagePainter(
                                        "${IMAGE_URL}${reaction.value!!.directoryName}/${example.imageName}",
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

                        if (reaction.value!!.supplements.isNotEmpty()) {
                            item {
                                Text(
                                    "Supplements",
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }

                            items(reaction.value!!.supplements) { supplement ->
                                Image(
                                    painter = rememberImagePainter(
                                        "${IMAGE_URL}${reaction.value!!.directoryName}/${supplement.imageName}",
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

                        if (reaction.value!!.youtubeLinks.isNotEmpty()) {
                            item {
                                Text(
                                    "Youtube",
                                    fontSize = 14.sp,
                                    fontWeight = FontWeight.Bold
                                )
                            }

                            items(reaction.value!!.youtubeLinks) { youtubeLink ->
                                val uri = URI(youtubeLink)
                                val path: String = uri.path
                                val context = LocalContext.current

                                Image(
                                    painter = rememberImagePainter(
                                        "https://img.youtube.com/vi${path}/0.jpg",
                                        builder = {
                                            this.placeholder(R.drawable.placeholder)
                                                .size(SizeResolver(OriginalSize))
                                        },
                                    ),
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
        }
    }

//    Scaffold(
//        topBar = {
//            TopAppBar(
//                title = {
//                    Row {
//                        Text(reaction.value?.english ?: "")
//                    }
//                },
//                navigationIcon = if (navController.previousBackStackEntry != null) {
//                    {
//                        IconButton(onClick = { navController.navigateUp() }) {
//                            Icon(
//                                imageVector = Icons.Filled.ArrowBack,
//                                contentDescription = "Back"
//                            )
//                        }
//                    }
//                } else {
//                    null
//                }
//            )
//        },
//        content = {

//        }
//    )
}
