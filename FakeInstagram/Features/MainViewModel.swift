import Foundation

class MainViewModel {
    // MARK: - Properties
    private(set) var data = [Section]()
    private(set) var page: Int = 1
    private(set) var storyHightlightData = [StoryItem]()
    private(set) var isLoadingMore: Bool = false {
        didSet{
            isLoadingClosure?(isLoadingMore)
        }
    }
    
    // MARK: - Closure
    var dataChangeClosure: (() -> Void)?
    var headerChangeClosure: (([StoryItem]) -> Void)?
    var isLoadingClosure: ((Bool) -> Void)?
    var partDataChangeClosure: (([IndexPath]) -> Void)?
    
    private func parseItem(indexPath: IndexPath) -> Row {
        return data[indexPath.section].rows[indexPath.row]
    }
    
    private func updateItem(row: Row, indexPath: IndexPath) {
        data[indexPath.section].rows[indexPath.row] = row
    }
}

// MARK: - Actions
extension MainViewModel {
    func refresh() {
        page = 1
        loadPostData(isRefresh: true)
    }
    
    func loadNextPageIfNeed(section: Int) {
        let triggerRow = data.count - 3
        
        if (section > triggerRow) && !isLoadingMore {
            page += 1
            loadPostData()
        }
    }
    
    func updateLikeStatus(info: LikeButtonInfo) {
        if let item = parseItem(indexPath: info.indexPath) as? PostActionsItem {
            FakeAPIService.shared.changeLikeStatus(id: item.id, status: info.status)
            
            let postActionItem = PostActionsItem(sectionIdentifier: item.sectionIdentifier,
                                                 likeButtonStatus: !info.status,
                                                 id: item.id,
                                                 page: item.page,
                                                 totalPage: item.totalPage)
            updateItem(row: postActionItem, indexPath: info.indexPath)
        }
    }
    
    func changeSectionPage(_ page: Int, indexPath carouselItemIndexPath: IndexPath) {
        let sectionNumber = carouselItemIndexPath.section
        let section = data[sectionNumber]
        let carouselItemIndex = carouselItemIndexPath.row
        
        guard let actionItemIndex = section.rows.firstIndex(where: { $0 is PostActionsItem}),
              var carouselItem = section.rows[carouselItemIndex] as? PostImageCarouselItem,
              var actionItem = section.rows[actionItemIndex] as? PostActionsItem
        else {
            return
        }
        
        let carouselItemIndexPath = IndexPath(row: carouselItemIndex, section: sectionNumber)
        let actionItemIndexPath = IndexPath(row: actionItemIndex, section: sectionNumber)
        
        carouselItem.page = page
        actionItem.page = page
        
        updateItem(row: carouselItem, indexPath: carouselItemIndexPath)
        updateItem(row: actionItem, indexPath: actionItemIndexPath)
        
        partDataChangeClosure?([actionItemIndexPath])
    }
}

// MARK: - Load Data
extension MainViewModel {
    func loadStoryHightlightsData() {
        FakeAPIService.shared.getStoryHeightlight { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let story):
                self.storyHightlightData = story
                self.headerChangeClosure?(story)
            case .failure:
                print("error") // TODO: Error handling
            }
        }
    }
    
    func loadPostData(isRefresh: Bool = false) {
        isLoadingMore = true
        
        FakeAPIService.shared.getPost(page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoadingMore = false
            
            switch result {
            case .success(let post):
                guard !post.isEmpty else { return }
                
                if isRefresh {
                    self.data = post.map { self.generatePostSection(item: $0) }
                } else {
                    for postData in post {
                        self.data.append(self.generatePostSection(item: postData))
                    }
                }
                
                self.dataChangeClosure?()
            case .failure:
                print("error") // TODO: Error handling
            }
        }
    }
    
    private func generatePostSection(item: PostItem) -> Section {
        var section = PostSection()
        
        section.rows.append(item.asPostHeaderItemWith(section))
        
        if item.contentImage.count == 1 {
            section.rows.append(item.asPostImageItemWith(section))
        } else if item.contentImage.count > 1 {
            section.rows.append(item.asPostImageCarouselItemWith(section))
        }
        
        section.rows.append(item.asPostActionsItemWith(section))
        section.rows.append(item.asPostContentItemWith(section))
        
        return section
    }
}
