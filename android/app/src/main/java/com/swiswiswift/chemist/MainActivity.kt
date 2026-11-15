package com.swiswiswift.chemist

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Surface
import androidx.compose.ui.Modifier
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.swiswiswift.chemist.ui.theme.ReactionTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val reactionListViewModel = ReactionListViewModel()
        val noticeListViewModel = NoticeListViewModel()
        enableEdgeToEdge()
        setContent {
            ReactionTheme(darkTheme = false) {
                val navController = rememberNavController()
                Surface(
                    modifier = Modifier.fillMaxSize()
                ) {
                    NavHost(
                        navController, startDestination = "list",
                    ) {
                        composable("list") {
                            ReactionList(navController, reactionListViewModel)
                        }

                        composable(
                            "detail/{reactionName}",
                            arguments = listOf(navArgument("reactionName") {
                                type = NavType.StringType
                            })
                        ) { backStackEntry ->
                            val reactionName = backStackEntry.arguments?.getString("reactionName")!!
                            val reaction: Reaction? = reactionListViewModel.getReaction(reactionName)
                            ReactionDetail(
                                navController = navController,
                                reaction = reaction,
                            )
                        }

                        composable("notice") {
                            NoticeList(navController, noticeListViewModel)
                        }

                        composable(
                            "notice/{noticeId}",
                            arguments = listOf(navArgument("noticeId") {
                                type = NavType.StringType
                            })
                        ) { backStackEntry ->
                            val noticeId = backStackEntry.arguments?.getString("noticeId").orEmpty()
                            NoticeDetail(
                                notice = noticeListViewModel.getNotice(noticeId),
                                language = noticeListViewModel.language,
                            )
                        }
                    }
                }
            }
        }
    }
}
