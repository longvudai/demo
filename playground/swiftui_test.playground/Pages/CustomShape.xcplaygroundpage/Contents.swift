import SwiftUI
import PlaygroundSupport
import Combine

struct LetterB: Shape {
    let width: CGFloat = 20
    func path(in rect: CGRect) -> Path {
        Path { path in
//            path.move(to: CGPoint(x: rect.size.width/2, y: 0))
//            path.addLine(to: CGPoint(x: 0, y: 0))
//            path.addLine(to: CGPoint(x: 0, y: rect.size.width/2))
//            path.addLine(to: CGPoint(x: rect.size.width/2, y: rect.size.width/2))
//            path.move(to: CGPoint(x: 0, y: rect.size.width/2))
//            path.addLine(to: CGPoint(x: 0, y: rect.size.width))
//            path.addLine(to: CGPoint(x: rect.size.width/2, y: rect.size.width))
            
            path.addArc(
                center: CGPoint(x: rect.size.width/2, y: rect.size.height/2),
                radius: rect.size.width/2,
                startAngle: .degrees(-20),
                endAngle: .degrees(20),
                clockwise: true
            )
            
            path.addArc(
                center: CGPoint(x: rect.size.width + (rect.size.width - 2)/2, y: rect.size.width/2),
                radius: rect.size.width/2,
                startAngle: .degrees(-20),
                endAngle: .degrees(20),
                clockwise: true
            )
//            path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.width/4), radius: rect.size.width/4, startAngle: .degrees(90), endAngle: .degrees(270), clockwise: true)
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            LetterB()
                .stroke(lineWidth: 12)
                .foregroundColor(.green)
                .frame(width: 100, height: 100)
        }
    }
}

PlaygroundPage.current.setLiveView(
    ContentView()
        .frame(width: 100, height: 100)
)
