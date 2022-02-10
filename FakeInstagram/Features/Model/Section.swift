import Foundation

enum RowType {
    // storyHeightlights
    case story
    // post
    case header
    case image
    case action
    case content
}

enum SectionType {
    case storyHeightlights
    case post
}

protocol Section {
    var type: SectionType { get }
    var items: [RowItem] { get }
}

protocol RowItem {
    var type: RowType { get }
}
