//
//  DetailedView.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import SwiftUI

struct DetailedView: View {
    @State private var title: String = "Заняться спортом"
    @State private var description: String = "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике."

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {
            // Пока не решил как правильно реализовать
            Button(action: {

             }) {
                 HStack {
                     Image(systemName: "arrow.left")
                     Text("Назад")
                 }
                 .foregroundColor(.yellow)
             }

            TextField("Заголовок", text: $title)
               .font(.Bold34)
                .fontWeight(.bold)
                .textFieldStyle(PlainTextFieldStyle())

            Text("02/10/24")
                .font(.Regular12)
                .foregroundColor(.gray)

            TextEditor(text: $description)
                .frame(maxHeight: .infinity)
                .foregroundColor(.primary)
                .font(.Regular16)
                .padding(.horizontal, -4)
        }
        .padding()
    }
}

#Preview {
    DetailedView()
}

