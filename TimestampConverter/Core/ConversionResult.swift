//
//  ConversionResult.swift
//  Wadats (What's that timestamp?)
//

import Foundation

/// Represents a single conversion result
struct ConversionResult: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let value: String
    let description: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: ConversionResult, rhs: ConversionResult) -> Bool {
        lhs.id == rhs.id
    }
}

/// Type of detected input
enum DetectedInputType {
    case unixSeconds
    case unixMilliseconds
    case unixMicroseconds
    case unixNanoseconds
    case iso8601
    case humanReadable
    case unknown
}