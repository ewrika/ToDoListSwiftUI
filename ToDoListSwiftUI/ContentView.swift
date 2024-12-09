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
        sortDescriptors: [NSSortDescriptor(keyPath: \TaskItem.created, ascending: true)],
        animation: .default
    ) 
    private var tasks: FetchedResults<TaskItem>
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    MessagesSearchBar()
                    ForEach(tasks) { task in
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




