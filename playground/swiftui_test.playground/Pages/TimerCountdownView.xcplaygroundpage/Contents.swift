import SwiftUI
import PlaygroundSupport
import Combine

struct SessionProgressView: View {
    @Binding var progress: Double
    var lineWidth: CGFloat = 2
    var size: CGSize = CGSize(width: 20, height: 20)
    
    var body: some View {
        Circle()
            .fill(.clear)
            .frame(width: size.width, height: size.height)
            .overlay {
                if progress <= 0 {
                    Circle()
                        .strokeBorder(Color.gray, lineWidth: 2)
                } else {
                    Circle()
                        .strokeBorder(Color.blue, lineWidth: 2)
                        .overlay(
                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(Color.blue, lineWidth: 20)
                                .rotationEffect(.degrees(-90))
                        )
                }
            }
            .clipShape(Circle())
    }
}

PlaygroundPage.current.setLiveView(
    VStack {
        SessionProgressView(progress: .constant(0))
        SessionProgressView(progress: .constant(0.7))
    }
        .frame(width: 300, height: 300)
)
