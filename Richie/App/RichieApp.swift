//
//  RichieApp.swift
//  Richie
//
//  Created by Valentin COUSIEN on 23/03/2025.
//

import SwiftUI
import SwiftData

@main
struct RichieApp: App {
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    #endif

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .modelContainer(for: Investment.self)
        }
    }
}
