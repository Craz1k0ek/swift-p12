import Foundation
import SwiftASN1
import Testing
@testable import SwiftP12

@Suite("ContentInfo Serialization Tests")
struct ContentInfoSerializationTests {
    @Test("ContentInfo data contentType")
    func contentInfoDataContentType() {
        let info = ContentInfo(data: [0x01, 0x02, 0x03])
        #expect(info.contentType == .data)
    }

    @Test("Serialize data ContentInfo")
    func dataContentInfo() throws {
        let info = ContentInfo(data: [0x01, 0x02, 0x03])

        var serializer = DER.Serializer()
        try serializer.serialize(info)

        let expected: [UInt8] = [
            0x30, 0x12,
                0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x07, 0x01,
                0xa0, 0x05,
                    0x04, 0x03, 0x01, 0x02, 0x03
        ]
        #expect(serializer.serializedBytes == expected)
    }

    @Test("Serialize optional data ContentInfo")
    func optionalDataContentInfo() throws {
        let info = ContentInfo(contentType: .data)

        var serializer = DER.Serializer()
        try serializer.serialize(info)

        let expected: [UInt8] = [
            0x30, 0x0b,
                0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x07, 0x01
        ]
        #expect(serializer.serializedBytes == expected)
    }
}

@Suite("ContentInfo Parsing Tests")
struct ContentInfoParsingTests {
    @Test("Parse data ContentInfo")
    func parseDataContentInfo() throws {
        let data: [UInt8] = [
            0x30, 0x12,
                0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x07, 0x01,
                0xa0, 0x05,
                    0x04, 0x03, 0x01, 0x02, 0x03
        ]

        let info = try ContentInfo(derEncoded: data)

        #expect(info.contentType == .data)
        #expect(info.content == .data(Data([0x01, 0x02, 0x03])))
    }

    @Test("Parse optional data ContentInfo")
    func parseOptionalDataContentInfo() throws {
        let data: [UInt8] = [
            0x30, 0x0b,
                0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x07, 0x01
        ]

        let info = try ContentInfo(derEncoded: data)

        #expect(info.contentType == .data)
        #expect(info.content == nil)
    }

    @Test("Parse too many child nodes")
    func parseTooManyChildNodes() throws {
        let data: [UInt8] = [
            0x30, 0x16,
                0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x07, 0x01,
                0xa0, 0x05,
                    0x04, 0x03, 0x01, 0x02, 0x03,
                0xa1, 0x02,
                    0x05, 0x00
        ]
        let error = #expect(throws: ASN1Error.self) {
            try ContentInfo(derEncoded: data)
        }
        #expect(error?.code == .invalidASN1Object)
    }

    @Test("Parse unsupported ContentInfo contentType")
    func parseUnsupportedContentInfoContentType() throws {
        let data: [UInt8] = [
            0x30, 0x0a,
                0x06, 0x04, 0x2a, 0x03, 0x04, 0x05,
                0xa0, 0x02,
                    0x05, 0x00
        ]
        let error = #expect(throws: ASN1Error.self) {
            try ContentInfo(derEncoded: data)
        }
        #expect(error?.code == .invalidASN1Object)
    }
}

@Suite("ContentInfo Content Tests")
struct ContentInfoContentTests {
    @Test("Data serialization")
    func dataSerialization() throws {
        let content = ContentInfo.Content.data(Data([0x01, 0x02, 0x03]))

        var serializer = DER.Serializer()
        try serializer.serialize(content)

        let expected: [UInt8] = [
            0x04, 0x03, 0x01, 0x02, 0x03
        ]
        #expect(serializer.serializedBytes == expected)
    }
}
