//
//  ToDoNetworkService.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import Foundation
import Alamofire
import CoreData

class ToDoNetworkService {
    static let shared = ToDoNetworkService()

    let baseURL = "https://dummyjson.com/todos"
    private let firstLaunchKey = "isFirstLaunch"

    func fetchTasks(context: NSManagedObjectContext, completion: @escaping (Result<[TaskItem], Error>) -> Void) {
        if isFirstLaunch() {
            // Выполняем загрузку данных из сети только при первом запуске
            AF.request(baseURL).responseDecodable(of: DummyResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("Данные успешно загружены с API: \(data.todos.count) задач")
                    let todos = data.todos.map { self.createTask(from: $0, context: context) }
                    self.saveContext(context)
                    print("Данные сохранены в Core Data")
                    self.setFirstLaunchCompleted()
                    completion(.success(todos))
                case .failure(let error):
                    print("Ошибка при загрузке данных с API: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        } else {
            // Если не первый запуск, возвращаем данные из Core Data
            let fetchRequest: NSFetchRequest<TaskItem> = TaskItem.fetchRequest()
            do {
                let tasks = try context.fetch(fetchRequest)
                completion(.success(tasks))
            } catch {
                print("Ошибка при загрузке данных из Core Data: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    private func isFirstLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: firstLaunchKey)
    }

    private func setFirstLaunchCompleted() {
        UserDefaults.standard.set(true, forKey: firstLaunchKey)
    }

    private func createTask(from dummyItem: DummyToDoItem, context: NSManagedObjectContext) -> TaskItem {
        print("Создаем задачу для Core Data: \(dummyItem.todo)")
        let task = TaskItem(context: context)
        task.title = dummyItem.todo
        task.desc = "С Api не приходит description"
        task.isCompleted = dummyItem.completed
        task.created = Date()
        return task
    }

    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении контекста: \(error.localizedDescription)")
        }
    }
}

// Структура JSON

struct DummyResponse: Codable {
    let todos: [DummyToDoItem]
}

struct DummyToDoItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
