import Foundation

extension JSONDecoder {
    static let FlickrAPI: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.mySqlDateTime)
        return decoder
    }()
}

private extension DateFormatter {
    static let mySqlDateTime = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}
