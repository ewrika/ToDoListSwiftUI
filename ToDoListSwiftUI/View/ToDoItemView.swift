//
//  ToDoItemView.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import SwiftUI

struct ToDoItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var taskViewModel: TaskViewModel
    let task: TaskItem
    @State private var activityController: UIActivityViewController?
    @State private var isSharing = false
    @State var isCompleted: Bool
    let title: String
    let description: String
    let date: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Button(action: {
                isCompleted.toggle()
                taskViewModel.toggleCompletion(task)
            }) {
                Image(systemName: isCompleted ? "checkmark.circle" : "circle")
                    .foregroundColor(isCompleted ? .yellow : .gray)
                    .font(.system(size: 24))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.Medium16)
                    .strikethrough(isCompleted, color: .gray)
                    .opacity(isCompleted ? 0.5 : 1.0)
                Text(description)
                    .lineLimit(2)
                    .font(.Regular12)
                    .opacity(isCompleted ? 0.5 : 1.0)
                Text(date)
                    .font(.Regular12)
                    .opacity(0.5)
            }

        }
        .contextMenu {
            NavigationLink(destination: DetailedView(task: task)) {
                Button {
                    print("Редактировать задачу")

                } label: {
                    Label("Редактировать", systemImage: "pencil")
                }
            }
            Button {
                print("Поделиться задачей")
                shareTask()
            } label: {
                Label("Поделиться", systemImage: "square.and.arrow.up")
            }

            Button(role: .destructive) {
                deleteTask()
            } label: {
                Label("Удалить задачу", systemImage: "trash")
            }
        }
        .sheet(isPresented: $isSharing, content: {
              if let activityController = activityController {
                  ShareSheetWrapper(activityController: activityController)
              }
          })
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.horizontal, 20)
    }

    private func toggleCompletion() {
        taskViewModel.toggleCompletion(task)
    }

    private func deleteTask() {
        taskViewModel.deleteTask(task)
    }
    
    private func shareTask() {
        taskViewModel.shareTask(task) { activityController in
            self.activityController = activityController
            self.isSharing = true
        }
    }
    
}


struct ShareSheetWrapper: UIViewControllerRepresentable {
    let activityController: UIActivityViewController

    func makeUIViewController(context: Context) -> UIActivityViewController {
        activityController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
