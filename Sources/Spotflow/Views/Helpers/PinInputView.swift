//
//  PinInputView.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 29/07/2024.
//

import SwiftUI
import Combine


enum FocusField: Hashable {
    case field
}

extension String {
    public subscript(_ idx: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: idx)]
    }
}

public struct PinInputView: View {
    @State private var verificationCode = ""
    @FocusState private var focusedField: FocusField?
    
    var pinLength: Int = 4
    var keyboardType: UIKeyboardType = .numberPad
    var onComplete: (String) -> ()
    
    public var body: some View {
        ZStack(alignment: .center) {
            OTPTextField(verificationCode: $verificationCode, pinLength: pinLength, keyboardType: keyboardType) {
                onComplete(verificationCode)
            }
            HStack {
                ForEach(0..<pinLength, id: \.self) { index in
                    Text(getPin(at: index))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex:"6D6A73"))
                        .frame(width: 50, height: 50)
                        .overlay(   RoundedRectangle(cornerRadius: 4)
                            .stroke(getBorderColor(at: index), lineWidth: 0.5))
                }
            }
        }.onAppear{
            UITextField.appearance().clearButtonMode = .never
            UITextField.appearance().tintColor = UIColor.clear
        }
    }
    
    func getPin(at index: Int) -> String {
        guard self.verificationCode.count > index else {
            return ""
        }
        
        return String(verificationCode[index])
    }
    
    func getBorderColor(at index: Int) -> Color {
        if(index == 0 || !getPin(at: index).isEmpty) {
            return Color(hex: "01008E")
        }
        return Color(hex: "E6E6E7")
    }
    
    
}


struct OTPTextField: View {
        @FocusState private var keyboardFocusedField: FocusField?
        @Binding var verificationCode: String
        @State var isAllNumbersFilled:Bool = false
        
        var pinLength: Int = 6
        var keyboardType: UIKeyboardType = .numberPad
        var onComplete: () -> ()
        
        var body: some View {
            ZStack {
                TextField("", text: $verificationCode)
                    .frame(width: 0, height: 0, alignment: .center)
                    .font(Font.system(size: 0))
                    .accentColor(Color.black)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .keyboardType(keyboardType)
                    .focused($keyboardFocusedField, equals: .field)
                    .padding()
                    .task {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                        {
                            self.keyboardFocusedField = .field
                        }
                    }
                    .onReceive(Just(verificationCode)) { _ in
                        if verificationCode.count > pinLength {
                            verificationCode = String(verificationCode.prefix(pinLength))
                        }
                        
                        if verificationCode.count == pinLength && !isAllNumbersFilled {
                            isAllNumbersFilled = true
                            onComplete()
                        } else if verificationCode.count < pinLength {
                            isAllNumbersFilled = false
                        }
                    }
            }
        }
    }

    
#Preview{
    PinInputView(pinLength: 4, keyboardType: .default) { pin in
                       print(pin)
                   }
}


