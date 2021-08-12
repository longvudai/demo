//
//  BottomCardPresentationController.swift
//  iOS
//
//  Created by Peter Vu on 01/07/2021.
//  Copyright © 2021 Peter Vu. All rights reserved.
//

import UIKit
import Combine
import CombineExt

final class KeyboardManager {
    struct KeyboardPresetationInfo {
        let animationDuration: TimeInterval
        let keyboardSize: CGSize
    }
    
    // MARK: Properties
    var keyboardPresetationInfo: AnyPublisher<KeyboardPresetationInfo, Never> {
        return keyboardPresetationInfoSubject.eraseToAnyPublisher()
    }
    private var keyboardPresetationInfoSubject = CurrentValueSubject<KeyboardPresetationInfo, Never>.init(KeyboardPresetationInfo(animationDuration: 0, keyboardSize: .zero))
    
    private let notificationCenter = NotificationCenter.default
    private var cancellableSet = Set<AnyCancellable>()
    
    // MARK: Lifecycle
    init() {
        let kbWillHide = notificationCenter.publisher(for: UIResponder.keyboardWillHideNotification)
            .compactMap { notification -> KeyboardPresetationInfo? in
                if let animationTime = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
                    return KeyboardPresetationInfo(animationDuration: TimeInterval(animationTime.intValue), keyboardSize: .zero)
                } else {
                    return nil
                }
            }
        
        
        let kbWillShow = notificationCenter.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification -> KeyboardPresetationInfo? in
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                   let animationTime = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
                    return KeyboardPresetationInfo(animationDuration: TimeInterval(animationTime.intValue), keyboardSize: keyboardSize.size)
                } else {
                    return nil
                }
            }
            
        Publishers.Merge(kbWillHide, kbWillShow)
            .subscribe(keyboardPresetationInfoSubject)
            .store(in: &cancellableSet)
    }
}


extension UIViewController {
    func presentAsBottomCard(for targetViewController: UIViewController, animated: Bool, completionHandler: (() -> Void)? = nil) {
        targetViewController.modalPresentationStyle = .custom
        targetViewController.transitioningDelegate = BottomCardAnimatedTransitioningDelegate.default
        present(targetViewController, animated: animated, completion: nil)
    }
}

private class BottomCardAnimatedTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    static var `default`: BottomCardAnimatedTransitioningDelegate = .init()
    
    private override init() {
        super.init()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomCardAnimatedTransitioning.dimissing()
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BottomCardAnimatedTransitioning.presenting()
    }
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return BottomCardPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

private class BottomCardAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    private let isPresenting: Bool
    
    static func presenting() -> BottomCardAnimatedTransitioning {
        return .init(isPresenting: true)
    }
    
    static func dimissing() -> BottomCardAnimatedTransitioning {
        return .init(isPresenting: false)
    }
    
    private init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.21
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            guard let presentingViewController = transitionContext.viewController(forKey: .to) else {
                return
            }
            
            let targetViewFrame = transitionContext.finalFrame(for: presentingViewController)
            transitionContext.containerView.addSubview(presentingViewController.view)
            presentingViewController.view.frame = CGRect(x: targetViewFrame.minX,
                                                         y: transitionContext.containerView.bounds.maxY,
                                                         width: targetViewFrame.width,
                                                         height: targetViewFrame.height)
            
            let animator = UIViewPropertyAnimator(duration: 0.21, controlPoint1: CGPoint(x: 0.05, y: 0.76), controlPoint2: CGPoint(x: 0.42, y: 0.94)) {
                presentingViewController.view.frame = targetViewFrame
            }
            
            animator.addCompletion { position in
                switch position {
                case .end:
                    transitionContext.completeTransition(true)

                case .current, .start:
                    break
                @unknown default:
                    break
                }
            }
            
            animator.startAnimation()
        } else {
            guard let dismissingViewController = transitionContext.viewController(forKey: .from) else {
                return
            }
            
            let dismissingFrame = CGRect(x: dismissingViewController.view.frame.minX,
                                         y: transitionContext.containerView.bounds.maxY,
                                         width: dismissingViewController.view.frame.width,
                                         height: dismissingViewController.view.frame.height)
            
            let animator = UIViewPropertyAnimator(duration: 0.21, controlPoint1: CGPoint(x: 0.05, y: 0.76), controlPoint2: CGPoint(x: 0.42, y: 0.94)) {
                dismissingViewController.view.frame = dismissingFrame
            }
            
            animator.addCompletion { position in
                switch position {
                case .end:
                    transitionContext.completeTransition(true)

                case .current, .start:
                    break
                @unknown default:
                    break
                }
            }
            
            animator.startAnimation()
        }
    }
}

