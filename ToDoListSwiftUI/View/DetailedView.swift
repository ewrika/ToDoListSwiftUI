//
//  DetailedView.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import SwiftUI

struct DetailedView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode

    var task: TaskItem?
    var body: some View {

        VStack(alignment: .leading, spacing: 16) {
            TextField("Заголовок", text: $title)
               .font(.Bold34)
                .fontWeight(.bold)
                .textFieldStyle(PlainTextFieldStyle())

            Text(Date().formattedShort())
                .font(.Regular12)
                .foregroundColor(.gray)

            TextEditor(text: $description)
                .frame(maxHeight: .infinity)
                .foregroundColor(.primary)
                .font(.Regular16)
                .padding(.horizontal, -4)
        }
        .padding()
        .onAppear {
            if let task = task {
                // Если задача существует, заполняем данные
                title = task.title ?? ""
                description = task.desc ?? ""
            }
        }
        .onDisappear {
            saveTask()
        }
    }
    func saveTask() {
        if title == "" {
            return
        }
        withAnimation {
            let newTask = task ?? TaskItem(context: viewContext)
            newTask.title = title
            newTask.desc = description
            newTask.created = Date()
            do {
                try viewContext.save()
            } catch {
                print("Ошибка при сохранении задачи: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    DetailedView()
}
