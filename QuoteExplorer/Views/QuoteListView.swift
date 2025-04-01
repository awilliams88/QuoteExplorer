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
                    List(viewModel.quotes) { quote in
                        NavigationLink(destination: QuoteDetailView(quote: quote)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("“\(quote.text)”")
                                    .font(.body)
                                Text("- \(quote.author)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
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
