import Foundation

struct StoryResult: Codable {
    let data: [StoryItem]
}

struct StoryItem : Codable{
    let imageURL: String
    let title: String
}
