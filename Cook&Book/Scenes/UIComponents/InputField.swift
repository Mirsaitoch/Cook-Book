//
//  InputField.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 23.10.2024.
//

import SwiftUI

struct InputField: View {
    let label: String
    @Binding var text: String
    @State var isSecure = false
    
    var body: some View {
        VStack {
            HStack {
                Text(label)
                    .font(.inter(.interBold, size: 19))
                    .foregroundStyle(.myBlack)
                Spacer()
            }
            Group {
                if isSecure {
                    SecureField("**********", text: $text)
                } else {
                    TextField(label, text: $text)
                }
            }
            .foregroundStyle(.myBlack)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .frame(height: 35)
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 10).fill(.myWhite))
        }
        .padding(.horizontal)
    }
}
