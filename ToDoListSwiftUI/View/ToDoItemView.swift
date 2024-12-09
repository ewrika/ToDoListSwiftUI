//
//  ToDoItemView.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import SwiftUI

struct ToDoItemView: View {
    @State var isCompleted: Bool
    let title: String
    let description: String
    let date: String
    
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
                Text(title)
                    .font(.Medium16)
                    .strikethrough(isCompleted, color: .gray)
                    .opacity(isCompleted ? 0.5 : 1.0)
                Text(description)
                    .lineLimit(2)
                    .font(.Regular12)
                    .opacity(isCompleted ? 0.5 : 1.0)
                Text(date)
                    .font(.Regular12)
                    .opacity(0.5)
            }
            
        } .swipeActions{
            Button("Delete") {
                
            }
        }
        .contextMenu {
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
    VStack(spacing: 20) {
        // Пример выполненной задачи
        ToDoItemView(
            isCompleted: true, title: "Почитать Книгу",
            description: "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике.",
            date: "09/10/24"
        )

        // Пример невыполненной задачи
        ToDoItemView(
            isCompleted: false, title: "Сделать уборку",
            description: "Навести порядок в комнате, расставить книги и протереть пыль.",
            date: "09/10/24"
        )

    }
    .padding()
}
