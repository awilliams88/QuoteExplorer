import SwiftUI

struct QuoteDetailView: View {
    let quote: Quote

    var body: some View {
        VStack(spacing: 30) {
            Text("“\(quote.text)”")
                .font(.title)
                .multilineTextAlignment(.center)

            Text("- \(quote.author)")
                .font(.title2)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .navigationTitle("Quote Detail")
    }
}
