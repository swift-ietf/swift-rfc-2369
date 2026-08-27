public import ASCII_Serializer
public import Binary_Serializable
public import Parseable_ASCII

extension RFC_2369.List {

    public enum Post: Hashable, Sendable {

        case uris([RFC_3987.IRI])

        case noPosting
    }
}

extension RFC_2369.List.Post: ASCII.Serializable, Binary.Serializable {

    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == ASCII.Code {
        switch value {
        case .noPosting:
            buffer.append(ASCII.Code.N)
            buffer.append(ASCII.Code.O)

        case .uris(let iris):
            for (index, iri) in iris.enumerated() {
                if index > 0 {
                    buffer.append(ASCII.Code.comma)
                    buffer.append(ASCII.Code.space)
                }
                buffer.append(ASCII.Code.lessThanSign)
                RFC_3987.IRI.serialize(iri, into: &buffer)
                buffer.append(ASCII.Code.greaterThanSign)
            }
        }
    }

    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ value: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        serializeBytes(value, into: &buffer)
    }

    private static func serializeBytes<Buffer: RangeReplaceableCollection>(
        _ post: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        switch post {
        case .noPosting:
            buffer.append(ASCII.Code.N)
            buffer.append(ASCII.Code.O)

        case .uris(let iris):
            for (index, iri) in iris.enumerated() {
                if index > 0 {
                    buffer.append(ASCII.Code.comma)
                    buffer.append(ASCII.Code.space)
                }
                buffer.append(ASCII.Code.lessThanSign)
                RFC_3987.IRI.serialize(iri, into: &buffer)
                buffer.append(ASCII.Code.greaterThanSign)
            }
        }
    }
}

extension RFC_2369.List.Post: ASCII.Parseable {

    public init(_ string: some StringProtocol) throws(Error) {
        try self.init(ascii: [Byte](string.utf8))
    }

    public init<Bytes: Swift.Collection>(ascii bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {

        var byteArray: [Byte] = []
        var commentDepth = 0
        var inAngleBrackets = false
        for byte in bytes {
            let code: ASCII.Code?
            do throws(ASCII.Code.Error) {
                code = try ASCII.Code(byte)
            } catch {
                code = nil
            }
            if !inAngleBrackets, code == ASCII.Code.leftParenthesis {
                commentDepth += 1
                continue
            }
            if !inAngleBrackets, code == ASCII.Code.rightParenthesis, commentDepth > 0 {
                commentDepth -= 1
                continue
            }
            guard commentDepth == 0 else { continue }
            if code == ASCII.Code.lessThanSign {
                inAngleBrackets = true
            } else if code == ASCII.Code.greaterThanSign {
                inAngleBrackets = false
            }
            byteArray.append(byte)
        }

        while let firstByte = byteArray.first {
            let code: ASCII.Code?
            do throws(ASCII.Code.Error) {
                code = try ASCII.Code(firstByte)
            } catch {
                code = nil
            }
            guard code == ASCII.Code.space || code == ASCII.Code.htab else { break }
            byteArray.removeFirst()
        }
        while let lastByte = byteArray.last {
            let code: ASCII.Code?
            do throws(ASCII.Code.Error) {
                code = try ASCII.Code(lastByte)
            } catch {
                code = nil
            }
            guard code == ASCII.Code.space || code == ASCII.Code.htab else { break }
            byteArray.removeLast()
        }

        guard !byteArray.isEmpty else { throw Error.empty }

        if byteArray.count == 2 {
            let first: ASCII.Code?
            do throws(ASCII.Code.Error) {
                first = try ASCII.Code(byteArray[0])
            } catch {
                first = nil
            }
            let second: ASCII.Code?
            do throws(ASCII.Code.Error) {
                second = try ASCII.Code(byteArray[1])
            } catch {
                second = nil
            }
            if let first, let second,
                first == ASCII.Code.N || first == ASCII.Code.n,
                second == ASCII.Code.O || second == ASCII.Code.o
            {
                self = .noPosting
                return
            }
        }

        var iris: [RFC_3987.IRI] = []
        var current: [Byte] = []
        var inBrackets = false

        for byte in byteArray {
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
                        throw Error.invalidIRI(iriString)
                    }
                }
            } else if inBrackets {
                current.append(byte)
            }
        }

        guard !iris.isEmpty else {
            throw Error.noURIs(String(decoding: byteArray, as: UTF8.self))
        }

        self = .uris(iris)
    }
}

extension RFC_2369.List.Post: Swift.RawRepresentable {
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

extension RFC_2369.List.Post: CustomStringConvertible {

    public var description: String {
        String(decoding: serialized.underlying, as: UTF8.self)
    }
}

extension RFC_2369.List.Post: Codable {
    enum CodingKeys: String, CodingKey {
        case type
        case uris
    }

    enum PostType: String, Codable {
        case uris
        case noPosting
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(PostType.self, forKey: .type)

        switch type {
        case .uris:
            let uris = try container.decode([RFC_3987.IRI].self, forKey: .uris)
            self = .uris(uris)

        case .noPosting:
            self = .noPosting
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .uris(let iris):
            try container.encode(PostType.uris, forKey: .type)
            try container.encode(iris, forKey: .uris)

        case .noPosting:
            try container.encode(PostType.noPosting, forKey: .type)
        }
    }
}
