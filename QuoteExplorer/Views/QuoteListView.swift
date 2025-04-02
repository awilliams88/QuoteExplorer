import SwiftUI
import SwiftData

struct QuoteListView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: QuoteListViewModel
    @State private var searchText: String = ""

    init() {
        _viewModel = StateObject(wrappedValue: QuoteListViewModel(context: ModelContext(try! ModelContainer(for: QuoteEntity.self))))
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Quotes...")
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    List {
                        Section {
                            ForEach(filteredQuotes) { quote in
                                HStack {
                                    NavigationLink(destination: QuoteDetailView(quote: quote)) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("“\(quote.text)”")
                                                .font(.body)
                                            Text("- \(quote.author)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }

                                    Spacer()

                                    Button(action: {
                                        viewModel.toggleFavorite(for: quote)
                                    }) {
                                        Image(systemName: quote.isFavorite ? "heart.fill" : "heart")
                                            .foregroundColor(quote.isFavorite ? .red : .gray)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        Section {
                            NavigationLink("Favorites") {
                                FavoriteQuotesView()
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }

                Button("Refresh Quotes") {
                    viewModel.loadQuotes()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("Quote Explorer")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .onAppear {
            viewModel.loadQuotes()
        }
    }

    private var filteredQuotes: [Quote] {
        if searchText.isEmpty {
            return viewModel.quotes
        } else {
            return viewModel.quotes.filter {
                $0.text.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
