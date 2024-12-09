//
//  ContentView.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
                VStack {
                    ScrollView {

                        MessagesSearchBar()

                        ToDoItemView(isCompleted: false, title: "dsa", description: "ds", date: "21042003")
                            Divider()
                        
                    }
                    FooterView(taskCount:7)
                }
            .navigationTitle("Задачи")
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)

}
