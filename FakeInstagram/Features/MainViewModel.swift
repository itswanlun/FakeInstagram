import Foundation

class MainViewModel {
    // MARK: - Properties
    let group = DispatchGroup()
    
    private(set) var data = [Section]()
    private(set) var recommendData = [RecommendItem]()
    private(set) var postData = [PostItem]()
    
    private(set) var page: Int = 1
    private(set) var storyHightlightData = [StoryItem]()
    private(set) var recommendHightlightData = [RecommendItem]()
    private(set) var isLoadingMore: Bool = false {
        didSet {
            isLoadingClosure?(isLoadingMore)
        }
    }
    
    var isNoResult: Bool = false {
        didSet {
            isNoResultClosure?(isNoResult)
        }
    }
    
    // MARK: - Closure
    var viewStateChageClosure: ((ViewState) -> Void)?
    var dataChangeClosure: (() -> Void)?
    var partDataChangeClosure: (([IndexPath]) -> Void)?
    var loadMoreDataChangeClosure: (([Int]) -> Void)?
    var headerChangeClosure: (([StoryItem]) -> Void)?
    var isLoadingClosure: ((Bool) -> Void)?
    var isNoResultClosure: ((Bool) -> Void)?
    
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
        loadData()
    }
    
    func loadNextPageIfNeed(section: Int) {
        let triggerRow = data.count - 3
        
        if (section > triggerRow) && !isLoadingMore {
            page += 1
            loadPostData(isKeepLoadingData: true)
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
    func loadData() {
        loadStoryHightlightsData()
        loadRecommendHightlightsData()
        loadPostData()
        
        group.notify(queue: DispatchQueue.global()) { [weak self] in
            guard let self = self else { return }
            
            if !self.recommendData.isEmpty && !self.postData.isEmpty && !self.storyHightlightData.isEmpty {
                let recommandIndex = 5
                
                var tempData = [Section]()
                for post in self.postData {
                    tempData.append(self.generatePostSection(item: post))
                }
                
                tempData.insert(self.generateRecommendSection(item: self.recommendData), at: recommandIndex)
                
                self.data = tempData
                self.dataChangeClosure?()
                self.headerChangeClosure?(self.storyHightlightData)
                
                self.viewStateChageClosure?(.success)
            } else {
                self.viewStateChageClosure?(.error)
            }
        }
    }
    
    func loadStoryHightlightsData() {
        group.enter()
        FakeAPIService.shared.getStoryHeightlight { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let story):
                self.storyHightlightData = story
            case .failure:
                self.storyHightlightData = []
            }
            self.group.leave()
        }
    }
    
    func loadRecommendHightlightsData() {
        group.enter()
        FakeAPIService.shared.getRecommendHeightlight { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let recommend):
                self.recommendData = recommend
            case .failure:
                self.recommendData = []
            }
            self.group.leave()
        }
    }
    
    func loadPostData(isKeepLoadingData: Bool = false) {
        if !isKeepLoadingData {
            group.enter()
        }
        
        isLoadingMore = true
        
        FakeAPIService.shared.getPost(page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoadingMore = false
            
            switch result {
            case .success(let post):
                guard !post.isEmpty else {
                    self.isNoResult = true
                    return
                }
                
                self.postData = post
                if isKeepLoadingData {
                    let start = self.data.count
                    let end = self.data.count + post.count
                    for postData in post {
                        self.data.append(self.generatePostSection(item: postData))
                    }
                    self.loadMoreDataChangeClosure?(Array(start..<end))
                }
            case .failure:
                self.postData = []
            }
            
            if !isKeepLoadingData {
                self.group.leave()
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
    
    private func generateRecommendSection(item: [RecommendItem]) -> Section {
        var section = RecommendSection()
        section.rows.append(RecommendListItem(sectionIdentifier: section.identifier, data: item))
        
        return section
    }
}
