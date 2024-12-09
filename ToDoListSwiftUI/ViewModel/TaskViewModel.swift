//
//  TaskViewModel.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import Foundation
import CoreData

class TaskViewModel: ObservableObject {
    private let context: NSManagedObjectContext

    @Published var tasks: [TaskItem] = []
    @Published var searchText = ""

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchTasks()
    }

    func fetchTasks() {
        let request: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
        do {
            tasks = try context.fetch(request)
        } catch {
            print("Ошибка при получении задач: \(error.localizedDescription)")
        }
    }

    func addTask(title: String, description: String) {
        let newTask = TaskItem(context: context)
        newTask.title = title
        newTask.desc = description
        newTask.created = Date()

        saveContext()
        fetchTasks()
    }

    func editTask(_ task: TaskItem, title: String, description: String) {
        task.title = title
        task.desc = description
        saveContext()
        fetchTasks()
    }

    func deleteTask(_ task: TaskItem) {
        context.delete(task)
        saveContext()
        fetchTasks()
    }

    func toggleCompletion(_ task: TaskItem) {
        task.isCompleted.toggle()
        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении контекста: \(error.localizedDescription)")
        }
    }
}
