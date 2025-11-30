import SwiftASN1
import Testing
@testable import SwiftP12

@Suite("ASN1Identifier Tests")
struct ASN1IdentifierTests {
    @Test("Context-specific identifier with common tag number", arguments: [
        0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
        10, 11, 12, 13, 14, 15, 16, 17,
        18, 19, 20, 21, 22, 23, 24, 25,
        26, 27, 28, 29, 30
    ])
    func contextSpecificIdentifierWithCommonTagNumber(tagNumber: UInt) {
        let identifier = ASN1Identifier.contextSpecific(tagNumber)

        #expect(identifier.tagClass == .contextSpecific)
    }
}
