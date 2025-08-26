//
//  GitHub_VOISApp.swift
//  GitHub-VOIS
//
//  Created by Merna Islam on 22/08/2025.
//

import SwiftUI

@main
struct GitHub_VOISApp: App {
    @State private var showSplash = true
    var body: some Scene {
        WindowGroup {
            if showSplash {
                LaunchScreen(isActive: $showSplash)
            } else {
                SearchView(searchText: "")
            }
        }
    }
}
