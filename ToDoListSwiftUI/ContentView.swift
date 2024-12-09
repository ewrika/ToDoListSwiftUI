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
                        let taskViewModel = TaskViewModel(context: viewContext)
                        NavigationLink(destination: DetailedView(task: task)) {
                            ToDoItemView(
                                taskViewModel: taskViewModel, task: task,
                                isCompleted: task.isCompleted,
                                title: task.title ?? "Без названия",
                                description: task.desc ?? "",
                                date: task.created?.formatted(date: .abbreviated, time: .omitted) ?? "Без даты"
                            )
                        }.buttonStyle(PlainButtonStyle())
                        Divider()
                    }
                }
                FooterView(taskCount: tasks.count)
            }
            .navigationTitle("Задачи")
        }
    }
}
