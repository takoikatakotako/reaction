package com.swiswiswift.chemist

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.material.*
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.swiswiswift.chemist.ui.theme.ReactionTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        val reactionListiewModel = ReactionListViewModel()
        super.onCreate(savedInstanceState)
        setContent {
            ReactionTheme {
                Surface(color = MaterialTheme.colors.background) {
                    val navController = rememberNavController()
                    NavHost(navController, startDestination = "list") {
                        composable("list") {
                            ReactionList(navController, reactionListiewModel)
                        }

                        composable(
                            "detail/{reactionName}",
                            arguments = listOf(navArgument("reactionName") {
                                type = NavType.StringType
                            })
                        ) { backStackEntry ->
                            val reactionName = backStackEntry.arguments?.getString("reactionName")!!
                            ReactionDetail(
                                navController = navController,
                                directoryName = reactionName,
                            )
                        }
                    }
                }
            }
        }
    }
}
