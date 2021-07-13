import Foundation
import RxSwift

struct Student {
    var score: BehaviorSubject<Int>
}

let bag = DisposeBag()

//example(of: "flatMap") {
//    let longVu = Student(score: BehaviorSubject<Int>.init(value: 80))
//    let kimAnh = Student(score: BehaviorSubject<Int>.init(value: 90))
//
//    let studentSubject = PublishSubject<Student>()
//
//    studentSubject
//        .flatMap { student in
//            student.score
//        }
//        .subscribe { score in
//            print(score)
//        }
//        .disposed(by: bag)
//
//    studentSubject.onNext(longVu)
//    longVu.score.onNext(85)
//    studentSubject.onNext(kimAnh)
//    kimAnh.score.onNext(92)
//}

//example(of: "flatMapLastest") {
//    let longVu = Student(score: BehaviorSubject<Int>.init(value: 80))
//    let kimAnh = Student(score: BehaviorSubject<Int>.init(value: 90))
//
//    let studentSubject = PublishSubject<Student>()
//
//    studentSubject
//        .flatMapLatest { student in
//            student.score
//        }
//        .subscribe { score in
//            print(score)
//        }
//        .disposed(by: bag)
//
//    studentSubject.onNext(longVu)
//    studentSubject.onNext(kimAnh)
//    longVu.score.onNext(85)
//    longVu.score.onNext(90)
//    kimAnh.score.onNext(92)
//}

//example(of: "Challenge 1") {
//  let disposeBag = DisposeBag()
//
//  let contacts = [
//    "603-555-1212": "Florent",
//    "212-555-1212": "Shai",
//    "408-555-1212": "Marin",
//    "617-555-1212": "Scott"
//  ]
//
//  let convert: (String) -> Int? = { value in
//    if let number = Int(value),
//       number < 10 {
//      return number
//    }
//
//    let keyMap: [String: Int] = [
//      "abc": 2, "def": 3, "ghi": 4,
//      "jkl": 5, "mno": 6, "pqrs": 7,
//      "tuv": 8, "wxyz": 9
//    ]
//
//    let converted = keyMap
//      .filter { $0.key.contains(value.lowercased()) }
//      .map(\.value)
//      .first
//
//    return converted
//  }
//
//  let format: ([Int]) -> String = {
//    var phone = $0.map(String.init).joined()
//
//    phone.insert("-", at: phone.index(
//      phone.startIndex,
//      offsetBy: 3)
//    )
//
//    phone.insert("-", at: phone.index(
//      phone.startIndex,
//      offsetBy: 7)
//    )
//
//    return phone
//  }
//
//  let dial: (String) -> String = {
//    if let contact = contacts[$0] {
//      return "Dialing \(contact) (\($0))..."
//    } else {
//      return "Contact not found"
//    }
//  }
//
//  let input = PublishSubject<String>()
//
//  // Add your code here
//    input
//        .compactMap { convert($0) }
//        .filter { (0...9).contains($0) }
//        .skip { $0 == 0 }
//        .take(10)
//        .toArray()
//        .subscribe(onSuccess: { numbers in
//            let phoneNumber = format(numbers)
//            dial(phoneNumber)
//
//        }, onFailure: { error in
//            print(error.localizedDescription)
//        })
//        .disposed(by: disposeBag)
//
//
//
//  input.onNext("")
//  input.onNext("0")
//  input.onNext("408")
//
//  input.onNext("6")
//  input.onNext("")
//  input.onNext("0")
//  input.onNext("3")
//
//  "JKL1A1B".forEach {
//    input.onNext("\($0)")
//  }
//
//  input.onNext("9")
//}
//
