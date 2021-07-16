import UIKit
import RxSwift

let disposeBag = DisposeBag()

//example(of: "test observer") {
//    let observable1 = Observable.of(0, 1, 2)
//
//    observable1
//        .subscribe { value in
//        print(value)
//    }
//    .disposed(by: disposeBag)
//}
//
//example(of: "defered") {
//    var isFlip = false
//    let deferredObserver = Observable<Int>.deferred {
//        isFlip.toggle()
//
//        if isFlip {
//            return Observable.of(1, 2, 3)
//        } else {
//            return Observable.of(4, 5, 6)
//        }
//    }
//
//    for _ in 0...3 {
//        deferredObserver.subscribe { value in
//            print(value)
//        }.disposed(by: disposeBag)
//    }
//}

// MARK: - Traits
//example(of: "traits-single") {
//    let singleObservable = Single<Int>.create { singleObserver in
//        singleObserver(.success(1))
//        return Disposables.create()
//    }
//
//    singleObservable.subscribe { success in
//        print(success)
//    } onFailure: { error in
//        print(error.localizedDescription)
//    }.disposed(by: disposeBag)
//}

//example(of: "never") {
//    let observable = Observable<Any>.of(1, 2, 3)
//
//  observable
//    .do(onNext: { v in
//        print("side effect", v)
//    }, onSubscribe: {
//        print("do subscribe")
//    }, onSubscribed: {
//        print("do subscribed")
//    })
//    .debug("--debug", trimOutput: false)
//    .subscribe(
//      onNext: { element in
//        print(element)
//      },
//      onCompleted: {
//        print("Completed")
//      },
//      onDisposed: {
//        print("Disposed")
//      }
//    )
//}

//example(of: "subscribe") {
//    let triggerObservable = Observable<Bool>.create { observer in
//        observer.onNext(true)
//        return Disposables.create()
//    }
//
//    triggerObservable
//        .skip { !$0 }
//        .subscribe { value in
//            print(value)
//        } onCompleted: {
//            print("completed")
//        } onDisposed: {
//            print("disposed")
//        }
////        .disposed(by: disposeBag)
//
//}

example(of: "scan1") {
    let sequence = Observable.of(1, 3, 5, 7, 9)
    let scanSequence = sequence
        .scan((0, 0)) {acc, value in
            return (value, acc.1 + value)
        }
        .subscribe { event in
            print(event)
        }
}
