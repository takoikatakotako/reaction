package com.swiswiswift.chemist

import org.junit.Assert.assertEquals
import org.junit.Test

class ConfigTest {
    @Test
    fun contactFormUrl_prefillsDeviceAndAppVersion() {
        val url = contactFormUrl(device = "Google Pixel 9 / Android 16", appVersion = "1.6.0 (512)")

        assertEquals(
            "$CONTACT_FORM_URL?usp=pp_url" +
                "&entry.26242826=Google+Pixel+9+%2F+Android+16" +
                "&entry.1790724873=1.6.0+%28512%29",
            url,
        )
    }
}
