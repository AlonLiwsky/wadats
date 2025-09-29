//
//  PopupWindow.swift
//  TimestampConverter
//

import SwiftUI
import AppKit

/// Popup window that displays conversion results
class PopupWindowController: NSWindowController {

    convenience init(results: [ConversionResult]) {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.title = "Timestamp Conversions"
        window.isMovableByWindowBackground = true
        window.level = .floating
        window.backgroundColor = NSColor.windowBackgroundColor
        window.titlebarAppearsTransparent = true
        window.center()

        let contentView = PopupContentView(results: results, closeWindow: {
            window.close()
        })

        window.contentView = NSHostingView(rootView: contentView)

        self.init(window: window)
    }
}

/// SwiftUI view for the popup content
struct PopupContentView: View {
    let results: [ConversionResult]
    let closeWindow: () -> Void

    @State private var hoveredResult: ConversionResult?
    @State private var copiedResult: ConversionResult?

    var body: some View {
        VStack(spacing: 0) {
            // Title bar
            HStack {
                Text("Timestamp Conversions")
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Button(action: closeWindow) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 8)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))

            Divider()

            if results.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "clock.badge.questionmark")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)

                    Text("No timestamp detected")
                        .font(.title3)
                        .foregroundColor(.secondary)

                    Text("Select a timestamp and press ⌘⇧T")
                        .font(.caption)
                        .foregroundColor(.tertiary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(results) { result in
                            ResultRow(
                                result: result,
                                isHovered: hoveredResult?.id == result.id,
                                isCopied: copiedResult?.id == result.id,
                                onHover: { isHovering in
                                    hoveredResult = isHovering ? result : nil
                                },
                                onCopy: {
                                    copyToClipboard(result.value)
                                    copiedResult = result

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                        if copiedResult?.id == result.id {
                                            copiedResult = nil
                                        }
                                    }
                                },
                                onInsert: {
                                    insertText(result.value)
                                    closeWindow()
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(width: 500, height: 400)
    }

    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }

    private func insertText(_ text: String) {
        // Copy to clipboard
        copyToClipboard(text)

        // Simulate Cmd+V to paste
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let source = CGEventSource(stateID: .hidSystemState)

            // Press Cmd+V
            let keyDownEvent = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
            keyDownEvent?.flags = .maskCommand
            keyDownEvent?.post(tap: .cghidEventTap)

            let keyUpEvent = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
            keyUpEvent?.flags = .maskCommand
            keyUpEvent?.post(tap: .cghidEventTap)
        }
    }
}

/// Individual result row
struct ResultRow: View {
    let result: ConversionResult
    let isHovered: Bool
    let isCopied: Bool
    let onHover: (Bool) -> Void
    let onCopy: () -> Void
    let onInsert: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(result.label)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(result.value)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                    .textSelection(.enabled)

                Text(result.description)
                    .font(.caption)
                    .foregroundColor(.tertiary)
            }

            Spacer()

            if isHovered || isCopied {
                HStack(spacing: 8) {
                    if isCopied {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .transition(.scale)
                    } else {
                        Button(action: onCopy) {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .help("Copy to clipboard")

                        Button(action: onInsert) {
                            Image(systemName: "arrow.down.doc")
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .help("Insert into active app")
                    }
                }
                .transition(.opacity)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isHovered ? Color.accentColor.opacity(0.1) : Color.clear)
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                onHover(hovering)
            }
        }
    }
}