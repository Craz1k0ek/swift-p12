import SwiftASN1

extension DER {
    /// Parses an optional explicitly tagged element.
    ///
    /// - parameters:
    ///     - nodes: The ``ASN1NodeCollection/Iterator`` to parse this element out of.
    ///     - identifier: The expected ``ASN1Identifier`` for the explicitly tagged element.
    ///     - builder: A closure that will be called with the node for the element, if the element is present.
    ///
    /// - returns: The result of `builder` if the element was present, or `nil` if it was not.
    @inlinable
    public static func optionalExplicitlyTagged<T>(
        _ nodes: inout ASN1NodeCollection.Iterator,
        identifier: ASN1Identifier,
        _ builder: (ASN1Node) throws -> T
    ) throws -> T? {
        try optionalExplicitlyTagged(&nodes, tagNumber: identifier.tagNumber, tagClass: identifier.tagClass, builder)
    }
}
