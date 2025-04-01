import Foundation
import Combine

@MainActor
class QuoteListViewModel: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadQuotes() {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedQuotes = try await QuoteService.shared.fetchRandomQuotes()
                quotes = fetchedQuotes
            } catch {
                errorMessage = "Failed to load quotes. Please try again."
            }
            isLoading = false
        }
    }

    func toggleFavorite(for quote: Quote) {
        guard let index = quotes.firstIndex(of: quote) else { return }
        quotes[index].isFavorite.toggle()
    }
}

