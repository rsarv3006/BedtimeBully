//
//  RoundedBorderView.swift
//  ConstructionEquations
//
//  Created by Robert J. Sarvis Jr on 3/19/24.
//

import SwiftUI

struct CustomizableRoundedBorderView: ViewModifier {
    var isDisabled: Bool
    let enabledColor: Color
    let disabledColor: Color
   
    init(isDisabled: Bool = false, enabledColor: Color = .accentColor, disabledColor: Color = .gray) {
        self.isDisabled = isDisabled
        self.enabledColor = enabledColor
        self.disabledColor = disabledColor
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(isDisabled ? disabledColor : enabledColor)
            .padding([.horizontal, .vertical], 8)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isDisabled ? disabledColor : enabledColor, lineWidth: 1)
                    .shadow(radius: 8, x: 2, y: 4)
            )
            .cornerRadius(10)
    }
}

struct RoundedBorderView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(CustomizableRoundedBorderView(isDisabled: false))
    }
}

#Preview {
    VStack {
        Text("Sign Up")
            .modifier(RoundedBorderView())
        
        Text("Hello")
            .modifier(CustomizableRoundedBorderView(isDisabled: true))
    }
}
