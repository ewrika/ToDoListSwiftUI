//
//  ContentView.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject private var taskViewModel: TaskViewModel

    @FetchRequest(
        entity: TaskItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.created, ascending: true)],
        animation: .default
    ) private var tasks: FetchedResults<TaskItem>

    init(taskViewModel: TaskViewModel) {
        _taskViewModel = StateObject(wrappedValue: taskViewModel)
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    MessagesSearchBar()
                    // Отображение задач
                    ForEach(tasks) { task in
                        ToDoItemView(
                            isCompleted: task.isCompleted,
                            title: task.title ?? "Без названия",
                            description: task.desc ?? "",
                            date: task.created?.formatted(date: .abbreviated, time: .omitted) ?? "Без даты"
                        )
                        Divider()
                    }
                }
                FooterView(taskCount: tasks.count)
            }
            .navigationTitle("Задачи")
        }
    }
}



