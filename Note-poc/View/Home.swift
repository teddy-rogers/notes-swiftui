//
//  Home.swift
//  Note-poc
//
//  Created by Teddy Rogers on 01/11/2023.
//

import SwiftUI
import SwiftData

struct Home: View {
    @State private var selectedTag: String? = "All Notes"
    @State private var categoryTitle: String = ""
    @State private var requestedCategory: NoteCategory?
    @State private var isAddCategoryAlertOpen: Bool = false
    @State private var isRenameCategoryAlertOpen: Bool = false
    @State private var isDeleteCategoryAlertOpen: Bool = false
    @State private var isDarkMode: Bool = false
    
    @Query(animation: .snappy) private var categories: [NoteCategory]
    
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTag) {
                Text("All Notes")
                    .tag("All Notes")
                    .foregroundColor(selectedTag == "All Notes" ? .primary : .gray)
                
                Text("Favorites")
                    .tag("Favorites")
                    .foregroundColor(selectedTag == "Favorites" ? .primary : .gray)
                
                Section {
                    let sortedCategories = categories.sorted { $0.categoryTitle.lowercased() < $1.categoryTitle.lowercased()}
                    ForEach(sortedCategories) {category in
                        Text(category.categoryTitle)
                            .tag(category.categoryTitle)
                            .foregroundColor(selectedTag == category.categoryTitle ? .primary : .gray)
                            .contextMenu {
                                Button("Rename"){
                                    categoryTitle = category.categoryTitle
                                    requestedCategory = category
                                    isRenameCategoryAlertOpen = true
                                }
                                
                                Button("Delete"){
                                    categoryTitle = category.categoryTitle
                                    requestedCategory = category
                                    isDeleteCategoryAlertOpen = true
                                }
                            }
                    }
                } header: {
                    HStack(spacing:5) {
                        Text("Categories")
                        
                        Button("", systemImage: "plus") {
                            isAddCategoryAlertOpen.toggle()
                        }
                        .buttonStyle(.plain)
                        .tint(.gray)
                    }
                }
            }
        } detail: {
            NotesView(category: selectedTag, allCategories: categories)
        }
        .navigationTitle(selectedTag ?? "Notes")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 10) {
                    Button("", systemImage: "plus"){
                        let newNote = Note(content:"")
                        context.insert(newNote)
                    }
                        
                    Button("", systemImage: isDarkMode ? "sun.min" : "moon"){
                        isDarkMode.toggle()
                    }
                    .contentTransition(.symbolEffect(.replace))
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .alert("Add category", isPresented: $isAddCategoryAlertOpen) {
            TextField("Add a new category", text: $categoryTitle)
            
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
            }
            
            Button("Add"){
                let category = NoteCategory(categoryTitle: categoryTitle)
                context.insert(category)
                categoryTitle = ""
            }
            
        }
        .alert("Rename category", isPresented: $isRenameCategoryAlertOpen) {
            TextField("Rename a new category", text: $categoryTitle)
            
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
                requestedCategory = nil
            }
            
            Button("Rename"){
                if let requestedCategory {
                    requestedCategory.categoryTitle = categoryTitle
                    categoryTitle = ""
                    self.requestedCategory = nil
                }
            }
            
        }
        .alert("Delete category : \(categoryTitle)", isPresented: $isDeleteCategoryAlertOpen) {
            Button("Cancel", role: .cancel) {
                categoryTitle = ""
                requestedCategory = nil
            }
            
            Button("Delete", role: .destructive){
                if let requestedCategory {
                    context.delete(requestedCategory)
                    categoryTitle = ""
                    self.requestedCategory = nil
                }
            }
            
        }
    }
}

#Preview {
    ContentView()
}
