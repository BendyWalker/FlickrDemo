import Foundation

enum NetworkResource<T: Equatable>: Equatable {
    case loading
    case loaded(T)
    case failed(Error)

    static func == (lhs: NetworkResource<T>, rhs: NetworkResource<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.failed(lherror), .failed(rherror)):
            return lherror._code == rherror._code
        case let (.loaded(lhdata), .loaded(rhdata)):
            return lhdata == rhdata
        default:
            return false
        }
    }
}
