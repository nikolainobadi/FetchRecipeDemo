//
//  EmptyListViewModifer.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

struct EmptyListViewModifer: ViewModifier {
    let isEmpty: Bool
    let title: String
    let systemImage: String
    let description: String
    
    func body(content: Content) -> some View {
        if isEmpty {
            ContentUnavailableView(title, systemImage: systemImage, description: Text(description))
        } else {
            content
        }
    }
}

extension View {
    func handlingEmptyList(when isEmpty: Bool, title: String, systemImage: String = "fork.knife", description: String) -> some View {
        modifier(EmptyListViewModifer(isEmpty: isEmpty, title: title, systemImage: systemImage, description: description))
    }
}
