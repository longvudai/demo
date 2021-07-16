import Foundation
import RxSwift
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

//example(of: "static concat") {
//    print("a")
//    let score1 = BehaviorSubject<Int>.init(value: 0)
//    let score2 = Observable.from([20, 21, 22])
//    Observable.concat([score1, score2])
//        .subscribe { event in
//            print(event)
//        }
//    score1.onNext(1)
////    score1.onCompleted()
//}

//example(of: "concatMap") {
//    let sequences = [
//        "German cities": Observable.of("Berlin", "Münich", "Frankfurt"),
//        "Spanish cities": Observable.of("Madrid", "Barcelona", "Valencia")
//    ]
//
//    let observable = Observable.of("German cities", "Spanish cities")
//        .concatMap { country in sequences[country] ?? .empty() }
//
//    _ = observable.subscribe(onNext: { string in
//        print(string)
//    })
//}

//Note: Last but not least, combineLatest completes only when the last of its inner sequences completes. Before that, it keeps sending combined values. If some sequences terminate, it uses the last value emitted to combine with new values from other sequences.
//example(of: "combineLatest") {
//    let sub1 = PublishSubject<Int>()
//    let sub2 = PublishSubject<Int>()
//
//    Observable.combineLatest(sub1, sub2).subscribe { event in
//        print(event)
//    }
//
//    sub2.onNext(2)
//    sub1.onNext(1)
//    sub1.onNext(3)
//    sub2.onCompleted()
//    sub1.onCompleted()
//}


//example(of: "sample") {
//  let button = PublishSubject<Void>()
//  let textField = PublishSubject<String>()
//
//  let observable = textField.sample(button)
//
//    _ = observable.subscribe(onNext: { value in
//    print(value)
//  })
//
//  textField.onNext("Par")
//  textField.onNext("Pari")
//    button.onNext(())
//  textField.onNext("Paris")
//  button.onNext(())
////    button.onNext(())
//}

example(of: "scan") {
    let source = Observable.of(1, 3, 5, 7, 9)
    let observable = source.scan(0, accumulator: +)
    
    _ = observable.subscribe(onNext: { value in
        print(value)
    })
}
