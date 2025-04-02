import SwiftUI
import SwiftData

enum SortOption: String, CaseIterable, Identifiable {
    case author = "Author"
    case length = "Length"

    var id: String { rawValue }
}

struct QuoteListView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: QuoteListViewModel
    @State private var searchText: String = ""
    @State private var sortOption: SortOption = .author

    init() {
        _viewModel = StateObject(wrappedValue: QuoteListViewModel(context: ModelContext(try! ModelContainer(for: QuoteEntity.self))))
    }

    var body: some View {
        NavigationView {
            VStack {
                Picker("Sort by", selection: $sortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if viewModel.isLoading {
                    ProgressView("Loading Quotes...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List {
                        Section {
                            ForEach(sortedAndFilteredQuotes) { quote in
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

    private var sortedAndFilteredQuotes: [Quote] {
        let filtered = searchText.isEmpty
            ? viewModel.quotes
            : viewModel.quotes.filter {
                $0.text.localizedCaseInsensitiveContains(searchText) ||
                $0.author.localizedCaseInsensitiveContains(searchText)
            }

        switch sortOption {
        case .author:
            return filtered.sorted { $0.author.lowercased() < $1.author.lowercased() }
        case .length:
            return filtered.sorted { $0.text.count < $1.text.count }
        }
    }
}
