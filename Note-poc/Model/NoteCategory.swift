//
//  NoteCategory.swift
//  Note-poc
//
//  Created by Teddy Rogers on 01/11/2023.
//

import SwiftUI
import SwiftData

@Model
class NoteCategory {
    var categoryTitle: String
    @Relationship(deleteRule: .cascade, inverse: \Note.category)
    var notes: [Note]?
    
    init(categoryTitle: String) {
        self.categoryTitle = categoryTitle
    }
}
