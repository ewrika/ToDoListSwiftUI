//
//  TaskViewModel.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import Foundation
import CoreData
import SwiftUI

class TaskViewModel: ObservableObject {
    private let context: NSManagedObjectContext

    @Published var tasks: [TaskItem] = []

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchTasks()
    }

    func fetchTasks() {
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
    
    func shareTask(_ task: TaskItem, completion: @escaping (UIActivityViewController) -> Void) {
        let shareContent = """
        \(task.title ?? "Без названия")

        \(task.desc ?? "Без описания")
        """
        
        let activityController = UIActivityViewController(activityItems: [shareContent], applicationActivities: nil)
        completion(activityController)
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении контекста: \(error.localizedDescription)")
        }
    }
}
