import Foundation

struct StoryResult: Codable {
    let data: [StoryItem]
}

struct StoryItem : Codable{
    let imageURL: String
    let title: String
}

struct StoryHeightlightSection: Section {
    let type = SectionType.storyHeightlights
    var items = [RowItem]()
}

struct StoryHeightlightItem: RowItem {
    let type = RowType.story
    let cellItem: [StoryItem]
    
    init(items: [StoryItem]) {
        self.cellItem = items
    }
}
