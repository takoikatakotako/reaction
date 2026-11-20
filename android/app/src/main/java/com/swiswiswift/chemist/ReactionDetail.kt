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
import coil3.compose.AsyncImage
import java.net.URI

import android.content.Intent
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.core.net.toUri


@Composable
fun ReactionDetail(directoryName: String, viewModel: ReactionListViewModel) {
    // プロセスが作り直されて詳細画面だけ復元された場合は、一覧を経由しないので
    // 反応機構を持っていない。その場合はここで取得し直す。
    LaunchedEffect(directoryName) {
        if (viewModel.getReaction(directoryName) == null) {
            viewModel.getReactions()
        }
    }

    val reaction = viewModel.getReaction(directoryName)

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
                                    stringResource(R.string.reaction_detail_general_formula),
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
                                    stringResource(R.string.reaction_detail_mechanism),
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
                                    stringResource(R.string.reaction_detail_example),
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
                                    stringResource(R.string.reaction_detail_supplement),
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
                                    stringResource(R.string.reaction_detail_youtube),
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
                                                    youtubeLink.toUri()
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
                    // 取得し直しても見つからなければ、読み込み中のまま止めずに知らせる
                    Text(stringResource(if (viewModel.isFetching) R.string.common_loading else R.string.reaction_detail_error))
                }
            }
        }
    }
}
