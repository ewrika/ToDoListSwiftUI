//
//  ToDoItemView.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import SwiftUI

struct ToDoItemView: View {
    @State var isCompleted: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Button(action: {
                isCompleted.toggle()
            }) {
                Image(systemName: isCompleted ? "checkmark.circle" : "circle")
                    .foregroundColor(isCompleted ? .yellow : .gray)
                    .font(.system(size: 24))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("task.title")
                    .font(.headline)
                    .strikethrough(isCompleted, color: .gray)
                    .opacity(isCompleted ? 0.5 : 1.0)
                Text("task.description")
                    .lineLimit(2)
                    .font(.subheadline)
                    .opacity(isCompleted ? 0.5 : 1.0)
                Text("task.date.formattedShort()")
                    .font(.footnote)
                    .opacity(0.5)
            }
            
        }            .contextMenu {
            Button {
                print("Редактировать задачу ")
                // Логика для редактирования
            } label: {
                Label("Редактировать", systemImage: "pencil")
            }

            Button {
                print("Поделиться задачей")
                // Логика для шаринга
            } label: {
                Label("Поделиться", systemImage: "square.and.arrow.up")
            }

            Button(role: .destructive) {
  
            } label: {
                Label("Удалить задачу", systemImage: "trash")
            }
        }.frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ToDoItemView(isCompleted: false)
}
