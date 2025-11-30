import SwiftASN1
import Testing
@testable import SwiftP12

@Suite("DER Tests")
struct DERTests {
    @Test("Deserialize explicitly tagged node")
    func explicitlyTaggedNode() throws {
        let encoded: [UInt8] = [
            0x30, 0x07,
                0xa0, 0x05,
                    0x04, 0x03, 0x01, 0x02, 0x03
        ]

        let node = try DER.parse(encoded)
        let data = try DER.sequence(node, identifier: .sequence) { nodes in
            try DER.optionalExplicitlyTagged(&nodes, identifier: .contextSpecific(0)) { taggedNode in
                try ASN1OctetString(derEncoded: taggedNode).bytes
            }
        }

        #expect(data == [0x01, 0x02, 0x03])
    }

    @Test("Deserialize optional explicitly tagged node")
    func optionalExplicitlyTaggedNode() throws {
        let encoded: [UInt8] = [
            0x30, 0x00
        ]

        let node = try DER.parse(encoded)
        let data = try DER.sequence(node, identifier: .sequence) { nodes in
            try DER.optionalExplicitlyTagged(&nodes, identifier: .contextSpecific(0)) { taggedNode in
                try ASN1OctetString(derEncoded: taggedNode).bytes
            }
        }

        #expect(data == nil)
    }
}
