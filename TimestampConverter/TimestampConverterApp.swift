//
//  TimestampConverterApp.swift
//  TimestampConverter
//

import SwiftUI

@main
struct TimestampConverterApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // Empty scene - we use menu bar only
        Settings {
            EmptyView()
        }
    }
}