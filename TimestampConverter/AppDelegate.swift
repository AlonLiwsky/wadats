//
//  AppDelegate.swift
//  TimestampConverter
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem?
    private var popupWindow: PopupWindowController?
    private var settingsWindow: SettingsWindowController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create status bar item
        setupStatusBar()

        // Register global hotkey
        GlobalHotKeyManager.shared.register {
            self.handleHotKey()
        }

        // Request accessibility permissions if not granted
        checkAccessibilityPermissions()
    }

    private func setupStatusBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "clock.arrow.circlepath", accessibilityDescription: "Timestamp Converter")
            button.action = #selector(statusBarButtonClicked)
            button.target = self
        }

        // Create menu
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Convert Selected Text", action: #selector(convertSelectedText), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu
    }

    @objc private func statusBarButtonClicked() {
        // Menu will appear automatically
    }

    @objc private func convertSelectedText() {
        handleHotKey()
    }

    @objc private func openSettings() {
        if settingsWindow == nil {
            settingsWindow = SettingsWindowController()
        }
        settingsWindow?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }

    private func handleHotKey() {
        // Get selected text from any application
        let selectedText = getSelectedText()

        // Convert timestamp
        let results = TimestampConverter.shared.convert(selectedText)

        // Show popup window
        showPopup(with: results)
    }

    private func getSelectedText() -> String {
        // Save current clipboard
        let pasteboard = NSPasteboard.general
        let oldContents = pasteboard.string(forType: .string)

        // Simulate Cmd+C to copy selected text
        let source = CGEventSource(stateID: .hidSystemState)

        let keyDownEvent = CGEvent(keyboardEventSource: source, virtualKey: 0x08, keyDown: true) // C key
        keyDownEvent?.flags = .maskCommand
        keyDownEvent?.post(tap: .cghidEventTap)

        let keyUpEvent = CGEvent(keyboardEventSource: source, virtualKey: 0x08, keyDown: false)
        keyUpEvent?.flags = .maskCommand
        keyUpEvent?.post(tap: .cghidEventTap)

        // Wait a bit for the clipboard to update
        Thread.sleep(forTimeInterval: 0.1)

        // Get the copied text
        let copiedText = pasteboard.string(forType: .string) ?? ""

        // Restore old clipboard contents
        if let oldContents = oldContents {
            pasteboard.clearContents()
            pasteboard.setString(oldContents, forType: .string)
        }

        return copiedText
    }

    private func showPopup(with results: [ConversionResult]) {
        popupWindow = PopupWindowController(results: results)
        popupWindow?.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func checkAccessibilityPermissions() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options)

        if !accessEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let alert = NSAlert()
                alert.messageText = "Accessibility Permission Required"
                alert.informativeText = "TimestampConverter needs accessibility permissions to read selected text. Please grant access in System Settings → Privacy & Security → Accessibility."
                alert.alertStyle = .warning
                alert.addButton(withTitle: "Open System Settings")
                alert.addButton(withTitle: "Later")

                if alert.runModal() == .alertFirstButtonReturn {
                    NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
                }
            }
        }
    }

    // MARK: - Services Integration

    @objc func convertTimestamp(_ pboard: NSPasteboard, userData: String, error: AutoreleasingUnsafeMutablePointer<NSString>) {
        guard let selectedText = pboard.string(forType: .string) else {
            return
        }

        let results = TimestampConverter.shared.convert(selectedText)
        showPopup(with: results)
    }

    func applicationWillTerminate(_ notification: Notification) {
        GlobalHotKeyManager.shared.unregister()
    }
}