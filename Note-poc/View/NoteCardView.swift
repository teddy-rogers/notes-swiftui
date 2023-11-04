//
//  NoteCardView.swift
//  Note-poc
//
//  Created by Teddy Rogers on 03/11/2023.
//

import SwiftUI

struct NoteCardView: View {
    @Bindable var note: Note
    @State private var isShowNote: Bool = false
    var isUserEditingNote: FocusState<Bool>.Binding
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.clear)
            
            if isShowNote {
                TextEditor(text:$note.content)
                    .focused(isUserEditingNote)
                    .overlay(content: {
                        Text("Type your note")
                            .foregroundStyle(.gray)
                            .padding(.leading, 5)
                            .opacity(note.content.isEmpty ? 1 : 0)
                            .allowsHitTesting(false)
                    })
                    .scrollContentBackground(.hidden)
                    .multilineTextAlignment(.leading)
                    .padding(15)
                    .kerning(1.2)
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.15), in: .rect(cornerRadius: 12))
            }
        }
        .onAppear {
            isShowNote = true
        }
        .onDisappear {
            isShowNote = false
        }
        
    }
}
