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
        ToDoNetworkService.shared.fetchTasks(context: context) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self.tasks = tasks
                case .failure(let error):
                    print("Ошибка загрузки задач: \(error.localizedDescription)")
                }
            }
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
        print("Редактируем задачу: \(task.title ?? "Без названия")")
        await context.perform {
            task.title = title
            task.desc = description
        }
        await saveContext()
        await fetchTasks()
    }

    func deleteTask(_ task: TaskItem) async {
        print("Удаляем задачу: \(task.title ?? "Без названия")")
        await context.perform {
            self.context.delete(task)
        }
        await saveContext()
        await fetchTasks()
    }

    func toggleCompletion(_ task: TaskItem) async {
        print("Переключаем статус выполнения задачи: \(task.title ?? "Без названия")")
        await context.perform {
            task.isCompleted.toggle()
        }
        await saveContext()
    }

    func shareTask(_ task: TaskItem, completion: @escaping (UIActivityViewController) -> Void) {
        print("Поделились задачей: \(task.title ?? "Без названия")")
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
                print("Ошибка при сохранении : \(error.localizedDescription)")
            }
        }
    }
}
