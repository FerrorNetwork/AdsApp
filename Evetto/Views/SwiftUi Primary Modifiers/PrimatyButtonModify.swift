import SwiftUI

public extension ButtonStyle where Self == PrimaryActionButtonStyle {
    static var primaryAction: PrimaryActionButtonStyle {
        PrimaryActionButtonStyle()
    }
}

public struct PrimaryActionButtonStyle: ButtonStyle {

    public init() {}

    @Environment(\.isEnabled) private var isEnabled: Bool

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Font.headline)
            .frame(maxWidth: .infinity)
            .foregroundColor(Color.white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(12)
            .opacity(configuration.isPressed || !isEnabled ? 0.5 : 1)
            .shadow(color: Color.accentColor.opacity(0.3), radius: 15, x: 0, y: 7)
    }

}

struct PrimaryActionButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: { print("Pressed") }) {
            Text("Press Me")
        }
        .buttonStyle(.primaryAction)
    }
}
