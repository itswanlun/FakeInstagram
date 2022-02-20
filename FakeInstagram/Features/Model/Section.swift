import Foundation

enum SectionType {
    case post
    case recommend
}

enum RowType {
    case header
    case image
    case imageCarousel
    case action
    case content
    case account
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
