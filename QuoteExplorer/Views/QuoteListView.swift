import SwiftUI

struct QuoteListView: View {
    @StateObject private var viewModel = QuoteListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Quotes...")
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.quotes) { quote in
                            HStack {
                                NavigationLink(destination: QuoteDetailView(quote: quote)) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("“\(quote.text)”")
                                            .font(.body)
                                        Text("- \(quote.author)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 4)
                                }

                                Spacer()

                                Button(action: {
                                    viewModel.toggleFavorite(for: quote)
                                }) {
                                    Image(systemName: quote.isFavorite ? "heart.fill" : "heart")
                                        .foregroundColor(quote.isFavorite ? .red : .gray)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                    }
                    .listStyle(.plain)
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
        }
        .onAppear {
            viewModel.loadQuotes()
        }
    }
}

