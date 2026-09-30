import RFC_2369
import RFC_3987
import Testing

@Suite
struct `List-Post error boundaries` {
    @Test
    func `an empty value is refused`() {
        #expect(throws: RFC_2369.List.Post.Error.self) { try RFC_2369.List.Post("") }
    }

    @Test(arguments: ["mailto:list@host.com", "(only a comment)", "   "])
    func `a value without an angle-bracketed URI or NO is refused`(_ value: String) {
        #expect(throws: RFC_2369.List.Post.Error.self) { try RFC_2369.List.Post(value) }
    }

    @Test
    func `nested comments are skipped before the URI`() throws {
        let post = try RFC_2369.List.Post("((nested) comment) <mailto:list@host.com>")
        #expect(post == .uris([try RFC_3987.IRI("mailto:list@host.com")]))
    }

    @Test
    func `several URIs keep their order`() throws {
        let post = try RFC_2369.List.Post("<mailto:a@host.com>, <https://host.com/post>")
        #expect(post == .uris([try RFC_3987.IRI("mailto:a@host.com"), try RFC_3987.IRI("https://host.com/post")]))
    }
}
