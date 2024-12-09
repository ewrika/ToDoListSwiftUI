//
//  FooterView.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import SwiftUI

struct FooterView: View {
    let taskCount: Int
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            (colorScheme == .light ? Color(.lightGray) : Color.figmaGray)
                .ignoresSafeArea()
            // Тк не было дизайна для светлой темы, решил поставить такой цвет для поддержки любой темы

            HStack(alignment: .center) {
                Spacer()

                Text("\(taskCount) Задач")
                    .font(.Regular12)

                Spacer()

                NavigationLink(destination: DetailedView()) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.figmaYellow)
                        .font(.system(size: 22))
                }
            }
            .padding(.horizontal, 16)
        }.ignoresSafeArea()
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 50)
    }
}

#Preview {
    FooterView(taskCount: 7)
        .previewLayout(.sizeThatFits)
}
