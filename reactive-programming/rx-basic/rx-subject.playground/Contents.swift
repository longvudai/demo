import UIKit
import RxSwift
import RxRelay

let disposeBag = DisposeBag()

//example(of: "Publish Subject") {
//    let publishSubject = PublishSubject<String>()
//    publishSubject.on(.next("first"))
//
//    let subscriber1 = publishSubject.subscribe { value in
//        print("1", value)
//    } onCompleted: {
//        print("1 completed")
//    }.disposed(by: disposeBag)
//
//    publishSubject.onNext("second")
//
//    let subscriber2 = publishSubject.subscribe { value in
//        print("2", value)
//    } onCompleted: {
//        print("2 completed")
//    }.disposed(by: disposeBag)
//
//    publishSubject.onCompleted()
//
//    let subscriber3 = publishSubject.subscribe { value in
//        print("3", value)
//    } onCompleted: {
//        print("3 completed")
//    }.disposed(by: disposeBag)
//}

//example(of: "chap 3: Challenge 1: blackjack card dealer") {
//    let dealtHand = PublishSubject<[(String, Int)]>()
//
//    func deal(_ cardCount: UInt) {
//      var deck = cards
//      var cardsRemaining = deck.count
//      var hand = [(String, Int)]()
//
//      for _ in 0..<cardCount {
//        let randomIndex = Int.random(in: 0..<cardsRemaining)
//        hand.append(deck[randomIndex])
//        deck.remove(at: randomIndex)
//        cardsRemaining -= 1
//      }
//
//      // Add code to update dealtHand here
//        let point = points(for: hand)
//        if point > 21 {
//            dealtHand.onError(HandError.busted(points: point))
//        } else {
//            dealtHand.onNext(hand)
//        }
//    }
//
//    // Add subscription to dealtHand here
//    dealtHand.subscribe { hand in
//        print(cardString(for: hand), points(for: hand))
//    } onError: { error in
//        print(error.localizedDescription)
//    }
//
//    deal(3)
//}


example(of: "Challenge 2: Observe and check user session state using a behavior relay") {
    enum UserSession {
      case loggedIn, loggedOut
    }
    
    enum LoginError: Error {
      case invalidCredentials
    }
    
    // Create userSession BehaviorRelay of type UserSession with initial value of .loggedOut
    let userSession = BehaviorRelay<UserSession>.init(value: .loggedOut)

    // Subscribe to receive next events from userSession
    userSession.subscribe { currentUserSession in
        print(currentUserSession)
    } onError: { error in
        print(error.localizedDescription)
    }
    
    func logInWith(username: String, password: String, completion: (Error?) -> Void) {
      guard username == "johnny@appleseed.com",
            password == "appleseed" else {
        completion(LoginError.invalidCredentials)
        return
      }
      
      // Update userSession
        userSession.accept(.loggedIn)
      
    }
    
    func logOut() {
      // Update userSession
        userSession.accept(.loggedOut)
    }
    
    func performActionRequiringLoggedInUser(_ action: () -> Void) {
      // Ensure that userSession is loggedIn and then execute action()
        if userSession.value == .loggedIn {
            action()
        }
    }
    
    for i in 1...2 {
      let password = i % 2 == 0 ? "appleseed" : "password"
      
      logInWith(username: "johnny@appleseed.com", password: password) { error in
        guard error == nil else {
          print(error!)
          return
        }
        
        print("User logged in.")
      }
      
      performActionRequiringLoggedInUser {
        print("Successfully did something only a logged in user can do.")
      }
    }
}
