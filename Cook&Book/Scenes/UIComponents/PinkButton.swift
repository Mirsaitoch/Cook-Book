//
//  BlackButton.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import SwiftUI

struct PinkButton: View {
    var text: String
    var action: () -> Void
    var body: some View {
        Capsule()
            .fill(.newPink)
            .frame(width: 350, height: 35)
            .overlay{
                Text(text)
                    .font(.inter(.interBold, size: 20))
                    .foregroundStyle(.newRed)
            }
            .padding(.horizontal)
            .onTapGesture {
                action()
            }
    }
}

#Preview {
    PinkButton(text: "Log in") {
        
    }
}
