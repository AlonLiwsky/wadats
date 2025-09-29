//
//  TimestampConverter.swift
//  TimestampConverter
//

import Foundation

/// Core conversion logic for timestamps
class TimestampConverter {

    static let shared = TimestampConverter()

    private init() {}

    // MARK: - Date Formatters

    private lazy var iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private lazy var iso8601FormatterWithoutFractional: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    private lazy var humanReadableFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        formatter.locale = Locale.current
        return formatter
    }()

    private lazy var shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter
    }()

    private lazy var relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    // MARK: - Public API

    /// Convert input text to various timestamp formats
    func convert(_ input: String) -> [ConversionResult] {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        let detectedType = detectInputType(trimmed)

        switch detectedType {
        case .unixSeconds:
            return convertFromUnixSeconds(trimmed)
        case .unixMilliseconds:
            return convertFromUnixMilliseconds(trimmed)
        case .unixMicroseconds:
            return convertFromUnixMicroseconds(trimmed)
        case .unixNanoseconds:
            return convertFromUnixNanoseconds(trimmed)
        case .iso8601:
            return convertFromISO8601(trimmed)
        case .humanReadable:
            return convertFromHumanReadable(trimmed)
        case .unknown:
            return []
        }
    }

    // MARK: - Input Detection

    private func detectInputType(_ input: String) -> DetectedInputType {
        // Try to detect numeric timestamps
        if let number = Double(input) {
            // Determine timestamp precision based on magnitude
            if number > 1_000_000_000_000_000_000 { // > year 2001 in nanoseconds
                return .unixNanoseconds
            } else if number > 1_000_000_000_000_000 { // > year 2001 in microseconds
                return .unixMicroseconds
            } else if number > 1_000_000_000_000 { // > year 2001 in milliseconds
                return .unixMilliseconds
            } else if number > 1_000_000_000 { // > year 2001 in seconds
                return .unixSeconds
            }
        }

        // Try ISO8601
        if iso8601Formatter.date(from: input) != nil || iso8601FormatterWithoutFractional.date(from: input) != nil {
            return .iso8601
        }

        // Try various human-readable date formats
        if let _ = parseHumanReadableDate(input) {
            return .humanReadable
        }

        return .unknown
    }

    // MARK: - Conversion from Unix Timestamps

    private func convertFromUnixSeconds(_ input: String) -> [ConversionResult] {
        guard let seconds = Double(input) else { return [] }
        let date = Date(timeIntervalSince1970: seconds)

        var results: [ConversionResult] = []

        // To milliseconds
        results.append(ConversionResult(
            label: "Milliseconds",
            value: String(format: "%.0f", seconds * 1000),
            description: "Unix timestamp in milliseconds"
        ))

        // To microseconds
        results.append(ConversionResult(
            label: "Microseconds",
            value: String(format: "%.0f", seconds * 1_000_000),
            description: "Unix timestamp in microseconds"
        ))

        // To ISO8601
        results.append(ConversionResult(
            label: "ISO 8601",
            value: iso8601Formatter.string(from: date),
            description: "ISO 8601 format with timezone"
        ))

        // To human readable
        results.append(ConversionResult(
            label: "Human Readable",
            value: humanReadableFormatter.string(from: date),
            description: "Long date and time format"
        ))

        // To short format
        results.append(ConversionResult(
            label: "Short Format",
            value: shortDateFormatter.string(from: date),
            description: "Short date and time"
        ))

        // Relative time
        results.append(ConversionResult(
            label: "Relative",
            value: relativeDateFormatter.localizedString(for: date, relativeTo: Date()),
            description: "Time relative to now"
        ))

        return results
    }

    private func convertFromUnixMilliseconds(_ input: String) -> [ConversionResult] {
        guard let milliseconds = Double(input) else { return [] }
        let seconds = milliseconds / 1000.0
        let date = Date(timeIntervalSince1970: seconds)

        var results: [ConversionResult] = []

        // To seconds
        results.append(ConversionResult(
            label: "Seconds",
            value: String(format: "%.3f", seconds),
            description: "Unix timestamp in seconds"
        ))

        // To microseconds
        results.append(ConversionResult(
            label: "Microseconds",
            value: String(format: "%.0f", milliseconds * 1000),
            description: "Unix timestamp in microseconds"
        ))

        // To ISO8601
        results.append(ConversionResult(
            label: "ISO 8601",
            value: iso8601Formatter.string(from: date),
            description: "ISO 8601 format with timezone"
        ))

        // To human readable
        results.append(ConversionResult(
            label: "Human Readable",
            value: humanReadableFormatter.string(from: date),
            description: "Long date and time format"
        ))

        // To short format
        results.append(ConversionResult(
            label: "Short Format",
            value: shortDateFormatter.string(from: date),
            description: "Short date and time"
        ))

        // Relative time
        results.append(ConversionResult(
            label: "Relative",
            value: relativeDateFormatter.localizedString(for: date, relativeTo: Date()),
            description: "Time relative to now"
        ))

        return results
    }

    private func convertFromUnixMicroseconds(_ input: String) -> [ConversionResult] {
        guard let microseconds = Double(input) else { return [] }
        let seconds = microseconds / 1_000_000.0
        let date = Date(timeIntervalSince1970: seconds)

        var results: [ConversionResult] = []

        // To seconds
        results.append(ConversionResult(
            label: "Seconds",
            value: String(format: "%.6f", seconds),
            description: "Unix timestamp in seconds"
        ))

        // To milliseconds
        results.append(ConversionResult(
            label: "Milliseconds",
            value: String(format: "%.3f", microseconds / 1000),
            description: "Unix timestamp in milliseconds"
        ))

        // To ISO8601
        results.append(ConversionResult(
            label: "ISO 8601",
            value: iso8601Formatter.string(from: date),
            description: "ISO 8601 format with timezone"
        ))

        // To human readable
        results.append(ConversionResult(
            label: "Human Readable",
            value: humanReadableFormatter.string(from: date),
            description: "Long date and time format"
        ))

        // Relative time
        results.append(ConversionResult(
            label: "Relative",
            value: relativeDateFormatter.localizedString(for: date, relativeTo: Date()),
            description: "Time relative to now"
        ))

        return results
    }

    private func convertFromUnixNanoseconds(_ input: String) -> [ConversionResult] {
        guard let nanoseconds = Double(input) else { return [] }
        let seconds = nanoseconds / 1_000_000_000.0
        let date = Date(timeIntervalSince1970: seconds)

        var results: [ConversionResult] = []

        // To seconds
        results.append(ConversionResult(
            label: "Seconds",
            value: String(format: "%.9f", seconds),
            description: "Unix timestamp in seconds"
        ))

        // To milliseconds
        results.append(ConversionResult(
            label: "Milliseconds",
            value: String(format: "%.6f", nanoseconds / 1_000_000),
            description: "Unix timestamp in milliseconds"
        ))

        // To ISO8601
        results.append(ConversionResult(
            label: "ISO 8601",
            value: iso8601Formatter.string(from: date),
            description: "ISO 8601 format with timezone"
        ))

        // To human readable
        results.append(ConversionResult(
            label: "Human Readable",
            value: humanReadableFormatter.string(from: date),
            description: "Long date and time format"
        ))

        // Relative time
        results.append(ConversionResult(
            label: "Relative",
            value: relativeDateFormatter.localizedString(for: date, relativeTo: Date()),
            description: "Time relative to now"
        ))

        return results
    }

    // MARK: - Conversion from Date Strings

    private func convertFromISO8601(_ input: String) -> [ConversionResult] {
        guard let date = iso8601Formatter.date(from: input) ?? iso8601FormatterWithoutFractional.date(from: input) else {
            return []
        }

        let seconds = date.timeIntervalSince1970

        var results: [ConversionResult] = []

        // To unix seconds
        results.append(ConversionResult(
            label: "Unix Seconds",
            value: String(format: "%.0f", seconds),
            description: "Unix timestamp in seconds"
        ))

        // To milliseconds
        results.append(ConversionResult(
            label: "Unix Milliseconds",
            value: String(format: "%.0f", seconds * 1000),
            description: "Unix timestamp in milliseconds"
        ))

        // To human readable
        results.append(ConversionResult(
            label: "Human Readable",
            value: humanReadableFormatter.string(from: date),
            description: "Long date and time format"
        ))

        // To short format
        results.append(ConversionResult(
            label: "Short Format",
            value: shortDateFormatter.string(from: date),
            description: "Short date and time"
        ))

        // Relative time
        results.append(ConversionResult(
            label: "Relative",
            value: relativeDateFormatter.localizedString(for: date, relativeTo: Date()),
            description: "Time relative to now"
        ))

        return results
    }

    private func convertFromHumanReadable(_ input: String) -> [ConversionResult] {
        guard let date = parseHumanReadableDate(input) else { return [] }

        let seconds = date.timeIntervalSince1970

        var results: [ConversionResult] = []

        // To unix seconds
        results.append(ConversionResult(
            label: "Unix Seconds",
            value: String(format: "%.0f", seconds),
            description: "Unix timestamp in seconds"
        ))

        // To milliseconds
        results.append(ConversionResult(
            label: "Unix Milliseconds",
            value: String(format: "%.0f", seconds * 1000),
            description: "Unix timestamp in milliseconds"
        ))

        // To ISO8601
        results.append(ConversionResult(
            label: "ISO 8601",
            value: iso8601Formatter.string(from: date),
            description: "ISO 8601 format with timezone"
        ))

        // To short format
        results.append(ConversionResult(
            label: "Short Format",
            value: shortDateFormatter.string(from: date),
            description: "Short date and time"
        ))

        // Relative time
        results.append(ConversionResult(
            label: "Relative",
            value: relativeDateFormatter.localizedString(for: date, relativeTo: Date()),
            description: "Time relative to now"
        ))

        return results
    }

    // MARK: - Helpers

    private func parseHumanReadableDate(_ input: String) -> Date? {
        let formatters: [DateFormatter] = [
            humanReadableFormatter,
            shortDateFormatter,
            createFormatter(format: "yyyy-MM-dd HH:mm:ss"),
            createFormatter(format: "yyyy-MM-dd"),
            createFormatter(format: "MM/dd/yyyy HH:mm:ss"),
            createFormatter(format: "MM/dd/yyyy"),
            createFormatter(format: "dd/MM/yyyy HH:mm:ss"),
            createFormatter(format: "dd/MM/yyyy"),
            createFormatter(format: "MMM dd, yyyy HH:mm:ss"),
            createFormatter(format: "MMM dd, yyyy"),
            createFormatter(format: "MMMM dd, yyyy HH:mm:ss"),
            createFormatter(format: "MMMM dd, yyyy"),
        ]

        for formatter in formatters {
            if let date = formatter.date(from: input) {
                return date
            }
        }

        return nil
    }

    private func createFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        return formatter
    }
}