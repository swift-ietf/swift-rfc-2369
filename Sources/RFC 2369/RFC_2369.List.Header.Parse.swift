//
//  RFC_2369.List.Header.Parse.swift
//  swift-rfc-2369
//
//  RFC 2369 list header: comma-separated angle-bracketed URIs
//

public import Parser_Primitives

extension RFC_2369.List.Header {
    /// Parses an RFC 2369 list header value.
    ///
    /// `list-header = "<" URI ">" *("," "<" URI ">")`
    ///
    /// Returns the raw URI byte slices (without angle brackets).
    public struct Parse<Input: Collection.Slice.`Protocol`>: Sendable
    where Input: Sendable, Input.Element == UInt8 {
        @inlinable
        public init() {}
    }
}

extension RFC_2369.List.Header.Parse {
    public typealias Output = [Input]

    public enum Error: Swift.Error, Sendable, Equatable {
        case expectedOpenAngle
        case unterminatedURI
    }
}

extension RFC_2369.List.Header.Parse: Parser.`Protocol` {
    public typealias Failure = RFC_2369.List.Header.Parse<Input>.Error

    @inlinable
    public func parse(_ input: inout Input) throws(Failure) -> Output {
        var uris: [Input] = []

        while input.startIndex < input.endIndex {
            // Skip whitespace and commas
            Self._skipSeparators(&input)

            guard input.startIndex < input.endIndex else { break }

            // Expect '<'
            guard input[input.startIndex] == 0x3C else {
                if uris.isEmpty { throw .expectedOpenAngle }
                break
            }
            input = input[input.index(after: input.startIndex)...]

            // Consume URI (until '>')
            let uriStart = input.startIndex
            while input.startIndex < input.endIndex && input[input.startIndex] != 0x3E {
                input = input[input.index(after: input.startIndex)...]
            }
            guard input.startIndex < input.endIndex else { throw .unterminatedURI }

            let uri = input[uriStart..<input.startIndex]
            uris.append(uri)

            // Skip '>'
            input = input[input.index(after: input.startIndex)...]
        }

        return uris
    }

    @inlinable
    static func _skipSeparators(_ input: inout Input) {
        while input.startIndex < input.endIndex {
            let byte = input[input.startIndex]
            guard byte == 0x20 || byte == 0x09 || byte == 0x2C
                || byte == 0x0D || byte == 0x0A
            else { break }
            input = input[input.index(after: input.startIndex)...]
        }
    }
}
