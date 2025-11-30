import Foundation
import SwiftASN1

/// A PKCS #7 / CMS `ContentInfo` container.
///
/// This type models the `ContentInfo` structure as defined in PKCS #7 and CMS.
/// It carries a `contentType` object identifier and an optional, type-dependent
/// encapsulated `content`.
///
/// ### ASN.1 definition
/// ```
/// ContentInfo ::= SEQUENCE {
///   contentType ContentType,
///   content [0] EXPLICIT ANY DEFINED BY contentType OPTIONAL
/// }
/// ```
public struct ContentInfo {
    /// The object identifier that defines the type of the encapsulated content.
    public let contentType: ASN1ObjectIdentifier
    /// The encapsulated content, if present.
    public let content: Content?

    /// Creates a new `ContentInfo` with the given content type and content.
    /// - Parameters:
    ///   - contentType: The object identifier describing the content type.
    ///   - content: The encapsulated content, or `nil` if no content is present.
    public init(contentType: ASN1ObjectIdentifier, content: Content? = nil) {
        self.contentType = contentType
        self.content = content
    }

    /// Creates a `ContentInfo` carrying raw data.
    /// - Parameter data: The raw content bytes.
    public init(data: Data) {
        self.init(
            contentType: .data,
            content: .data(data)
        )
    }

    /// Creates a `ContentInfo` carrying raw data.
    /// - Parameter data: The raw content bytes.
    public init(data: [UInt8]) {
        self.init(data: Data(data))
    }
}

extension ContentInfo: Hashable {}

extension ContentInfo: Sendable {}

extension ContentInfo: DERImplicitlyTaggable {
    public static let defaultIdentifier = ASN1Identifier.sequence

    public init(derEncoded: SwiftASN1.ASN1Node, withIdentifier identifier: SwiftASN1.ASN1Identifier) throws {
        self = try DER.sequence(derEncoded, identifier: identifier) { nodes in
            let contentType = try ASN1ObjectIdentifier(derEncoded: &nodes)
            let content = try Self.decodeContent(ofType: contentType, from: &nodes)

            guard nodes.next() == nil else {
                throw ASN1Error.invalidASN1Object(reason: "Invalid number of child nodes for ContentInfo")
            }

            return ContentInfo(contentType: contentType, content: content)
        }
    }

    public func serialize(
        into coder: inout SwiftASN1.DER.Serializer,
        withIdentifier identifier: SwiftASN1.ASN1Identifier
    ) throws {
        try coder.appendConstructedNode(identifier: identifier) { implicit in
            try implicit.serialize(contentType)

            if let content {
                try implicit.serialize(content, explicitlyTaggedWithIdentifier: .contextSpecific(0))
            }
        }
    }

    /// Decodes the `content` field of the given `contentType`.
    /// - Parameters:
    ///   - contentType: The object identifier describing the content type.
    ///   - nodes: The iterator to read the content from.
    /// - Returns: The decoded content or `nil` if the optional content field is absent.
    private static func decodeContent(
        ofType contentType: ASN1ObjectIdentifier,
        from nodes: inout ASN1NodeCollection.Iterator
    ) throws -> Content? {
        try DER.optionalExplicitlyTagged(&nodes, identifier: .contextSpecific(0)) { taggedNode in
            switch contentType {
            case .data:
                return try ContentInfo.decodeData(from: taggedNode)
            default:
                throw ASN1Error.invalidASN1Object(reason: "Unsupported ContentInfo contentType \(contentType)")
            }
        }
    }

    /// Decodes the raw `data` content from the given ASN.1 node.
    /// - Parameter node: The ASN.1 node to decode.
    /// - Returns: The decoded `data` content.
    private static func decodeData(from node: ASN1Node) throws -> Content {
        let octetString = try ASN1OctetString(derEncoded: node)
        return .data(Data(octetString.bytes))
    }
}

// MARK: -

extension ContentInfo {
    /// The encapsulated content carried by a ``ContentInfo`` structure.
    ///
    /// This corresponds to the `content` field of PKCS #7 / CMS `ContentInfo`,
    /// where the encoding and semantics depend on the associated
    /// ``ContentInfo/contentType``.
    public enum Content: Hashable, Sendable, DERSerializable {
        /// Raw data content encoded as an octet string.
        case data(Data)

        public func serialize(into coder: inout DER.Serializer) throws {
            switch self {
            case let .data(data):
                try coder.serialize(ASN1OctetString(contentBytes: ArraySlice(data)))
            }
        }
    }
}
