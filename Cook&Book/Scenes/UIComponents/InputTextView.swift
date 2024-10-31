//
//  InputTextView.swift
//  Cook&Book
//
//  Created by Мирсаит Сабирзянов on 20.10.2024.
//

import Foundation
import SwiftUI

struct InputTextView: View {
    @Binding var input: String
    var text: String
    @State var number: Int? = nil
    @State var date: Date = .now
    @State var time: Date = .now
    @State var hours: Int = 0
    @State var minutes: Int = 0
    var mode: TextFieldMode
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .foregroundStyle(.black)
                .font(.inter(.interMedium))
            switch mode {
            case .ordinary:
                TextField(text, text: $input)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .font(.system(size: 25, design: .rounded))
                    .background(.clear)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(.next)
            case .secure:
                SecureField("**********", text: $input)
                    .background(.clear)
                    .font(.system(size: 25, design: .rounded))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(.next)
            case .numeric:
                TextField(text, value: $number.onChange(ageChanged), format: .number)
                    .keyboardType(.numberPad)
                    .background(.clear)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .font(.system(size: 25, design: .rounded))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .submitLabel(.next)
            case .date:
                DatePicker(text, selection: $date.onChange(dateChanged))

            case .time:
                HStack {
                    Picker("", selection: $hours.onChange(timeChanged)){
                        ForEach(0...100, id: \.self) { i in
                            Text("\(i) hours").tag(i)
                        }
                    }.pickerStyle(WheelPickerStyle())
                    Picker("", selection: $minutes.onChange(timeChanged)){
                        ForEach(0..<60, id: \.self) { i in
                            Text("\(i) min").tag(i)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                .frame(height: 100)
                .padding(.horizontal)
            }
        }
    }
    
    func ageChanged(to value: Int?) {
        guard let age = value else { return }
        input = String(age)
    }
    
    func dateChanged(to value: Date) {
        input = date.timeIntervalSince1970.description
    }
    
    func timeChanged(to value: Int) {
        input = "\(hours*3600 + minutes*60)"
        print(input)
    }
}

#Preview {
    InputTextView(input: .constant(""), text: "Time", mode: .time)
}

enum TextFieldMode {
    case ordinary
    case secure
    case numeric
    case date
    case time
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
