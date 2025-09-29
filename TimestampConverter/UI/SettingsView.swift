//
//  SettingsView.swift
//  Wadats (What's that timestamp?)
//

import SwiftUI

/// Settings/Preferences window
struct SettingsView: View {

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 48))
                .foregroundColor(.accentColor)

            Text("Wadats")
                .font(.title)
                .fontWeight(.bold)

            Text("What's that timestamp?")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Version 1.0")
                .font(.caption)
                .foregroundColor(.secondary)

            Divider()
                .padding(.vertical)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "keyboard")
                        .frame(width: 24)
                    Text("Global Shortcut:")
                        .fontWeight(.medium)
                    Spacer()
                    Text("⌘⇧T")
                        .font(.system(.body, design: .monospaced))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(4)
                }

                HStack(alignment: .top) {
                    Image(systemName: "hand.point.up")
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Context Menu:")
                            .fontWeight(.medium)
                        Text("Right-click selected text → Services → Convert Timestamp")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }

                HStack(alignment: .top) {
                    Image(systemName: "info.circle")
                        .frame(width: 24)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("How to Use:")
                            .fontWeight(.medium)
                        Text("1. Select any timestamp\n2. Press ⌘⇧T or use context menu\n3. Choose format to copy or insert")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(8)

            Spacer()

            HStack(spacing: 20) {
                Button("Quit Wadats") {
                    NSApplication.shared.terminate(nil)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(30)
        .frame(width: 500, height: 500)
    }
}

/// Window controller for settings
class SettingsWindowController: NSWindowController {

    convenience init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        window.title = "Wadats Settings"
        window.center()

        let contentView = SettingsView()
        window.contentView = NSHostingView(rootView: contentView)

        self.init(window: window)
    }
}