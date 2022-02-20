import Foundation

struct RecommendResult: Codable {
    let data: [RecommendItem]
}

struct RecommendItem : Codable{
    let imageURL: String
    let title: String
}

//extension RecommendItem {
//    func asRecommendListItemWith(_ section: RecommendSection) -> RecommendListItem {
//        return RecommendListItem(sectionIdentifier: section.identifier, data: )
//    }
//}
