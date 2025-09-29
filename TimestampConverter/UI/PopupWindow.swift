//
//  PopupWindow.swift
//  Wadats (What's that timestamp?)
//

import SwiftUI
import AppKit
import Combine

/// Custom NSPanel that can become key to receive keyboard events
class KeyablePanel: NSPanel {
    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return false
    }
}

/// Observable state for popup window
class PopupState: ObservableObject {
    @Published var selectedIndex: Int = 0
}

/// Popup window that displays conversion results (Maccy/Clipy style)
class PopupWindowController: NSWindowController, NSWindowDelegate {

    private var state = PopupState()
    var results: [ConversionResult] = []
    private var localEventMonitor: Any?
    private var globalEventMonitor: Any?

    convenience init(results: [ConversionResult]) {
        // Get cursor position
        let mouseLocation = NSEvent.mouseLocation

        // Create window at cursor position
        let windowWidth: CGFloat = 450
        let windowHeight: CGFloat = min(CGFloat(results.count * 50 + 10), 400)

        let window = KeyablePanel(
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
        window.isMovable = false
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        window.acceptsMouseMovedEvents = true

        self.init(window: window)

        self.results = results
        window.delegate = self

        let contentView = PopupContentView(
            results: results,
            state: state,
            closeWindow: { [weak self] in
                self?.closeWindow()
            },
            onAction: { [weak self] action, result in
                self?.handleAction(action, for: result)
            }
        )

        window.contentView = NSHostingView(rootView: contentView)

        // Make window key
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        // Setup keyboard and click monitoring
        setupEventMonitoring()
    }

    private func setupEventMonitoring() {
        // Local monitor for keyboard events
        localEventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            guard let self = self else { return event }

            // Handle keyboard events
            if event.type == .keyDown {
                let keyCode = event.keyCode
                let modifierFlags = event.modifierFlags

                switch keyCode {
                case 125: // Down arrow
                    if self.state.selectedIndex < self.results.count - 1 {
                        self.state.selectedIndex += 1
                    }
                    return nil
                case 126: // Up arrow
                    if self.state.selectedIndex > 0 {
                        self.state.selectedIndex -= 1
                    }
                    return nil
                case 36: // Return
                    if !self.results.isEmpty {
                        if modifierFlags.contains(.command) {
                            // Cmd+Enter = insert
                            self.handleAction(.insert, for: self.results[self.state.selectedIndex])
                        } else {
                            // Enter = copy
                            self.handleAction(.copy, for: self.results[self.state.selectedIndex])
                        }
                    }
                    return nil
                case 53: // Escape
                    self.closeWindow()
                    return nil
                case 8 where modifierFlags.contains(.command): // Cmd+C
                    if !self.results.isEmpty {
                        self.handleAction(.copy, for: self.results[self.state.selectedIndex])
                    }
                    return nil
                default:
                    break
                }
            }

            return event
        }

        // Global monitor for clicks outside
        globalEventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            guard let self = self, let window = self.window else { return }

            // Get click location in screen coordinates
            let clickLocation = NSEvent.mouseLocation

            // Check if click is outside our window
            if !window.frame.contains(clickLocation) {
                self.closeWindow()
            }
        }
    }

    private func closeWindow() {
        if let monitor = localEventMonitor {
            NSEvent.removeMonitor(monitor)
            self.localEventMonitor = nil
        }
        if let monitor = globalEventMonitor {
            NSEvent.removeMonitor(monitor)
            self.globalEventMonitor = nil
        }
        window?.close()
    }

    private func handleAction(_ action: ResultAction, for result: ConversionResult) {
        switch action {
        case .copy:
            copyToClipboard(result.value)
            closeWindow()
        case .insert:
            insertText(result.value)
            closeWindow()
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

    func windowWillClose(_ notification: Notification) {
        if let monitor = localEventMonitor {
            NSEvent.removeMonitor(monitor)
            self.localEventMonitor = nil
        }
        if let monitor = globalEventMonitor {
            NSEvent.removeMonitor(monitor)
            self.globalEventMonitor = nil
        }
    }

    deinit {
        if let monitor = localEventMonitor {
            NSEvent.removeMonitor(monitor)
        }
        if let monitor = globalEventMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}

/// SwiftUI view for the popup content - Maccy/Clipy style list
struct PopupContentView: View {
    let results: [ConversionResult]
    @ObservedObject var state: PopupState
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
                                isSelected: index == state.selectedIndex,
                                onSelect: {
                                    state.selectedIndex = index
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
                    ActionButton(icon: "doc.on.doc", hint: "↵", action: {
                        onAction(.copy)
                    })

                    ActionButton(icon: "arrow.down.doc", hint: "⌘↵", action: {
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
            // Single click = copy (default action)
            onAction(.copy)
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