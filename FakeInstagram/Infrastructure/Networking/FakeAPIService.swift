import Foundation

class FakeAPIService {
    static let shared = FakeAPIService()
    
    private init() { }
    
    func getStoryHeightlight(completionHandler: @escaping (Result<[StoryItem], NetworkError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.async {
                completionHandler(Result.success(storyData.data))
            }
        }
    }
    
    func getPost(page: Int, completionHandler: @escaping (Result<[PostItem], NetworkError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            
            var items = [PostItem]()
            
            switch page {
            case 1:
                items = post1Data.data
            case 2:
                items = post2Data.data
            case 3:
                items = post3Data.data
            case 4:
                items = post4Data.data
            case 5:
                items = post5Data.data
            default:
                break
            }
            
            for (index, _) in items.enumerated() {
                items[index].likeButtonStatus = self.getLikeStatus(id: items[index].id)
            }
            
            DispatchQueue.main.async {
                completionHandler(Result.success(items))
            }
        }
    }
    
    func changeLikeStatus(id: Int, status: Bool) {
        setLikeStatus(id: id, status: status)
    }
    
    // MARK: - Private
    private func setLikeStatus(id: Int, status: Bool) {
        UserDefaults.standard.setValue(status, forKey: "POST_" + "\(id)")
    }
    
    private func getLikeStatus(id: Int) -> Bool {
        if let value = UserDefaults.standard.value(forKey: "POST_" + "\(id)") as? Bool {
            return value
        }
        
        return false
    }
}
