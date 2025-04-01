import Foundation

struct Quote: Identifiable, Decodable {
    let id = UUID()
    let text: String
    let author: String

    enum CodingKeys: String, CodingKey {
        case text = "q"
        case author = "a"
    }
}
