//
//  EmptyListViewModifer.swift
//  FetchRecipeDemo
//
//  Created by Nikolai Nobadi on 4/11/25.
//

import SwiftUI

struct EmptyListViewModifier: ViewModifier {
    let isEmpty: Bool
    let title: String
    let systemImage: String
    let description: String

    func body(content: Content) -> some View {
        if isEmpty {
            if #available(iOS 17.0, *) {
                ContentUnavailableView(title, systemImage: systemImage, description: Text(description))
            } else {
                VStack(spacing: 12) {
                    Image(systemName: systemImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.secondary)

                    Text(title)
                        .font(.title2)
                        .bold()

                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        } else {
            content
        }
    }
}

extension View {
    func handlingEmptyList(when isEmpty: Bool, title: String, systemImage: String = "fork.knife", description: String) -> some View {
        modifier(EmptyListViewModifier(isEmpty: isEmpty, title: title, systemImage: systemImage, description: description))
    }
}
