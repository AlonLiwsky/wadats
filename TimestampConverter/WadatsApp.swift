//
//  WadatsApp.swift
//  Wadats
//

import SwiftUI

@main
struct WadatsApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // Empty scene - we use menu bar only
        Settings {
            EmptyView()
        }
    }
}