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
