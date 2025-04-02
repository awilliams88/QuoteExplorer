import SwiftUI
import SwiftData

struct FavoriteQuotesView: View {
    @Environment(\.modelContext) private var context
    @Query private var favoriteQuotes: [QuoteEntity]

    var body: some View {
        List {
            ForEach(favoriteQuotes) { quote in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("“\(quote.text)”")
                            .font(.body)
                        Text("- \(quote.author)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button(action: {
                        context.delete(quote)
                        try? context.save()
                    }) {
                        Image(systemName: "heart.slash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Favorites")
    }
}
