//
//  GlobalHotKeyManager.swift
//  TimestampConverter
//

import Cocoa
import Carbon

/// Manages global keyboard shortcuts
class GlobalHotKeyManager {

    static let shared = GlobalHotKeyManager()

    private var eventHandler: EventHandlerRef?
    private var hotKeyRef: EventHotKeyRef?
    private var callback: (() -> Void)?

    private init() {}

    /// Register a global hotkey (default: Cmd+Shift+T)
    func register(callback: @escaping () -> Void) {
        self.callback = callback

        // Default hotkey: Cmd+Shift+T
        let keyCode: UInt32 = 17 // T key
        let modifiers: UInt32 = UInt32(cmdKey | shiftKey)

        registerHotKey(keyCode: keyCode, modifiers: modifiers)
    }

    private func registerHotKey(keyCode: UInt32, modifiers: UInt32) {
        var hotKeyID = EventHotKeyID()
        hotKeyID.signature = OSType("TSCV".fourCharCodeValue)
        hotKeyID.id = 1

        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyPressed)

        let handler: EventHandlerUPP = { (nextHandler, theEvent, userData) -> OSStatus in
            GlobalHotKeyManager.shared.handleHotKeyEvent()
            return noErr
        }

        InstallEventHandler(GetApplicationEventTarget(), handler, 1, &eventType, nil, &eventHandler)

        RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
    }

    private func handleHotKeyEvent() {
        callback?()
    }

    func unregister() {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
            self.eventHandler = nil
        }
    }

    deinit {
        unregister()
    }
}

// Helper extension to convert string to FourCharCode
extension String {
    var fourCharCodeValue: FourCharCode {
        var result: FourCharCode = 0
        if let data = self.data(using: .utf8) {
            data.withUnsafeBytes { bytes in
                for i in 0..<min(4, data.count) {
                    result = result << 8 + FourCharCode(bytes[i])
                }
            }
        }
        return result
    }
}