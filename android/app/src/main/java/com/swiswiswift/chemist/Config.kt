package com.swiswiswift.chemist

import java.net.URLEncoder

const val RESOURCE_URL = "https://chemist.swiswiswift.com/resource/"
const val IMAGE_URL = "${RESOURCE_URL}images/"

// ランディングページ（lp/）の利用規約・プライバシーポリシー
const val TERMS_URL = "https://chemist.swiswiswift.com/terms.html"
const val PRIVACY_POLICY_URL = "https://chemist.swiswiswift.com/privacy.html"

// 利用規約・プライバシーポリシーと同じお問い合わせフォーム
const val CONTACT_FORM_URL =
    "https://docs.google.com/forms/d/e/1FAIpQLSckMT89daG9mXLGJJ7DAMWqsql2opnOo25Amm5kuCR4ZuwOvg/viewform"

/**
 * 端末・OS とアプリのバージョンを事前入力したお問い合わせフォームの URL。
 * entry の ID は Google フォームの各質問に振られたもの。質問を作り直したら変わる。
 */
fun contactFormUrl(device: String, appVersion: String): String {
    fun encode(value: String) = URLEncoder.encode(value, Charsets.UTF_8.name())
    return "$CONTACT_FORM_URL?usp=pp_url" +
        "&entry.26242826=${encode(device)}" +
        "&entry.1790724873=${encode(appVersion)}"
}
