//
//  Note.swift
//  Note-poc
//
//  Created by Teddy Rogers on 01/11/2023.
//

import SwiftUI
import SwiftData


@Model
class Note {
    var content: String
    var isFavorite: Bool = false
    var category: NoteCategory?
    
    init(content: String, category: NoteCategory? = nil) {
        self.content = content
        self.category = category
    }
}
