//
//  TaskManager.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 12.12.2024.
//

import Foundation
import CoreData

final class TaskManager {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func addTask(title: String, description: String) async {
        await context.perform {
            let newTask = TaskItem(context: self.context)
            newTask.title = title
            newTask.desc = description
            newTask.created = Date()
        }
        await saveContext()
    }

    func editTask(_ task: TaskItem, title: String, description: String) async {
        await context.perform {
            task.title = title
            task.desc = description
        }
        await saveContext()
    }

    func deleteTask(_ task: TaskItem) async {
        await context.perform {
            self.context.delete(task)
        }
        await saveContext()
    }

    func toggleCompletion(_ task: TaskItem) async {
        await context.perform {
            task.isCompleted.toggle()
        }
        await saveContext()
    }

    private func saveContext() async {
        await context.perform {
            do {
                try self.context.save()
            } catch {
                print("Ошибка при сохранении: \(error.localizedDescription)")
            }
        }
    }
}
