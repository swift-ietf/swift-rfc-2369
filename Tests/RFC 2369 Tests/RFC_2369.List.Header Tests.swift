import RFC_3987
import Testing

@testable import RFC_2369

extension RFC_2369.List.Header {
    @Suite
    struct `Edge Case` {
        @Test
        func `List-Post NO with RFC 822 comment survives Header parsing per RFC 2369 section 3.4`()
            throws
        {
            let header = try RFC_2369.List.Header(
                "List-Post: NO (posting not allowed on this list)\r\n"
            )
            #expect(header.post == .noPosting)
        }

        @Test
        func
            `List-Post moderator URI with RFC 822 comment survives Header parsing per RFC 2369 section 3.4`()
            throws
        {
            let header = try RFC_2369.List.Header(
                "List-Post: <mailto:moderator@host.com> (Postings are Moderated)\r\n"
            )
            #expect(header.post == .uris([try RFC_3987.IRI("mailto:moderator@host.com")]))
        }

        @Test
        func `Folded List-Unsubscribe continuation line is unfolded per RFC 822 section 3.1.1`()
            throws
        {
            let header = try RFC_2369.List.Header(
                "List-Unsubscribe: <mailto:unsubscribe-a@example.com>,\r\n <mailto:unsubscribe-b@example.com>\r\n"
            )
            #expect(header.unsubscribe?.count == 2)
            #expect(
                header.unsubscribe?.last == (try RFC_3987.IRI("mailto:unsubscribe-b@example.com"))
            )
        }

        @Test
        func `Folded RFC 2369 section 2 List-Help example parses both URIs`() throws {
            let header = try RFC_2369.List.Header(
                "List-Help: <ftp://ftp.host.com/list.txt> (FTP),\r\n\t<mailto:list@host.com?subject=help>\r\n"
            )
            #expect(header.help == (try RFC_3987.IRI("ftp://ftp.host.com/list.txt")))
        }

        @Test
        func `Field value entirely on a continuation line is unfolded`() throws {
            let header = try RFC_2369.List.Header(
                "List-Archive:\r\n <https://example.com/archive>\r\n"
            )
            #expect(header.archive == (try RFC_3987.IRI("https://example.com/archive")))
        }

        @Test
        func `Whitespace-led line after a blank line does not fold into the previous field`() throws
        {
            let header = try RFC_2369.List.Header(
                "List-Help: <https://example.com/help>\r\n\r\n <https://example.com/other>\r\n"
            )
            #expect(header.help == (try RFC_3987.IRI("https://example.com/help")))
        }
    }
}
