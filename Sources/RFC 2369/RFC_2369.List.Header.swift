// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-rfc-2369 open source project
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

public import ASCII_Serializer_Primitives
public import Binary_Serializable_Primitives
public import Parseable_ASCII_Primitives

extension RFC_2369.List {
    /// Complete set of list management headers as defined in RFC 2369
    ///
    /// Per RFC 2369, these headers provide automated mail list management capabilities.
    /// Each header contains one or more IRIs (typically HTTP(S) or mailto) that email
    /// clients can use to perform list operations.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let headers = try RFC_2369.List.Header(
    ///     ascii: "List-Help: <https://example.com/help>\r\nList-Post: NO\r\n".utf8
    /// )
    /// ```
    ///
    /// ## RFC 2369 Section 2: Implementation Notes
    ///
    /// > The mailing list header fields are subject to the encoding and character
    /// > restrictions for mail headers as described in [RFC 822].
    /// >
    /// > The contents of the list header fields mostly consist of angle-bracket
    /// > ('<', '>') enclosed URLs, with internal whitespace being ignored.
    /// > Multiple URLs in a single header field MUST be separated by commas.
    public struct Header: Hashable, Sendable, Codable {
        /// List-Help: URI pointing to list help information
        public let help: RFC_3987.IRI?

        /// List-Unsubscribe: One or more URIs for unsubscribing
        public let unsubscribe: [RFC_3987.IRI]?

        /// List-Subscribe: One or more URIs for subscribing
        public let subscribe: [RFC_3987.IRI]?

        /// List-Post: URI(s) for posting to the list, or .noPosting for announcement lists
        public let post: Post?

        /// List-Owner: One or more URIs for contacting the list owner
        public let owner: [RFC_3987.IRI]?

        /// List-Archive: URI pointing to the list archive
        public let archive: RFC_3987.IRI?

        /// Creates a header WITHOUT validation
        init(
            __unchecked: Void,
            help: RFC_3987.IRI?,
            unsubscribe: [RFC_3987.IRI]?,
            subscribe: [RFC_3987.IRI]?,
            post: Post?,
            owner: [RFC_3987.IRI]?,
            archive: RFC_3987.IRI?
        ) {
            self.help = help
            self.unsubscribe = unsubscribe
            self.subscribe = subscribe
            self.post = post
            self.owner = owner
            self.archive = archive
        }

        /// Creates a new set of list headers
        public init(
            help: RFC_3987.IRI? = nil,
            unsubscribe: [RFC_3987.IRI]? = nil,
            subscribe: [RFC_3987.IRI]? = nil,
            post: Post? = nil,
            owner: [RFC_3987.IRI]? = nil,
            archive: RFC_3987.IRI? = nil
        ) {
            self.init(
                __unchecked: (),
                help: help,
                unsubscribe: unsubscribe,
                subscribe: subscribe,
                post: post,
                owner: owner,
                archive: archive
            )
        }
    }
}

// MARK: - Serializable

