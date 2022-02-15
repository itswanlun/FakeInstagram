import Foundation

enum SectionType {
    case post
}

enum RowType {
    case header
    case image
    case imageCarousel
    case action
    case content
}

protocol Section {
    var identifier: UUID { get }
    var type: SectionType { get }
    var rows: [Row] { get set }
}

protocol Row {
    var sectionIdentifier: UUID { get }
    var type: RowType { get }
}
