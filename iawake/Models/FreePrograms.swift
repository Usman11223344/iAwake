
import Foundation

struct FreePrograms: Codable {
    var type: String?
    var data: [Program]?

    enum CodingKeys: String, CodingKey {
        case type = "_type"
        case data
    }
}

struct Program: Codable {
    var id: String?
    var title: String?
    var isAvailable, isFree, isFeatured: Bool?
    var banner: Banner?
    var cover: Cover?
    var headphones: Bool?
    var descriptionHTML: String?
    var tracks: [Track]?
}

struct Banner: Codable {
    var url: String?
    var thumbnail: String?
    var resolutions: [BannerResolution]?
}


struct BannerResolution: Codable {
    var url: String?
    var size: Size?
}


struct Size: Codable {
    var width, height: Int?
}


struct Cover: Codable {
    var url: String?
    var thumbnail: String?
    var resolutions: [CoverResolution]?
}


struct CoverResolution: Codable {
    var url: String?
    var size: Int?
}


struct Track: Codable {
    var key: String?
    var title: String?
    var order: Int?
    var duration: Int?
    var media: Media?
    var isSample, isAvailable: Bool?
    var curretnPlayBackDuration: Int?
    var isPlaying: Bool?
}


struct Media: Codable {
    var mp3: Mp3?
}


struct Mp3: Codable {
    var url, headURL: String?

    enum CodingKeys: String, CodingKey {
        case url
        case headURL = "headUrl"
    }
}

