import Foundation
import RxSwift

let bag = DisposeBag()
//example(of: "skipUntil") {
//    let subject = PublishSubject<Int>()
//    let trigger = PublishSubject<String>()
//
//    subject
//        .skip(until: trigger)
//        .subscribe { event in
//        print(event)
//    }
//        .disposed(by: bag)
//
//    subject.onNext(1)
//    subject.onNext(2)
//
//    trigger.onNext("start")
//
//    subject.onNext(3)
//}

//example(of: "distinctUntilChanged(_:)") {
//    let disposeBag = DisposeBag()
//
//    let formatter = NumberFormatter()
//    formatter.numberStyle = .spellOut
//    Observable<NSNumber>
//        .of(10, 110, 20, 200, 210, 310)
//        .distinctUntilChanged { a, b in
//            guard
//                let aWords = formatter.string(from: a)?.components(separatedBy: " "),
//                let bWords = formatter.string(from: b)?.components(separatedBy: " ") else {
//                return false
//            }
//            var containsMatch = false
//            for aWord in aWords where bWords.contains(aWord) {
//                containsMatch = true
//                break
//            }
//            return containsMatch
//        }
//        .subscribe(onNext: {
//             print($0)
//        })
//        .disposed(by: disposeBag)
//}


example(of: "Challenge 1") {
  let disposeBag = DisposeBag()
  
  let contacts = [
    "603-555-1212": "Florent",
    "212-555-1212": "Shai",
    "408-555-1212": "Marin",
    "617-555-1212": "Scott"
  ]
  
  func phoneNumber(from inputs: [Int]) -> String {
    var phone = inputs.map(String.init).joined()
    
    phone.insert("-", at: phone.index(
      phone.startIndex,
      offsetBy: 3)
    )
    
    phone.insert("-", at: phone.index(
      phone.startIndex,
      offsetBy: 7)
    )
    
    return phone
  }
  
  let input = PublishSubject<Int>()
  
  // Add your code here
    input
        .skip(while: { $0 == 0 })
        .filter { (0...10).contains($0) }
        .take(10)
        .toArray()
        .subscribe { digits in
            print(digits)
            let phoneNumber = phoneNumber(from: digits)
            if let person = contacts[phoneNumber] {
                print("Dialing to ", person)
            } else {
                print("Contact not found")
            }
        } onFailure: { error in
            print(error.localizedDescription)
        }.disposed(by: disposeBag)

  
  
  input.onNext(0)
  input.onNext(603)
  
  input.onNext(2)
  input.onNext(1)
  
  // Confirm that 7 results in "Contact not found",
  // and then change to 2 and confirm that Shai is found
  input.onNext(2)
  
  "5551212".forEach {
    if let number = (Int("\($0)")) {
      input.onNext(number)
    }
  }
  
  input.onNext(9)
}
