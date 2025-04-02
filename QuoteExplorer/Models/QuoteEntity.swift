import Foundation
import SwiftData

@Model
class QuoteEntity {
    @Attribute(.unique) var id: UUID
    var text: String
    var author: String

    init(id: UUID, text: String, author: String) {
        self.id = id
        self.text = text
        self.author = author
    }
}
