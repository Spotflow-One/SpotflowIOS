//
//  IndeterminateLinearProgressView.swift
//  SpotFlowPlayground
//
//  Created by Nkwachi Nwamaghinna on 30/07/2024.
//

import SwiftUI

struct IndeterminateProgressView: View {
    @State private var width: CGFloat = 0
    @State private var offset: CGFloat = 0
  
    var body: some View {
        Rectangle()
            .foregroundColor(.gray.opacity(0.15))
            .readWidth()
            .overlay(
                Rectangle()
                    .foregroundColor(.green)
                    .frame(width: self.width * 0.26, height: 6)
                    .clipShape(Capsule())
                    .offset(x: -self.width * 0.6, y: 0)
                    .offset(x: self.width * 1.2 * self.offset, y: 0)
                    .animation(.default.repeatForever().speed(0.565), value: self.offset)
                    .onAppear{
                        withAnimation {
                            self.offset = 1
                        }
                    }
            )
            .clipShape(Capsule())
            .opacity(1)
            .animation(.default, value: true)
            .frame(height: 6)
            .onPreferenceChange(WidthPreferenceKey.self) { width in
                self.width = width
            }
    }
}

struct WidthPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private struct ReadWidthModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }

    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}

extension View {
    func readWidth() -> some View {
        self
            .modifier(ReadWidthModifier())
    }
}

#Preview {
    IndeterminateProgressView()
}
