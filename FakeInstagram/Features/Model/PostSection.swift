import Foundation

struct PostSection: Section {
    let identifier = UUID()
    let type = SectionType.post
    
    var rows = [Row]()
}

struct PostHeaderItem: Row {
    let sectionIdentifier: UUID
    let type = RowType.header
    let title: String
    let url: URL
    
    init(sectionIdentifier: UUID, title: String, url: URL) {
        self.sectionIdentifier = sectionIdentifier
        self.title = title
        self.url = url
    }
}

struct PostImageItem: Row {
    let sectionIdentifier: UUID
    let type = RowType.image
    let url: URL
    
    init(sectionIdentifier: UUID, url: URL) {
        self.sectionIdentifier = sectionIdentifier
        self.url = url
    }
}

struct PostImageCarouselItem: Row {
    let sectionIdentifier: UUID
    let type = RowType.imageCarousel
    let imageURLs: [URL]
    var page: Int
    
    init(sectionIdentifier: UUID, imageURLs: [URL], page: Int) {
        self.sectionIdentifier = sectionIdentifier
        self.imageURLs = imageURLs
        self.page = page
    }
}

struct PostActionsItem: Row {
    let sectionIdentifier: UUID
    let type = RowType.action
    let likeButtonStatus: Bool
    let id: Int
    var page: Int
    let totalPage: Int
    
    init(sectionIdentifier: UUID, likeButtonStatus: Bool, id: Int, page: Int, totalPage: Int) {
        self.sectionIdentifier = sectionIdentifier
        self.likeButtonStatus = likeButtonStatus
        self.id = id
        self.page = page
        self.totalPage = totalPage
    }
}

struct PostContentItem: Row {
    let sectionIdentifier: UUID
    let type = RowType.content
    let likeCount: Int
    let account: String
    let content: String
    
    init(sectionIdentifier: UUID, likeCount: Int, account: String, content: String) {
        self.sectionIdentifier = sectionIdentifier
        self.likeCount = likeCount
        self.account = account
        self.content = content
    }
}
