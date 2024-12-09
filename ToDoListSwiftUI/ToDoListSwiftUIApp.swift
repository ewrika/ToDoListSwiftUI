//
//  ToDoListSwiftUIApp.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import SwiftUI

@main
struct ToDoListSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let context = persistenceController.container.viewContext
            let taskViewModel = TaskViewModel(context: context) // Создаем ViewModel

            ContentView(taskViewModel: taskViewModel) // Передаем ViewModel
                .environment(\.managedObjectContext, context)
        }
    }
}
