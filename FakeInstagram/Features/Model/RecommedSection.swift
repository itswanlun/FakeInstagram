import Foundation

struct RecommendSection: Section {
    let identifier = UUID()
    let type = SectionType.recommend
    
    var rows = [Row]()
}

struct RecommendListItem: Row {
    let sectionIdentifier: UUID
    let type = RowType.account
    let data: [RecommendItem]
    
    init(sectionIdentifier: UUID, data: [RecommendItem]) {
        self.sectionIdentifier = sectionIdentifier
        self.data = data
    }
}
