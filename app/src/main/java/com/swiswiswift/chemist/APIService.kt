//package com.swiswiswift.chemist
//
//import retrofit2.Retrofit
//import retrofit2.converter.gson.GsonConverterFactory
//import retrofit2.http.GET
//import retrofit2.http.Path
//
//interface APIService {
//    @GET("reactions.json")
//    suspend fun getReactions(): List<Reaction>
//
//    @GET("reactions/{directoryName}.json")
//    suspend fun getReaction(@Path("directoryName") directoryName: String): Reaction
//
//    companion object {
//        var apiService: APIService? = null
//        fun getInstance(): APIService {
//            if (apiService == null) {
//                apiService = Retrofit.Builder()
//                    .baseUrl(RESOURCE_URL)
//                    .addConverterFactory(GsonConverterFactory.create())
//                    .build().create(APIService::class.java)
//            }
//            return apiService!!
//        }
//    }
//}