import UIKit
import RxSwift
import RxCocoa


// Start coding here
let elementsPerSecond = 3
let windowTimeSpan: RxTimeInterval = .seconds(4)
let windowMaxCount = 10
let sourceObservable = PublishSubject<String>()

let sourceTimeline = TimelineView<String>.make()
let stack = UIStackView.makeVertical([
  UILabel.makeTitle("window"),
  UILabel.make("Emitted elements (\(elementsPerSecond) per sec.):"),
  sourceTimeline,
  UILabel.make("Windowed observables (at most \(windowMaxCount) every \(windowTimeSpan) sec):")
])

let hostView = setupHostView()
hostView.addSubview(stack)
hostView

let timer = DispatchSource.timer(interval: 1.0 / Double(elementsPerSecond), queue: .main) {
    sourceObservable.onNext(" ")
}

_ = sourceObservable.subscribe(sourceTimeline)

let window: Observable<Observable<String>> = sourceObservable
    .window(timeSpan: windowTimeSpan, count: windowMaxCount, scheduler: MainScheduler.instance)

let timeline: Observable<TimelineView> = window
    .map { _ in TimelineView<String>.make() }
    .do { timeline in
        // side effect
        stack.insert(timeline, at: 4)
        stack.keep(atMost: 8)
    }

let message = window
    .map { source -> Observable<String> in
        source.concat(Observable.just(""))
    }

Observable.zip(timeline, message)
    .flatMap { (timeline, string) in
        string.map { (timeline, $0) }
    }
    .subscribe(onNext: { (timeline, value) in
        // side effect
        if !value.isEmpty {
            timeline.add(.next(value))
        } else {
            timeline.add(.completed(true))
        }
    })

//_ = sourceObservable
//    .window(timeSpan: windowTimeSpan, count: windowMaxCount, scheduler: MainScheduler.instance)
//    .flatMap { windowedObservable -> Observable<(TimelineView<Int>, String?)> in
//        let timeline = TimelineView<Int>.make()
//            // side effect
//        stack.insert(timeline, at: 4)
//        stack.keep(atMost: 8)
//        return windowedObservable
//            .map { value in (timeline, value) }
//            .concat(Observable.just((timeline, nil)))
//    }
//    .debug()
//    .subscribe(onNext: { tuple in
//        // side effect
//        let (timeline, value) = tuple
//        if let value = value {
//            timeline.add(.next(value))
//        } else {
//            timeline.add(.completed(true))
//        }
//    })


// Support code -- DO NOT REMOVE
class TimelineView<E>: TimelineViewBase, ObserverType where E: CustomStringConvertible {
  static func make() -> TimelineView<E> {
    let view = TimelineView(frame: CGRect(x: 0, y: 0, width: 400, height: 80))
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
