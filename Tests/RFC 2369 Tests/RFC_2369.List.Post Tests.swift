import RFC_3987
import Testing

@testable import RFC_2369

extension RFC_2369.List.Post {
    @Suite
    struct `Edge Case` {
        @Test
        func `NO with trailing RFC 822 comment parses as noPosting per RFC 2369 section 3.4`()
            throws
        {
            let post = try RFC_2369.List.Post("NO (posting not allowed on this list)")
            #expect(post == .noPosting)
        }

        @Test
        func `URI with trailing RFC 822 comment parses per RFC 2369 section 3.4`() throws {
            let post = try RFC_2369.List.Post(
                "<mailto:moderator@host.com> (Postings are Moderated)"
            )
            #expect(post == .uris([try RFC_3987.IRI("mailto:moderator@host.com")]))
        }

        @Test
        func `Bare NO still parses as noPosting`() throws {
            let post = try RFC_2369.List.Post("NO")
            #expect(post == .noPosting)
        }

        @Test
        func `Lowercase no parses as noPosting matching Header entry point case-insensitivity`()
            throws
        {
            let post = try RFC_2369.List.Post("no")
            #expect(post == .noPosting)
        }

        @Test
        func `Parenthesis inside angle brackets is preserved as IRI content`() throws {
            let post = try RFC_2369.List.Post("<mailto:list@host.com?subject=a(b)>")
            #expect(post == .uris([try RFC_3987.IRI("mailto:list@host.com?subject=a(b)")]))
        }
    }
}
