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
    
    func getPost(completionHandler: @escaping (Result<[PostItem], NetworkError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.async {
                completionHandler(Result.success(postData.data))
            }
        }
    }
}
