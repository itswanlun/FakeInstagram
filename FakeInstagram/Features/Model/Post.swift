import Foundation

struct PostResult: Codable {
    let data: [PostItem]
}

// MARK: - Datum
struct PostItem: Codable {
    let accountImage: String
    let account: String
    let contentImage: String
    let likeButtonStatus: Bool
    let likeCount: Int
    let content: String
}
