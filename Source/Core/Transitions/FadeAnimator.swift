//
//  FadeAnimator.swift
//

import UIKit

class FadeAnimator: NSObject {
    // MARK: - Properties
    let animationDuration: TimeInterval
    weak var storedContext: UIViewControllerContextTransitioning?
    private var isPresenting = false
    
    // MARK: - Initialization
    init(animationDuration: Double, isPresenting: Bool) {
        self.animationDuration = animationDuration
        self.isPresenting = isPresenting
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension FadeAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        
        if isPresenting {
            if let toView = toView {
                toView.alpha = 0
                transitionContext.containerView.addSubview(toView)
            }
        } else {
            if let toView = toView {
                if let fromView = fromView {
                    fromView.alpha = 1
                    transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
                }
            }
        }
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration) {
            if self.isPresenting {
                toView?.alpha = 1
            } else {
                fromView?.alpha = 0
            }
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
