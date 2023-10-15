import SwiftUI

private struct CroppedModifier: ViewModifier {
    
    let aspectRatio: Double
        
    func body(content: Content) -> some View {
        Rectangle()
            .aspectRatio(aspectRatio, contentMode: .fit)
            .overlay(
                content
                    .scaledToFill()
            )
            .clipped()
    }
}

extension View {
    func cropped(aspectRatio: Double = 1) -> some View {
        modifier(CroppedModifier(aspectRatio: aspectRatio))
    }
}
