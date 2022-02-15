import Foundation

struct PostResult: Codable {
    let data: [PostItem]
}

struct PostItem: Codable {
    let id: Int
    let accountImage: String
    let account: String
    let contentImage: [URL]
    var likeButtonStatus: Bool
    let likeCount: Int
    let content: String
}

extension PostItem {
    func asPostHeaderItemWith(_ section: PostSection) -> PostHeaderItem {
        return PostHeaderItem(sectionIdentifier: section.identifier,
                              title: self.account,
                              url: URL(string: self.accountImage)!) // TODO:
    }
    
    func asPostImageItemWith(_ section: PostSection) -> PostImageItem {
        return PostImageItem(sectionIdentifier: section.identifier, url: self.contentImage[0])
    }
    
    func asPostImageCarouselItemWith(_ section: PostSection) -> PostImageCarouselItem {
        return PostImageCarouselItem(sectionIdentifier: section.identifier,
                                     imageURLs: self.contentImage,
                                     page: 0)
    }

    func asPostActionsItemWith(_ section: PostSection) -> PostActionsItem {
        return PostActionsItem(sectionIdentifier: section.identifier,
                               likeButtonStatus: self.likeButtonStatus,
                               id: self.id,
                               page: 0,
                               totalPage: self.contentImage.count)
    }
    
    func asPostContentItemWith(_ section: PostSection) -> PostContentItem {
        return PostContentItem(sectionIdentifier: section.identifier, likeCount: self.likeCount, account: self.account, content: self.content)
    }
}
