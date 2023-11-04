//
//  Note_pocApp.swift
//  Note-poc
//
//  Created by Teddy Rogers on 01/11/2023.
//

import SwiftUI
import SwiftData

@main
struct Note_pocApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 700, minHeight: 500)
        }
        .windowResizability(.contentSize)
        .modelContainer(for: [Note.self, NoteCategory.self])
    }
}
