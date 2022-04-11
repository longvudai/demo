//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import SwiftUI

struct ContentView: View {
    @State private var text = "text"
    @State private var height: CGFloat = 0
    private let minHeight: CGFloat = 150
    
    var body: some View {
        ScrollView {
            VStack {
                ExpandingTextView(
                    text: $text,
                    height: $height,
                    minHeight: 150,
                    configuration: .init(
                        font: .systemFont(ofSize: 20),
                        lineSpacing: 3
                    )
                )
                
            }
            .padding()
            .frame(alignment: .top)
            .background(backgroundView)
        }
    }
    
    private var backgroundView: some View {
        VStack {
            Color.red
        }
        .frame(height: max(height, minHeight), alignment: .top)
    }
}

/// https://shadowfacts.net/2020/swiftui-expanding-text-view/
struct ExpandingTextView: View {
    @Binding var text: String
    @Binding var height: CGFloat
    var minHeight: CGFloat
    let configuration: Configuration

    var body: some View {
        WrappedTextView(
            text: $text,
            height: $height,
            configuration: configuration
        )
            .frame(height: max(height, minHeight))
            .animation(.easeOut(duration: 0.1), value: height)
    }
}

struct Configuration {
    var font: UIFont = .systemFont(ofSize: 17)
    var lineSpacing: CGFloat = 3
}

struct WrappedTextView: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var height: CGFloat
    let configuration: Configuration
    
    init(
        text: Binding<String>,
        height: Binding<CGFloat>,
        configuration: Configuration
    ) {
        self._text = text
        self._height = height
        self.configuration = configuration
    }
    
    private var attributes: [NSAttributedString.Key: Any] {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = configuration.lineSpacing
        let attributes = [
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.font: configuration.font
        ]
        return attributes
    }

    func makeUIView(context: Context) -> UITextView {
        print("makeUIView")
        let view = UITextView()
        view.isScrollEnabled = false
        view.isEditable = true
        view.delegate = context.coordinator
        view.textContainerInset = .zero
        view.attributedText = NSAttributedString(string: text, attributes: attributes)
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
//            DispatchQueue.main.async {
//                self.textDidChange(uiView)
//            }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(
            text: $text,
            height: $height,
            attributes: attributes
        )
    }

    class Coordinator: NSObject, UITextViewDelegate {
        @Binding var text: String
        @Binding var height: CGFloat
        var attributes: [NSAttributedString.Key: Any]

        init(
            text: Binding<String>,
            height: Binding<CGFloat>,
            attributes: [NSAttributedString.Key: Any]
        ) {
            self._text = text
            self._height = height
            self.attributes = attributes
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text
            
            let fixedWidth = textView.frame.size.width
            let expectedSize = CGSize(width: fixedWidth, height: .greatestFiniteMagnitude)
            let newSize = textView.sizeThatFits(expectedSize)
            self.height = newSize.height
        }
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.setLiveView(
    ContentView()
        .frame(width: 300, height: 500)
        .background(Color.gray)
)
