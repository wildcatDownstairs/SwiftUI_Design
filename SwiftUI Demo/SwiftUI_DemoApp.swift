//
//  SwiftUI_DemoApp.swift
//  SwiftUI Demo
//
//  Created by 乐可 on 2026/05/30.
//

import SwiftUI

@main
struct SwiftUI_DemoApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.light)
                .tint(Theme.accent)
        }
    }
}