extension RFC_2369.List.Header: ASCII.Serializable, Binary.Serializable {
    /// Own `ASCII.Serializable` verb ([FAM-012]) — the RFC 2369 List header block,
    /// composing the already-re-cut `RFC_3987.IRI` and `RFC_2369.List.Post` **ASCII**
    /// verbs directly into the `ASCII.Code` buffer (evergreen same-format composition;
    /// no byte-detour, no property-reach). The conformer's own field-name labels and
    /// delimiters are leaf-emitted on the ASCII-code substrate. Output is identical to
    /// the Binary witness body (`serializeBytes`).
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        // List-Help
        if let help = value.help {
            buffer.append(contentsOf: "List-Help".utf8.map { ASCII.Code(unchecked: Byte($0)) })
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            buffer.append(ASCII.Code.lessThanSign)
            RFC_3987.IRI.serialize(help, into: &buffer)
            buffer.append(ASCII.Code.greaterThanSign)
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

        // List-Unsubscribe
        if let unsubscribe = value.unsubscribe, !unsubscribe.isEmpty {
            buffer.append(contentsOf: "List-Unsubscribe".utf8.map { ASCII.Code(unchecked: Byte($0)) })
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            for (index, iri) in unsubscribe.enumerated() {
                if index > 0 {
                    buffer.append(ASCII.Code.comma)
                    buffer.append(ASCII.Code.space)
                }
                buffer.append(ASCII.Code.lessThanSign)
                RFC_3987.IRI.serialize(iri, into: &buffer)
                buffer.append(ASCII.Code.greaterThanSign)
            }
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

        // List-Subscribe
        if let subscribe = value.subscribe, !subscribe.isEmpty {
            buffer.append(contentsOf: "List-Subscribe".utf8.map { ASCII.Code(unchecked: Byte($0)) })
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            for (index, iri) in subscribe.enumerated() {
                if index > 0 {
                    buffer.append(ASCII.Code.comma)
                    buffer.append(ASCII.Code.space)
                }
                buffer.append(ASCII.Code.lessThanSign)
                RFC_3987.IRI.serialize(iri, into: &buffer)
                buffer.append(ASCII.Code.greaterThanSign)
            }
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

        // List-Post
        if let post = value.post {
            buffer.append(contentsOf: "List-Post".utf8.map { ASCII.Code(unchecked: Byte($0)) })
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            RFC_2369.List.Post.serialize(post, into: &buffer)
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

        // List-Owner
        if let owner = value.owner, !owner.isEmpty {
            buffer.append(contentsOf: "List-Owner".utf8.map { ASCII.Code(unchecked: Byte($0)) })
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            for (index, iri) in owner.enumerated() {
                if index > 0 {
                    buffer.append(ASCII.Code.comma)
                    buffer.append(ASCII.Code.space)
                }
                buffer.append(ASCII.Code.lessThanSign)
                RFC_3987.IRI.serialize(iri, into: &buffer)
                buffer.append(ASCII.Code.greaterThanSign)
            }
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

        // List-Archive
        if let archive = value.archive {
            buffer.append(contentsOf: "List-Archive".utf8.map { ASCII.Code(unchecked: Byte($0)) })
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            buffer.append(ASCII.Code.lessThanSign)
            RFC_3987.IRI.serialize(archive, into: &buffer)
            buffer.append(ASCII.Code.greaterThanSign)
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }
    }

    /// Explicit `Binary.Serializable` witness disambiguating the two
    /// constraint-incomparable `serialize(_:into:)` defaults.
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        serializeBytes(value, into: &buffer)
    }

    /// Byte-domain serialization body. Composes the re-cut `RFC_3987.IRI` and
    /// `RFC_2369.List.Post` **Binary** witnesses (the universal verb resolves to the
    /// `Byte` witness here — no byte-detour, no property-reach); the conformer's own
    /// field-name labels and delimiters are leaf-emitted on the byte substrate.
    private static func serializeBytes<Buffer: RangeReplaceableCollection>(
        _ header: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        // List-Help
        if let help = header.help {
            buffer.append(contentsOf: Array<Byte>("List-Help".utf8))
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            buffer.append(ASCII.Code.lessThanSign)
            RFC_3987.IRI.serialize(help, into: &buffer)
            buffer.append(ASCII.Code.greaterThanSign)
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

        // List-Unsubscribe
        if let unsubscribe = header.unsubscribe, !unsubscribe.isEmpty {
            buffer.append(contentsOf: Array<Byte>("List-Unsubscribe".utf8))
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            for (index, iri) in unsubscribe.enumerated() {
                if index > 0 {
                    buffer.append(ASCII.Code.comma)
                    buffer.append(ASCII.Code.space)
                }
                buffer.append(ASCII.Code.lessThanSign)
                RFC_3987.IRI.serialize(iri, into: &buffer)
                buffer.append(ASCII.Code.greaterThanSign)
            }
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

        // List-Subscribe
        if let subscribe = header.subscribe, !subscribe.isEmpty {
            buffer.append(contentsOf: Array<Byte>("List-Subscribe".utf8))
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            for (index, iri) in subscribe.enumerated() {
                if index > 0 {
                    buffer.append(ASCII.Code.comma)
                    buffer.append(ASCII.Code.space)
                }
                buffer.append(ASCII.Code.lessThanSign)
                RFC_3987.IRI.serialize(iri, into: &buffer)
                buffer.append(ASCII.Code.greaterThanSign)
            }
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

        // List-Post
        if let post = header.post {
            buffer.append(contentsOf: Array<Byte>("List-Post".utf8))
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            RFC_2369.List.Post.serialize(post, into: &buffer)
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

        // List-Owner
        if let owner = header.owner, !owner.isEmpty {
            buffer.append(contentsOf: Array<Byte>("List-Owner".utf8))
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            for (index, iri) in owner.enumerated() {
                if index > 0 {
                    buffer.append(ASCII.Code.comma)
                    buffer.append(ASCII.Code.space)
                }
                buffer.append(ASCII.Code.lessThanSign)
                RFC_3987.IRI.serialize(iri, into: &buffer)
                buffer.append(ASCII.Code.greaterThanSign)
            }
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

        // List-Archive
        if let archive = header.archive {
            buffer.append(contentsOf: Array<Byte>("List-Archive".utf8))
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            buffer.append(ASCII.Code.lessThanSign)
            RFC_3987.IRI.serialize(archive, into: &buffer)
            buffer.append(ASCII.Code.greaterThanSign)
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }
    }
}

// MARK: - Parseable

extension RFC_2369.List.Header: ASCII.Parseable {
    /// Creates a list header block by validating `string`'s UTF-8 bytes.
    public init(_ string: some StringProtocol) throws(Error) {
        try self.init(ascii: [Byte](string.utf8))
    }

    /// Parses list headers from ASCII bytes (AUTHORITATIVE IMPLEMENTATION)
    ///
    /// ## RFC 2369 Section 2
    ///
    /// > The contents of the list header fields mostly consist of angle-bracket
    /// > ('<', '>') enclosed URLs, with internal whitespace being ignored.
    ///
    /// ## Category Theory
    ///
    /// Parsing transformation:
    /// - **Domain**: [UInt8] (ASCII bytes)
    /// - **Codomain**: RFC_2369.List.Header (structured data)
    ///
    /// - Parameter bytes: The header as ASCII bytes
    /// - Throws: `Error` if parsing fails
    public init<Bytes: Collection>(ascii bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        let byteArray = Array(bytes)

        // Helper to trim whitespace
        func trimWhitespace(_ arr: [Byte]) -> [Byte] {
            var result = arr
            while let firstByte = result.first {
                let code = try? ASCII.Code(firstByte)
                guard code == ASCII.Code.space || code == ASCII.Code.htab else { break }
                result.removeFirst()
            }
            while let lastByte = result.last {
                let code = try? ASCII.Code(lastByte)
                guard code == ASCII.Code.space || code == ASCII.Code.htab else { break }
                result.removeLast()
            }
            return result
        }

        // Helper to extract IRIs from angle-bracketed, comma-separated list
        func parseIRIs(_ value: [Byte]) -> [RFC_3987.IRI] {
            var iris: [RFC_3987.IRI] = []
            var current: [Byte] = []
            var inBrackets = false

            for byte in value {
                let code = try? ASCII.Code(byte)
                if code == ASCII.Code.lessThanSign {
                    inBrackets = true
                    current = []
                } else if code == ASCII.Code.greaterThanSign {
                    inBrackets = false
                    if !current.isEmpty {
                        let iriString = String(decoding: current, as: UTF8.self)
                        if let iri = try? RFC_3987.IRI(iriString) {
                            iris.append(iri)
                        }
                    }
                } else if inBrackets {
                    current.append(byte)
                }
            }
            return iris
        }

        // Split into lines
        var lines: [[Byte]] = []
        var currentLine: [Byte] = []
        for byte in byteArray {
            let code = try? ASCII.Code(byte)
            if code == ASCII.Code.cr || code == ASCII.Code.lf {
                if !currentLine.isEmpty {
                    lines.append(currentLine)
                    currentLine = []
                }
            } else {
                currentLine.append(byte)
            }
        }
        if !currentLine.isEmpty {
            lines.append(currentLine)
        }

        var help: RFC_3987.IRI?
        var unsubscribe: [RFC_3987.IRI]?
        var subscribe: [RFC_3987.IRI]?
        var post: RFC_2369.List.Post?
        var owner: [RFC_3987.IRI]?
        var archive: RFC_3987.IRI?

        for line in lines {
            guard let colonIndex = line.firstIndex(where: { (try? ASCII.Code($0)) == ASCII.Code.colon }) else { continue }

            let fieldNameBytes = trimWhitespace(Array(line[..<colonIndex]))
            let fieldValueBytes = trimWhitespace(Array(line[(colonIndex + 1)...]))

            let fieldName = String(decoding: fieldNameBytes, as: UTF8.self).lowercased()

            switch fieldName {
            case "list-help":
                let iris = parseIRIs(fieldValueBytes)
                help = iris.first

            case "list-unsubscribe":
                let iris = parseIRIs(fieldValueBytes)
                unsubscribe = iris.isEmpty ? nil : iris

            case "list-subscribe":
                let iris = parseIRIs(fieldValueBytes)
                subscribe = iris.isEmpty ? nil : iris

            case "list-post":
                // Check for "NO" (case-insensitive)
                let trimmed = trimWhitespace(fieldValueBytes)
                let valueString = String(decoding: trimmed, as: UTF8.self).uppercased()
                if valueString == "NO" {
                    post = .noPosting
                } else {
                    let iris = parseIRIs(fieldValueBytes)
                    post = iris.isEmpty ? nil : .uris(iris)
                }

            case "list-owner":
                let iris = parseIRIs(fieldValueBytes)
                owner = iris.isEmpty ? nil : iris

            case "list-archive":
                let iris = parseIRIs(fieldValueBytes)
                archive = iris.first

            default:
                break
            }
        }

        self.init(
            __unchecked: (),
            help: help,
            unsubscribe: unsubscribe,
            subscribe: subscribe,
            post: post,
            owner: owner,
            archive: archive
        )
    }
}

// MARK: - Protocol Conformances

extension RFC_2369.List.Header: Swift.RawRepresentable {
    public typealias RawValue = String

    /// The header block's ASCII serialization as a `String` (computed; the
    /// rawValue is derived from serialization, not stored).
    public var rawValue: String {
        String(decoding: serialized.underlying, as: UTF8.self)
    }

    public init?(rawValue: String) { try? self.init(rawValue) }
}

extension RFC_2369.List.Header: CustomStringConvertible {
    public var description: String {
        String(self)
    }
}

// MARK: - Email Header Rendering

extension [String: String] {
    /// Creates email header dictionary from RFC 2369 list headers
    ///
    /// - Parameter listHeader: The RFC 2369 list header to render
    public init(listHeader: RFC_2369.List.Header) {
        var headers: [String: String] = [:]

        if let help = listHeader.help {
            headers["List-Help"] = "<\(help.value)>"
        }

        if let unsubscribe = listHeader.unsubscribe, !unsubscribe.isEmpty {
            headers["List-Unsubscribe"] =
                unsubscribe
                .map { "<\($0.value)>" }
                .joined(separator: ", ")
        }

        if let subscribe = listHeader.subscribe, !subscribe.isEmpty {
            headers["List-Subscribe"] =
                subscribe
                .map { "<\($0.value)>" }
                .joined(separator: ", ")
        }

        if let post = listHeader.post {
            headers["List-Post"] = post.description
        }

        if let owner = listHeader.owner, !owner.isEmpty {
            headers["List-Owner"] =
                owner
                .map { "<\($0.value)>" }
                .joined(separator: ", ")
        }

        if let archive = listHeader.archive {
            headers["List-Archive"] = "<\(archive.value)>"
        }

        self = headers
    }
}
