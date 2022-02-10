import Foundation

struct PostSection: Section {
    let type = SectionType.post
    var items = [RowItem]()
}

struct PostHeaderItem: RowItem {
    let type = RowType.header
    let title: String
    let url: URL
    
    init(title: String, url: URL) {
        self.title = title
        self.url = url
    }
}

struct PostImageItem: RowItem {
    let type = RowType.image
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}

struct PostActionsItem: RowItem {
    let type = RowType.action
    let likeButtonStatus: Bool
    
    init(likeButtonStatus: Bool) {
        self.likeButtonStatus = likeButtonStatus
    }
}

struct PostContentItem: RowItem {
    let type = RowType.content
    let likeCount: Int
    let account: String
    let content: String
    
    init(likeCount: Int, account: String, content: String) {
        self.likeCount = likeCount
        self.account = account
        self.content = content
    }
}
