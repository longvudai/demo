//: A UIKit based Playground for presenting user interface
  
import Foundation
import PlaygroundSupport

private let dateComponentFormatter: DateComponentsFormatter = {
    let f = DateComponentsFormatter()
    f.maximumUnitCount = 1
    f.unitsStyle = .full
    f.zeroFormattingBehavior = .dropLeading
    f.allowedUnits = [.day]
    return f
}()

dateComponentFormatter.string(from: 86400 * 2)
