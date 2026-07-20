import RFC_3987
import Testing

@testable import RFC_2369

extension RFC_2369.List.Header {
    @Suite
    struct `Edge Case` {
        @Test
        func `List-Post NO with RFC 822 comment survives Header parsing per RFC 2369 section 3.4`() throws {
            let header = try RFC_2369.List.Header(
                "List-Post: NO (posting not allowed on this list)\r\n"
            )
            #expect(header.post == .noPosting)
        }

        @Test
        func `List-Post moderator URI with RFC 822 comment survives Header parsing per RFC 2369 section 3.4`() throws {
            let header = try RFC_2369.List.Header(
                "List-Post: <mailto:moderator@host.com> (Postings are Moderated)\r\n"
            )
            #expect(header.post == .uris([try RFC_3987.IRI("mailto:moderator@host.com")]))
        }
    }
}
