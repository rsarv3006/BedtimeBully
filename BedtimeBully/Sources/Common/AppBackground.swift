//
//  AppBackground.swift
//  BedtimeBully
//
//  Created by Robert J. Sarvis Jr on 4/28/24.
//

import SwiftUI

struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color("Background").ignoresSafeArea())
    }
}

extension View {
    func appBackground() -> some View {
        self.modifier(AppBackgroundModifier())
    }
}
