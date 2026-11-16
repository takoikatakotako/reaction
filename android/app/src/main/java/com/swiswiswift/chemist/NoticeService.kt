package com.swiswiswift.chemist

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Header

interface NoticeService {
    // お知らせは更新を早く反映したいのでキャッシュを使わない
    @GET("android.json")
    suspend fun getNotices(@Header("Cache-Control") cacheControl: String = "no-cache"): NoticesResponse

    companion object {
        val instance: NoticeService by lazy {
            Retrofit.Builder()
                .baseUrl(BuildConfig.NOTICE_BASE_URL)
                .addConverterFactory(GsonConverterFactory.create())
                .build()
                .create(NoticeService::class.java)
        }
    }
}
