import Foundation
import Combine
import SwiftData

@MainActor
class QuoteListViewModel: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func loadQuotes() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetched = try await QuoteService.shared.fetchRandomQuotes()
                let storedFavorites = try context.fetch(FetchDescriptor<QuoteEntity>())

                let merged = fetched.map { quote in
                    var q = quote
                    if storedFavorites.contains(where: { $0.id == quote.id }) {
                        q.isFavorite = true
                    }
                    return q
                }

                quotes = merged
            } catch {
                errorMessage = "Failed to load quotes."
            }
            isLoading = false
        }
    }

    func toggleFavorite(for quote: Quote) {
        guard let index = quotes.firstIndex(of: quote) else { return }
        quotes[index].isFavorite.toggle()

        if quotes[index].isFavorite {
            let entity = QuoteEntity(id: quote.id, text: quote.text, author: quote.author)
            context.insert(entity)
        } else {
            if let entity = try? context.fetch(FetchDescriptor<QuoteEntity>()).first(where: { $0.id == quote.id }) {
                context.delete(entity)
            }
        }

        try? context.save()
    }
}
