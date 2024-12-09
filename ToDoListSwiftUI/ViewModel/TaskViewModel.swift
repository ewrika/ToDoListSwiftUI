//
//  TaskViewModel.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import Foundation
import CoreData
import SwiftUI
@MainActor
class TaskViewModel: ObservableObject {
    private let context: NSManagedObjectContext

    @Published var tasks: [TaskItem] = []

    init(context: NSManagedObjectContext) {
        self.context = context
        Task {
          await fetchTasks()
        }
    }

    func fetchTasks() async {
        do {
            let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
            let tasks = try await context.perform { try self.context.fetch(fetchRequest) }
            self.tasks = tasks
        } catch {
            print("Ошибка загрузки задач: \(error.localizedDescription)")
        }
    }

    func addTask(title: String, description: String) async {
        await context.perform {
            let newTask = TaskItem(context: self.context)
            newTask.title = title
            newTask.desc = description
            newTask.created = Date()
        }
        await saveContext()
        await fetchTasks()
    }


    func editTask(_ task: TaskItem, title: String, description: String) async {
        await context.perform {
            task.title = title
            task.desc = description
        }
        await saveContext()
        await fetchTasks()
    }

    func deleteTask(_ task: TaskItem) async {
        await context.perform {
            self.context.delete(task)
        }
        await saveContext()
        await fetchTasks()
    }

    func toggleCompletion(_ task: TaskItem) async {
        await context.perform {
            task.isCompleted.toggle()
        }
        await saveContext()
    }
    
    func shareTask(_ task: TaskItem, completion: @escaping (UIActivityViewController) -> Void) {
        let shareContent = """
        \(task.title ?? "Без названия")

        \(task.desc ?? "Без описания")
        """
        
        let activityController = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
        completion(activityController)
    }

    private func saveContext() async {
        await context.perform {
            do {
                try self.context.save()
            } catch {
                print("Ошибка при сохранении контекста: \(error.localizedDescription)")
            }
        }
    }
}
