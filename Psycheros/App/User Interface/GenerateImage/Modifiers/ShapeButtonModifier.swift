import SwiftUI

struct ShapeButtonModifier<S: Shape>: ViewModifier {
    let shape: S
    let action: () -> Void
    
    func body(content: Content) -> some View {
        Button(action: action) {
            content
                .padding(16)
                .foregroundStyle(.white)
                .background(Color.accentColor.opacity(0.2))
                .clipShape(shape)
        }
        .blurBackground(effect: .systemUltraThinMaterial)
        .clipShape(shape)
        .shadow(color: .black.opacity(0.5), radius: 10, x: 10, y: 10)
        .shadow(color: .white.opacity(0.5), radius: 10, x: -5, y: -5)
    }
}

extension View {
    func shapeButtonModifier<S: Shape>(
        shape: S = Circle(),
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(ShapeButtonModifier(shape: shape, action: action))
    }
}