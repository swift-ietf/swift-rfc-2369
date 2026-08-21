extension RFC_2369.List.Post {

    public enum Error: Swift.Error, Sendable, Equatable, CustomStringConvertible {
        case empty
        case invalidIRI(_ value: String)
        case noURIs(_ value: String)
    }
}

extension RFC_2369.List.Post.Error {
    public var description: String {
        switch self {
        case .empty:
            return "List-Post value cannot be empty"

        case .invalidIRI(let value):
            return "Invalid IRI in List-Post: '\(value)'"

        case .noURIs(let value):
            return "No valid URIs found in List-Post: '\(value)'"
        }
    }
}
