//
//  MessagesSearchBar.swift
//  ToDoListSwiftUI
//
//  Created by Георгий Борисов on 09.12.2024.
//

import SwiftUI

struct MessagesSearchBar: View {
    @Binding var searchText: String
  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.gray)
        .padding(.leading, 8)

      TextField("Search", text: $searchText)
        .padding(EdgeInsets(top: 7, leading: 0, bottom: 7, trailing: 7))
        .modifier(TrailingIcon(icon: "mic.fill"))
    }
    .background(Color(.systemGray6))
    .cornerRadius(8)
    .padding(.horizontal, 20)
    .padding(.bottom, 16)
  }
}

struct TrailingIcon: ViewModifier {
 let icon: String
 func body(content: Content) -> some View {
    ZStack(alignment: .trailing) {
      content
      Image(systemName: icon)
        .foregroundColor(.gray)
        .padding(.trailing, 8)
    }
 }
}
