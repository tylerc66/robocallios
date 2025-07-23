import Foundation
import CallKit

class BlockListViewModel: ObservableObject {
    @Published var count: Int = 0
    @Published var lastUpdated: Date?

    private let manager = BlockListManager.shared

    func fetchIfNeeded() {
        if let last = manager.lastUpdated,
           Calendar.current.dateComponents([.day], from: last, to: Date()).day ?? 0 < 7 {
            refreshInfo()
            return
        }
        update()
    }

    func refreshInfo() {
        count = manager.loadNumbers().count
        lastUpdated = manager.lastUpdated
    }

    func update() {
        manager.fetchLatest { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshInfo()
                self?.reloadExtension()
            }
        }
    }

    private func reloadExtension() {
        let identifier = "com.freshtechconcepts.robocallblocker.CallBlockerExtension"
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: identifier) { error in
            if let error = error {
                print("Error reloading extension: \(error)")
            }
        }
    }
}
