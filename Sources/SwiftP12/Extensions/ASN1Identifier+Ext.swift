import SwiftASN1

extension ASN1Identifier {
    /// Create an `ASN1Identifier` with a context-specific tag number.
    /// - Parameter tagNumber: The tag number for the identifier.
    /// - Returns: The configured `ASN1Identifier`.
    @inlinable
    public static func contextSpecific(_ tagNumber: UInt) -> ASN1Identifier {
        return ASN1Identifier(tagWithNumber: tagNumber, tagClass: .contextSpecific)
    }
}
