import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        if let error = addBlockingPhoneNumbers(to: context) {
            context.cancelRequest(withError: error)
            return
        }
        context.completeRequest()
    }

    private func addBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) -> Error? {
        let numbers = BlockListManager.shared.loadNumbers()
        for number in numbers {
            context.addBlockingEntry(withNextSequentialPhoneNumber: number)
        }
        return nil
    }
}
