import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BlockListViewModel()
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()

    var body: some View {
        VStack(spacing: 20) {
            Text("Blocked Numbers: \(viewModel.count)")
                .font(.title2)
            if let date = viewModel.lastUpdated {
                Text("Last Updated: \(dateFormatter.string(from: date))")
            } else {
                Text("Never Updated")
            }
            Button("Update Now") {
                viewModel.update()
            }
        }
        .padding()
        .onAppear { viewModel.fetchIfNeeded() }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
