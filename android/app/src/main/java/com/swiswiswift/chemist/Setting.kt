package com.swiswiswift.chemist

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalUriHandler
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.navigation.NavController

@Composable
fun Setting(navController: NavController) {
    val uriHandler = LocalUriHandler.current

    Scaffold(
        topBar = {
            TopBar(stringResource(R.string.setting_title))
        },
    ) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState()),
        ) {
            SettingSectionHeader(stringResource(R.string.notice_title))
            SettingRow(stringResource(R.string.notice_title)) {
                navController.navigate("notice")
            }

            SettingSectionHeader(stringResource(R.string.setting_app_info))
            SettingRow(stringResource(R.string.setting_contact)) {
                uriHandler.openUri(CONTACT_FORM_URL)
            }
            SettingRow(stringResource(R.string.setting_terms)) {
                uriHandler.openUri(TERMS_URL)
            }
            SettingRow(stringResource(R.string.setting_privacy_policy)) {
                uriHandler.openUri(PRIVACY_POLICY_URL)
            }
            SettingRow(
                title = stringResource(R.string.setting_version),
                value = "${BuildConfig.VERSION_NAME} (${BuildConfig.VERSION_CODE})",
            )
        }
    }
}

@Composable
private fun SettingSectionHeader(title: String) {
    Text(
        title,
        fontSize = 13.sp,
        color = Color.Gray,
        modifier = Modifier.padding(start = 16.dp, top = 24.dp, bottom = 8.dp),
    )
}

@Composable
private fun SettingRow(title: String, value: String? = null, onClick: (() -> Unit)? = null) {
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .then(if (onClick != null) Modifier.clickable(onClick = onClick) else Modifier),
    ) {
        Row(modifier = Modifier.padding(horizontal = 16.dp, vertical = 14.dp)) {
            Text(title, fontSize = 15.sp, modifier = Modifier.weight(1f))
            if (value != null) {
                Text(value, fontSize = 15.sp, color = Color.Gray)
            }
        }
        HorizontalDivider(thickness = 1.dp)
    }
}
