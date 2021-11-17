import SwiftUI

private let navigationBarHeight: CGFloat = 44

public struct HeaderScrollView: View {
    @Environment(\.colorScheme)
    private var colorScheme: ColorScheme

    let title: String
    let titleColor: Color
    let headerHeight: CGFloat
    let scrollUpBehavior: ScrollUpHeaderBehavior
    let scrollDownBehavior: ScrollDownHeaderBehavior
    let header: AnyView
    let content: AnyView
    
    @State private var headerZIndex: Double = 0

    public var body: some View {
        GeometryReader { globalGeometry in
            ScrollView {
                VStack(spacing: 0) {
                    GeometryReader { geometry -> AnyView in
                        let geometry = self.geometry(from: geometry, safeArea: globalGeometry.safeAreaInsets)
                        let headerHeight = geometry.elementsHeight < navigationBarHeight ? max(geometry.elementsHeight, navigationBarHeight) : geometry.headerHeight
                        DispatchQueue.main.async {
                            headerZIndex = geometry.elementsHeight < navigationBarHeight ? 999 : -1
                        }

                        return AnyView(
                            self.header
                                .frame(width: geometry.width, height: headerHeight)
                                .clipped()
                                .offset(y: geometry.headerOffset)
                        )
                    }
                    .frame(width: globalGeometry.size.width, height: self.headerHeight)
                    .zIndex(headerZIndex)

                    GeometryReader { geometry -> AnyView in
                        let geometry = self.geometry(from: geometry, safeArea: globalGeometry.safeAreaInsets)
                        return AnyView(
                            ZStack {
                                BlurView()
                                    .opacity(1 - sqrt(geometry.largeTitleWeight))
                                    .offset(y: geometry.blurOffset)

                                VStack {
                                    HStack {
                                        BackButton(color: .white)
                                        Spacer()
                                    }
                                    .frame(width: geometry.width, height: navigationBarHeight)
                                    
                                    Spacer()

                                }
                                .padding(.top, globalGeometry.safeAreaInsets.top)
                                .frame(width: geometry.width, height: max(geometry.elementsHeight, navigationBarHeight), alignment: .top)
                                .offset(y: geometry.elementsOffset)
                            }
                        )
                    }
                    .frame(width: globalGeometry.size.width, height: self.headerHeight)
                    .zIndex(1_000)
                    .offset(y: -self.headerHeight)

                    self.content
                        .background(Color.background(colorScheme: self.colorScheme))
                        .offset(y: -self.headerHeight)
                        .padding(.bottom, -self.headerHeight)
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarHidden(true)
        .hackNavigationToAllowSwipeBackWhenHidden()
    }
}

extension HeaderScrollView {
    private struct HeaderScrollViewGeometry {
        let width: CGFloat
        let headerHeight: CGFloat
        let elementsHeight: CGFloat
        let headerOffset: CGFloat
        let blurOffset: CGFloat
        let elementsOffset: CGFloat
        let largeTitleWeight: Double
    }

    private func geometry(from geometry: GeometryProxy, safeArea: EdgeInsets) -> HeaderScrollViewGeometry {
        let minY = geometry.frame(in: .global).minY
        let hasScrolledUp = minY > 0
        let hasScrolledToMinHeight = -minY >= headerHeight - navigationBarHeight - safeArea.top

        let headerHeight = hasScrolledUp && scrollUpBehavior == .parallax ?
            geometry.size.height + minY : geometry.size.height

        let elementsHeight = hasScrolledUp && scrollUpBehavior == .sticky ?
            geometry.size.height : geometry.size.height + minY

        let headerOffset: CGFloat
        let blurOffset: CGFloat
        let elementsOffset: CGFloat
        let largeTitleWeight: Double

        
        if hasScrolledUp {
            headerOffset = -minY
            blurOffset = -minY
            elementsOffset = -minY
            largeTitleWeight = 1
        } else if hasScrolledToMinHeight {
            headerOffset = -minY
            blurOffset = -minY - (self.headerHeight - safeArea.top - navigationBarHeight)
//            elementsOffset = -minY - (self.headerHeight - navigationBarHeight - safeArea.top) / 2
            elementsOffset = max(-minY / 2, -minY - (self.headerHeight - navigationBarHeight) / 2)
            largeTitleWeight = 0
        } else {
            headerOffset = scrollDownBehavior == .sticky ? -minY : 0
            blurOffset = 0
            elementsOffset = -minY / 2
            let difference = self.headerHeight - navigationBarHeight - safeArea.top + minY
            largeTitleWeight = difference <= navigationBarHeight + 1 ?
                Double(difference / (navigationBarHeight + 1)) : 1
        }
        print("hasScrolledToMinHeight: \(hasScrolledToMinHeight), -minY:\(-minY), elementsOffset: \(elementsOffset), headerOffset: \(headerOffset), x: \(navigationBarHeight + safeArea.top)")

        return HeaderScrollViewGeometry(
            width: geometry.size.width,
            headerHeight: headerHeight,
            elementsHeight: elementsHeight,
            headerOffset: headerOffset,
            blurOffset: blurOffset,
            elementsOffset: elementsOffset,
            largeTitleWeight: largeTitleWeight
        )
    }
}

extension Color {
    static func background(colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .dark:
            return .black
        case .light:
            fallthrough
        @unknown default:
            return .white
        }
    }
}
