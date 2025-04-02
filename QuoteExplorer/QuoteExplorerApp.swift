import SwiftUI
import SwiftData

@main
struct QuoteExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: QuoteEntity.self)
    }
}
