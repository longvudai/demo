import UIKit
import RxSwift
import RxCocoa

let elementsPerSecond = 1
let delay: RxTimeInterval = .milliseconds(2500)

let sourceObservable = PublishSubject<Int>()

let sourceTimeline = TimelineView<Int>.make()
let delayedTimeline = TimelineView<Int>.make()

let stack = UIStackView.makeVertical([
  UILabel.makeTitle("delay"),
  UILabel.make("Emitted elements (\(elementsPerSecond) per sec.):"),
  sourceTimeline,
  UILabel.make("Delayed elements (with a \(delay)s delay):"),
  delayedTimeline])

var current = 1

let timer = Observable
    .interval(.milliseconds(Int(1_000 / Double(elementsPerSecond))), scheduler: MainScheduler.instance)
    .subscribe(sourceObservable)

_ = sourceObservable.subscribe(sourceTimeline)


// Setup the delayed subscription
Observable<Int>.timer(.seconds(3), scheduler: MainScheduler.instance)
    .debug("timer1", trimOutput: true)
    .flatMap { _ in
        sourceObservable
            .delaySubscription(delay, scheduler: MainScheduler.instance)
    }
    .debug("timer", trimOutput: true)
    .subscribe(delayedTimeline)

// Start coding here



let hostView = setupHostView()
hostView.addSubview(stack)
hostView


// Support code -- DO NOT REMOVE
class TimelineView<E>: TimelineViewBase, ObserverType where E: CustomStringConvertible {
  static func make() -> TimelineView<E> {
    let view = TimelineView(frame: CGRect(x: 0, y: 0, width: 400, height: 100))
    view.setup()
    return view
  }
  public func on(_ event: Event<E>) {
    switch event {
    case .next(let value):
      add(.next(String(describing: value)))
    case .completed:
      add(.completed())
    case .error(_):
      add(.error())
    }
  }
}
