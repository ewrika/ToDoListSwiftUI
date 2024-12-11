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
    private let taskManager: TaskManager

    @Published var tasks: [TaskItem] = []

    init(context: NSManagedObjectContext) {
        self.context = context
        self.taskManager = TaskManager(context: context)
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
           await taskManager.addTask(title: title, description: description)
           await fetchTasks()
       }

       func editTask(_ task: TaskItem, title: String, description: String) async {
           await taskManager.editTask(task, title: title, description: description)
           await fetchTasks()
       }

       func deleteTask(_ task: TaskItem) async {
           await taskManager.deleteTask(task)
           await fetchTasks()
       }

       func toggleCompletion(_ task: TaskItem) async {
           await taskManager.toggleCompletion(task)
       }

}
