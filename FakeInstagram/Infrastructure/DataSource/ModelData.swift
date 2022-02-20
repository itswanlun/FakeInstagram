import Foundation

let storyData: StoryResult = load("StoryHeightlight.json")
let recommendData: RecommendResult = load("RecommendHeightlight.json")

let post1Data: PostResult = load("Post1.json")
let post2Data: PostResult = load("Post2.json")
let post3Data: PostResult = load("Post3.json")
let post4Data: PostResult = load("Post4.json")
let post5Data: PostResult = load("Post5.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
