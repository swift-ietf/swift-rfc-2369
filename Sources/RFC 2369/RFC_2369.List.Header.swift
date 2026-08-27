public import ASCII_Serializer
public import Binary_Serializable
public import Parseable_ASCII

extension RFC_2369.List {

    public struct Header: Hashable, Sendable, Codable {

        public let help: RFC_3987.IRI?

        public let unsubscribe: [RFC_3987.IRI]?

        public let subscribe: [RFC_3987.IRI]?

        public let post: Post?

        public let owner: [RFC_3987.IRI]?

        public let archive: RFC_3987.IRI?

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

extension RFC_2369.List.Header: ASCII.Serializable, Binary.Serializable {

    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {

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

        if let unsubscribe = value.unsubscribe, !unsubscribe.isEmpty {
            buffer.append(
                contentsOf: "List-Unsubscribe".utf8.map { ASCII.Code(unchecked: Byte($0)) }
            )
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

        if let post = value.post {
            buffer.append(contentsOf: "List-Post".utf8.map { ASCII.Code(unchecked: Byte($0)) })
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            RFC_2369.List.Post.serialize(post, into: &buffer)
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

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

    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        serializeBytes(value, into: &buffer)
    }

    private static func serializeBytes<Buffer: RangeReplaceableCollection>(
        _ header: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {

        if let help = header.help {
            buffer.append(contentsOf: [Byte]("List-Help".utf8))
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            buffer.append(ASCII.Code.lessThanSign)
            RFC_3987.IRI.serialize(help, into: &buffer)
            buffer.append(ASCII.Code.greaterThanSign)
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

        if let unsubscribe = header.unsubscribe, !unsubscribe.isEmpty {
            buffer.append(contentsOf: [Byte]("List-Unsubscribe".utf8))
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

        if let subscribe = header.subscribe, !subscribe.isEmpty {
            buffer.append(contentsOf: [Byte]("List-Subscribe".utf8))
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

        if let post = header.post {
            buffer.append(contentsOf: [Byte]("List-Post".utf8))
            buffer.append(ASCII.Code.colon)
            buffer.append(ASCII.Code.space)
            RFC_2369.List.Post.serialize(post, into: &buffer)
            buffer.append(ASCII.Code.cr)
            buffer.append(ASCII.Code.lf)
        }

        if let owner = header.owner, !owner.isEmpty {
            buffer.append(contentsOf: [Byte]("List-Owner".utf8))
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

        if let archive = header.archive {
            buffer.append(contentsOf: [Byte]("List-Archive".utf8))
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

extension RFC_2369.List.Header: ASCII.Parseable {

    public init(_ string: some StringProtocol) throws(Error) {
        try self.init(ascii: [Byte](string.utf8))
    }

    public init<Bytes: Swift.Collection>(ascii bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        let byteArray = Array(bytes)

        func trimWhitespace(_ arr: [Byte]) -> [Byte] {
            var result = arr
            while let firstByte = result.first {
                let code: ASCII.Code?
                do throws(ASCII.Code.Error) {
                    code = try ASCII.Code(firstByte)
                } catch {
                    code = nil
                }
                guard code == ASCII.Code.space || code == ASCII.Code.htab else { break }
                result.removeFirst()
            }
            while let lastByte = result.last {
                let code: ASCII.Code?
                do throws(ASCII.Code.Error) {
                    code = try ASCII.Code(lastByte)
                } catch {
                    code = nil
                }
                guard code == ASCII.Code.space || code == ASCII.Code.htab else { break }
                result.removeLast()
            }
            return result
        }

        func parseIRIs(_ value: [Byte]) -> [RFC_3987.IRI] {
            var iris: [RFC_3987.IRI] = []
            var current: [Byte] = []
            var inBrackets = false

            for byte in value {
                let code: ASCII.Code?
                do throws(ASCII.Code.Error) {
                    code = try ASCII.Code(byte)
                } catch {
                    code = nil
                }
                if code == ASCII.Code.lessThanSign {
                    inBrackets = true
                    current = []
                } else if code == ASCII.Code.greaterThanSign {
                    inBrackets = false
                    if !current.isEmpty {
                        let iriString = String(decoding: current, as: UTF8.self)
                        do throws(RFC_3987.IRI.Error) {
                            let iri = try RFC_3987.IRI(iriString)
                            iris.append(iri)
                        } catch {

                        }
                    }
                } else if inBrackets {
                    current.append(byte)
                }
            }
            return iris
        }

        var physicalLines: [[Byte]] = []
        var currentLine: [Byte] = []
        var previousWasCR = false
        for byte in byteArray {
            let code: ASCII.Code?
            do throws(ASCII.Code.Error) {
                code = try ASCII.Code(byte)
            } catch {
                code = nil
            }
            if code == ASCII.Code.lf {
                if previousWasCR {

                    previousWasCR = false
                    continue
                }
                physicalLines.append(currentLine)
                currentLine = []
            } else if code == ASCII.Code.cr {
                physicalLines.append(currentLine)
                currentLine = []
                previousWasCR = true
            } else {
                previousWasCR = false
                currentLine.append(byte)
            }
        }
        if !currentLine.isEmpty {
            physicalLines.append(currentLine)
        }

        var lines: [[Byte]] = []
        var previousPhysicalLineWasNonEmpty = false
        for line in physicalLines {
            let startsWithFoldingWhitespace: Bool =
                line.first.map { byte in
                    let code: ASCII.Code?
                    do throws(ASCII.Code.Error) {
                        code = try ASCII.Code(byte)
                    } catch {
                        code = nil
                    }
                    return code == ASCII.Code.space || code == ASCII.Code.htab
                } ?? false
            if startsWithFoldingWhitespace, previousPhysicalLineWasNonEmpty, !lines.isEmpty {
                lines[lines.count - 1].append(contentsOf: line)
            } else if !line.isEmpty {
                lines.append(line)
            }
            previousPhysicalLineWasNonEmpty = !line.isEmpty
        }

        var help: RFC_3987.IRI?
        var unsubscribe: [RFC_3987.IRI]?
        var subscribe: [RFC_3987.IRI]?
        var post: RFC_2369.List.Post?
        var owner: [RFC_3987.IRI]?
        var archive: RFC_3987.IRI?

        for line in lines {
            guard
                let colonIndex = line.firstIndex(where: { byte in
                    let code: ASCII.Code?
                    do throws(ASCII.Code.Error) {
                        code = try ASCII.Code(byte)
                    } catch {
                        code = nil
                    }
                    return code == ASCII.Code.colon
                })
            else { continue }

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

                do throws(RFC_2369.List.Post.Error) {
                    post = try RFC_2369.List.Post(ascii: fieldValueBytes)
                } catch {
                    post = nil
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

extension RFC_2369.List.Header: Swift.RawRepresentable {
    public typealias RawValue = String

    public var rawValue: String {
        String(decoding: serialized.underlying, as: UTF8.self)
    }

    public init?(rawValue: String) {
        do throws(Error) {
            try self.init(rawValue)
        } catch {
            return nil
        }
    }
}

extension RFC_2369.List.Header: CustomStringConvertible {
    public var description: String {
        String(self)
    }
}

extension [String: String] {

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
