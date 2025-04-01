import Foundation

struct Quote: Identifiable, Decodable, Equatable {
    let id = UUID()
    let text: String
    let author: String
    var isFavorite: Bool = false

    enum CodingKeys: String, CodingKey {
        case text = "q"
        case author = "a"
    }
}

