import Foundation
import Combine

class QuoteService {
    static let shared = QuoteService()
    private init() {}

    func fetchRandomQuotes() async throws -> [Quote] {
        guard let url = URL(string: "https://zenquotes.io/api/quotes") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Quote].self, from: data)
    }
}
