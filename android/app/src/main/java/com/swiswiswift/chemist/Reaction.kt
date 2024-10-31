package com.swiswiswift.chemist

data class Reaction(
    var directoryName: String,
    var english: String,
    var thmbnailName: String,
    var generalFormulas: List<ReactionContent>,
    var mechanisms: List<ReactionContent>,
    var examples: List<ReactionContent>,
    var supplements: List<ReactionContent>,
    var youtubeLinks: List<String>,
)
