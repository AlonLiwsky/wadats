//
//  PopupWindow.swift
//  Wadats (What's that timestamp?)
//

import SwiftUI
import AppKit

/// Popup window that displays conversion results (Maccy/Clipy style)
class PopupWindowController: NSWindowController, NSWindowDelegate {

    var selectedIndex: Int = 0
    var results: [ConversionResult] = []

    convenience init(results: [ConversionResult]) {
        // Get cursor position
        let mouseLocation = NSEvent.mouseLocation

        // Create window at cursor position
        let windowWidth: CGFloat = 450
        let windowHeight: CGFloat = min(CGFloat(results.count * 50 + 10), 400)

        let window = NSWindow(
            contentRect: NSRect(
                x: mouseLocation.x,
                y: mouseLocation.y - windowHeight,
                width: windowWidth,
                height: windowHeight
            ),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .popUpMenu
        window.hasShadow = true

        self.init(window: window)

        self.results = results
        window.delegate = self

        let contentView = PopupContentView(
            results: results,
            selectedIndex: .constant(selectedIndex),
            closeWindow: { [weak self] in
                self?.window?.close()
            },
            onAction: { [weak self] action, result in
                self?.handleAction(action, for: result)
            }
        )

        window.contentView = NSHostingView(rootView: contentView)

        // Make window key and activate app
        window.makeKeyAndOrderFront(nil)
    }

    override func keyDown(with event: NSEvent) {
        switch Int(event.keyCode) {
        case 125: // Down arrow
            if selectedIndex < results.count - 1 {
                selectedIndex += 1
                updateSelection()
            }
        case 126: // Up arrow
            if selectedIndex > 0 {
                selectedIndex -= 1
                updateSelection()
            }
        case 36: // Return
            if !results.isEmpty {
                handleAction(.insert, for: results[selectedIndex])
            }
        case 53: // Escape
            window?.close()
        case 8 where event.modifierFlags.contains(.command): // Cmd+C
            if !results.isEmpty {
                handleAction(.copy, for: results[selectedIndex])
            }
        default:
            super.keyDown(with: event)
        }
    }

    private func updateSelection() {
        if let hostingView = window?.contentView as? NSHostingView<PopupContentView> {
            let contentView = PopupContentView(
                results: results,
                selectedIndex: .constant(selectedIndex),
                closeWindow: { [weak self] in
                    self?.window?.close()
                },
                onAction: { [weak self] action, result in
                    self?.handleAction(action, for: result)
                }
            )
            hostingView.rootView = contentView
        }
    }

    private func handleAction(_ action: ResultAction, for result: ConversionResult) {
        switch action {
        case .copy:
            copyToClipboard(result.value)
            window?.close()
        case .insert:
            insertText(result.value)
            window?.close()
        }
    }

    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }

    private func insertText(_ text: String) {
        copyToClipboard(text)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let source = CGEventSource(stateID: .hidSystemState)

            let keyDownEvent = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
            keyDownEvent?.flags = .maskCommand
            keyDownEvent?.post(tap: .cghidEventTap)

            let keyUpEvent = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
            keyUpEvent?.flags = .maskCommand
            keyUpEvent?.post(tap: .cghidEventTap)
        }
    }
}

/// SwiftUI view for the popup content - Maccy/Clipy style list
struct PopupContentView: View {
    let results: [ConversionResult]
    @Binding var selectedIndex: Int
    let closeWindow: () -> Void
    let onAction: (ResultAction, ConversionResult) -> Void

    var body: some View {
        VStack(spacing: 0) {
            if results.isEmpty {
                Text("No timestamp detected")
                    .foregroundColor(.secondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(NSColor.controlBackgroundColor))
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(results.enumerated()), id: \.element.id) { index, result in
                            ListItemView(
                                result: result,
                                isSelected: index == selectedIndex,
                                onSelect: {
                                    selectedIndex = index
                                },
                                onAction: { action in
                                    onAction(action, result)
                                }
                            )
                        }
                    }
                }
            }
        }
        .frame(maxWidth: 450, minHeight: 50, maxHeight: 400)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

enum ResultAction {
    case copy
    case insert
}

/// Individual list item - Maccy/Clipy style
struct ListItemView: View {
    let result: ConversionResult
    let isSelected: Bool
    let onSelect: () -> Void
    let onAction: (ResultAction) -> Void

    @State private var isHovered: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                // VALUE is prominent (what user wants to copy)
                Text(result.value)
                    .font(.system(.body, design: .monospaced))
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                    .lineLimit(1)

                // Label is secondary (format type)
                Text(result.label)
                    .font(.caption)
                    .foregroundColor(isSelected ? Color.white.opacity(0.8) : Color.secondary.opacity(0.7))
            }

            Spacer()

            // Show action hints on hover or selection
            if isHovered || isSelected {
                HStack(spacing: 8) {
                    ActionButton(icon: "doc.on.doc", hint: "⌘C", action: {
                        onAction(.copy)
                    })

                    ActionButton(icon: "arrow.down.doc", hint: "↵", action: {
                        onAction(.insert)
                    })
                }
                .opacity(isSelected ? 1.0 : 0.6)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            Rectangle()
                .fill(isSelected ? Color.accentColor : (isHovered ? Color.gray.opacity(0.1) : Color.clear))
        )
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovered = hovering
            if hovering {
                onSelect()
            }
        }
        .onTapGesture {
            onAction(.insert)
        }
    }
}

/// Action button for copy/insert
struct ActionButton: View {
    let icon: String
    let hint: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(hint)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .foregroundColor(.white.opacity(0.9))
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(Color.black.opacity(0.2))
            .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}