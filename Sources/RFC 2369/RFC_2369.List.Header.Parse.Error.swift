import Parser


extension RFC_2369.List.Header.Parse {
    public enum Error: Swift::Error, Sendable, Equatable {
        case expectedOpenAngle
        case unterminatedURI
    }
}
