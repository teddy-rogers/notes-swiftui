//
//  NotesView.swift
//  Note-poc
//
//  Created by Teddy Rogers on 03/11/2023.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    var category: String?
    var allCategories: [NoteCategory]
    
    @Query private var notes: [Note]
    
    @Environment(\.modelContext) private var context
    
    @FocusState var isUserEditingNote: Bool

    init(category: String?, allCategories: [NoteCategory]) {
        self.category = category
        self.allCategories = allCategories
        let categoryPredicate = #Predicate<Note> {
            return $0.category?.categoryTitle == category
        }
        let favoritePredicate = #Predicate<Note> {
            return $0.isFavorite
        }
        let finalPredicat = category == "All Notes" ? nil : (category == "Favorites" ? favoritePredicate : categoryPredicate)
        _notes = Query(filter: finalPredicat, sort: [], animation: .snappy)
    }
    
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let width = size.width
            let rowCount = max(Int(width) / 250, 1)
            
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: rowCount), spacing: 10) {
                    ForEach(notes) { note in
                        NoteCardView(note: note, isUserEditingNote: $isUserEditingNote)
                            .contextMenu {
                                Button(note.isFavorite ? "Remove from favorites" : "Add to favorites") {
                                    note.isFavorite.toggle()
                                }
                                
                                Menu {
                                    ForEach(allCategories) { category in
                                        Button {
                                            note.category = category
                                        } label: {
                                            HStack(spacing: 5) {
                                                Text(category.categoryTitle)
                                                
                                                if category == note.category {
                                                    Image(systemName: "checkmark")
                                                        .font(.caption)
                                                }
                                            }
                                        }
                                        
                                        
                                    }
                                    Button("Remove from category") {
                                        note.category = nil
                                    }
                                    
                                } label: {
                                    Text("Category")
                                }
                                Button("Delete Note", role: .destructive) {
                                    context.delete(note)
                                }
                            }
                    }
                }
                .padding(12)
            }
            .onTapGesture {
                isUserEditingNote = false
            }
        }
    }
}

#Preview {
    ContentView()
}
