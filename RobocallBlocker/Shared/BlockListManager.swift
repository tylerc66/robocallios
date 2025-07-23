import Foundation

final class BlockListManager {
    static let shared = BlockListManager()

    private let groupID = "group.com.freshtechconcepts.robocallblocker"
    private let blockListURL = URL(string: "http://freshtechconcepts.com/blacklists/robocall-blacklist.csv")!
    private let fileName = "blockedNumbers.txt"
    private let userDefaults: UserDefaults

    private init() {
        userDefaults = UserDefaults(suiteName: groupID) ?? .standard
    }

    private var containerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)
    }

    private var numbersFileURL: URL? {
        containerURL?.appendingPathComponent(fileName)
    }

    func loadNumbers() -> [Int64] {
        guard let fileURL = numbersFileURL,
              let data = try? Data(contentsOf: fileURL),
              let string = String(data: data, encoding: .utf8) else {
            return []
        }
        return string.split(separator: "\n").compactMap { Int64($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
    }

    private func save(numbers: [Int64]) throws {
        guard let url = numbersFileURL else { return }
        let content = numbers.map { String($0) }.joined(separator: "\n")
        try content.write(to: url, atomically: true, encoding: .utf8)
    }

    var lastUpdated: Date? {
        get { userDefaults.object(forKey: "lastUpdated") as? Date }
        set { userDefaults.set(newValue, forKey: "lastUpdated") }
    }

    func fetchLatest(completion: @escaping (Result<Int, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: blockListURL) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, let string = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "BlockList", code: -1, userInfo: nil)))
                return
            }
            let numbers = string.split(separator: "\n").compactMap { Int64($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
            do {
                try self.save(numbers: numbers)
                self.lastUpdated = Date()
                completion(.success(numbers.count))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
