extension RFC_2369.List.Header {

    public enum Error: Swift.Error, Sendable, Equatable, CustomStringConvertible {
        case invalidIRI(_ value: String)
    }
}

extension RFC_2369.List.Header.Error {
    public var description: String {
        switch self {
        case .invalidIRI(let value):
            return "Invalid IRI in list header: '\(value)'"
        }
    }
}
