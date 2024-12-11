//
//  ContentView.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(
        entity: TaskItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.created, ascending: false)],
        animation: .default
    )
    private var tasks: FetchedResults<TaskItem>
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = TaskViewModel(context: PersistenceController.shared.container.viewContext)
    @State private var searchText = ""

    var filteredTasks: [TaskItem] {
        if searchText.isEmpty {
            return Array(tasks)
        } else {
            return tasks.filter { task in
                (task.title?.lowercased().contains(searchText.lowercased()) ?? false) ||
                (task.desc?.lowercased().contains(searchText.lowercased()) ?? false)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    MessagesSearchBar(searchText: $searchText)
                    ForEach(filteredTasks) { task in
                        let taskData = ToDoItemData(
                            title: task.title ?? "Без названия",
                            description: task.desc ?? "Без описания",
                            date: task.created?.formatted(date: .abbreviated, time: .omitted) ?? "Без даты"
                        )
                        NavigationLink(destination: DetailedView(task: task)) {
                            ToDoItemView(
                                taskViewModel: viewModel,
                                task: task,
                                isCompleted: task.isCompleted,
                                data: taskData
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        Divider()
                    }
                }
                FooterView(taskCount: tasks.count)
            }.onAppear {
                Task {
                    await viewModel.fetchTasks()
                }
            }
            .navigationTitle("Задачи")
        }
    }
}