enum BottomCardPresentationContentSizing {
    case autoLayout
    case preferredContentSize(size: CGSize)
}

protocol PresentationBehavior {
    var bottomCardPresentationContentSizing: BottomCardPresentationContentSizing { get }
}

private class BottomCardPresentationController: UIPresentationController {
    private lazy var backdropView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnBackdrop))
        v.addGestureRecognizer(tap)
        return v
    }()
    private lazy var presentingViewSnapshot: UIView? = presentingViewController.view.snapshotView(afterScreenUpdates: true)
    
    private var cancellableSet = Set<AnyCancellable>()
    private var keyboardHeight = CurrentValueSubject<CGFloat, Never>.init(0)
    private lazy var keyboardManager: KeyboardManager = {
        return KeyboardManager()
    }()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let kbPresentation = keyboardManager.keyboardPresetationInfo
            .removeDuplicates(by: { $0.keyboardSize.height == $1.keyboardSize.height })
            
        kbPresentation.map { $0.keyboardSize.height }
            .assign(to: \.value, on: keyboardHeight, ownership: .weak)
            .store(in: &cancellableSet)
        
        keyboardHeight
            .withLatestFrom(kbPresentation)
            .map { $0.animationDuration }
            .sink(receiveValue: { [weak self] animationDuration in
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                    self?.containerView?.setNeedsLayout()
                    self?.containerView?.layoutIfNeeded()
                }, completion: nil)
            })
            .store(in: &cancellableSet)
    }
    
    private var bottomOffset: CGFloat { 32 }
    private var maximumContentSize: CGSize {
        guard let containerView = self.containerView else {
            return .zero
        }
        
        let maxWidth: CGFloat = 400
        
        return CGSize(width: min(maxWidth, containerView.frame.width - 32),
                      height: containerView.frame.height - bottomOffset)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = self.containerView else {
            return .zero
        }
        
        var contentSize: CGSize = .zero
        
        if let presentationBehavior = presentedViewController as? PresentationBehavior {
            let style = presentationBehavior.bottomCardPresentationContentSizing
            switch style {
            case .autoLayout:
                let targetSize = CGSize(
                    width: min(maximumContentSize.width, containerView.frame.width),
                    height: min(maximumContentSize.height, containerView.frame.height)
                )
                contentSize = presentedView?.systemLayoutSizeFitting(
                    targetSize,
                    withHorizontalFittingPriority: .required,
                    verticalFittingPriority: .fittingSizeLevel
                ) ?? containerView.frame.size
                
            case .preferredContentSize(let preferredContentSize):
                contentSize = CGSize(
                    width: min(maximumContentSize.width, preferredContentSize.width),
                    height: min(maximumContentSize.height, preferredContentSize.height)
                )
            }
        } else {
            contentSize = CGSize(
                width: min(maximumContentSize.width, containerView.frame.width),
                height: min(maximumContentSize.height, presentedViewController.preferredContentSize.height)
            )
        }
        
        let f = CGRect(
            x: containerView.bounds.midX - (contentSize.width / 2),
            y: containerView.bounds.height - contentSize.height - bottomOffset - keyboardHeight.value,
            width: contentSize.width,
            height: min(UIScreen.main.bounds.height, contentSize.height)
        )
        
        print("f", f)
        
        return f
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentingViewSnapshot?.frame = containerView?.bounds ?? .zero
        backdropView.frame = containerView?.bounds ?? .zero
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let containerView = self.containerView else {
            return
        }
        
        if let presentingViewSnapshot = self.presentingViewSnapshot {
            containerView.addSubview(presentingViewSnapshot)
        }
        
        containerView.addSubview(backdropView)
        
        presentingViewController
            .transitionCoordinator?
            .animate(alongsideTransition: { [weak self] _ in
                self?.backdropView.alpha = 0.15
            }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentingViewController
            .transitionCoordinator?
            .animate(alongsideTransition: { [weak self] _ in
                self?.backdropView.alpha = 0
            }, completion: { [weak self] _ in
                self?.backdropView.removeFromSuperview()
                self?.presentingViewSnapshot?.removeFromSuperview()
            })
    }
    
    @objc
    private func handleTapOnBackdrop() {
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
}
