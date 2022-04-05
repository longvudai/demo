import Foundation
import SwiftUI

public enum TapePosition {
    case left
    case top
    case right
    case leftBottomRightTop
    case leftTopRightBottom
}

public struct TapeView: View {
    private var position: TapePosition
    private var tapeColor = Color.green.opacity(0.2)
    private var tapeHeight: CGFloat
    
    public init(position: TapePosition, color: Color, height: CGFloat) {
        self.position = position
        self.tapeColor = color
        self.tapeHeight = height
    }
    
    public var body: some View {
        GeometryReader { proxy -> ZStack in
            let tapeWidth = min(proxy.size.width / 2 - 30, 50)
            let offsetX: CGFloat = tapeWidth / 2 - 12
            let degrees: CGFloat = 45
            
            ZStack {
                switch position {
                case .top:
                    HStack {
                        tapeView
                            .frame(width: tapeWidth, height: tapeHeight)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                case .left:
                    HStack {
                        tapeView
                            .rotationEffect(.degrees(-degrees))
                            .offset(x: -offsetX)
                            .frame(width: tapeWidth, height: tapeHeight)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                case .right:
                    HStack {
                        tapeView
                            .rotationEffect(.degrees(degrees))
                            .offset(x: offsetX)
                            .frame(width: tapeWidth, height: tapeHeight)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                case .leftTopRightBottom:
                    VStack {
                        HStack {
                            tapeView
                                .rotationEffect(.degrees(-degrees))
                                .offset(x: -offsetX)
                                .frame(width: tapeWidth, height: tapeHeight)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            tapeView
                                .rotationEffect(.degrees(-degrees))
                                .offset(x: offsetX)
                                .frame(width: tapeWidth, height: tapeHeight)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
                case .leftBottomRightTop:
                    VStack {
                        HStack {
                            Spacer()
                            tapeView
                                .rotationEffect(.degrees(degrees))
                                .offset(x: offsetX)
                                .frame(width: tapeWidth, height: tapeHeight)
                        }
                        
                        Spacer()
                        
                        HStack {
                            tapeView
                                .rotationEffect(.degrees(degrees))
                                .offset(x: -offsetX)
                                .frame(width: tapeWidth, height: tapeHeight)
                            
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
        }
    }
    
    private var tapeView: some View {
        Rectangle()
            .fill(tapeColor)
    }
}
