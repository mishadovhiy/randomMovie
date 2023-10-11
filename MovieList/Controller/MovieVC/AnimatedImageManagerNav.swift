//
//  AnimatedImageManagerNav.swift
//  MovieList
//
//  Created by Misha Dovhiy on 11.10.2023.
//

import UIKit

final class AnimatedImageManagerNav: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let movieVC = transitionContext.viewController(forKey: .from) as? MovieVC ?? transitionContext.viewController(forKey: .to) as? MovieVC,
            let imageVC = transitionContext.viewController(forKey: .to) as? ImageVC ?? transitionContext.viewController(forKey: .from) as? ImageVC
        else {
            return
        }
        let show = (transitionContext.viewController(forKey: .from) as? MovieVC) != nil
        
        presentImageVC(.init(animatedView: show ? imageVC.imgView : movieVC.movieImage, primatyView: show ? imageVC.view : movieVC.view), from: .init(animatedView: show ? movieVC.movieImage : imageVC.imgView, primatyView: show ? movieVC.view : imageVC.view), with: transitionContext, isPresenting: show)
    }
    
}

private extension AnimatedImageManagerNav {
    struct TransitionViews {
        let animatedView:UIImageView?
        let primatyView:UIView?
    }
    
    func performPresentImageVC(to:TransitionViews, from:TransitionViews,  with transitionContext: UIViewControllerContextTransitioning, isPresenting:Bool) {
        
        guard let fromAnimated = from.animatedView,
              let toAnimated = to.animatedView,
              let fromView = from.primatyView,
              let toView = to.primatyView
        else {
            return
        }
        print("isPresentingisPresenting: ", isPresenting)
        let containerView = transitionContext.containerView
        let snapshotContentView = UIView()
        snapshotContentView.backgroundColor = toView.backgroundColor
        snapshotContentView.frame = containerView.convert(fromAnimated.frame, from: fromAnimated)
        
        let fromImageView = UIImageView()
        fromImageView.clipsToBounds = true
        fromImageView.contentMode = fromAnimated.contentMode
        fromImageView.image = fromAnimated.image
        fromImageView.layer.cornerRadius = fromAnimated.layer.cornerRadius
        fromImageView.frame = containerView.convert(fromAnimated.frame, from: fromAnimated)
        
        containerView.addSubview(toView)
        containerView.addSubview(snapshotContentView)
        containerView.addSubview(fromImageView)

        toView.isHidden = true
        let fromFrame = containerView.convert(toAnimated.frame, from: toAnimated)
        print(fromView.safeAreaInsets.bottom)
        print(fromView.safeAreaInsets.bottom)

        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            let minus:CGFloat = fromView.safeAreaInsets.bottom - 10
            fromImageView.frame = .init(x: fromFrame.minX, y: fromFrame.minY - minus, width: fromFrame.width, height: fromFrame.height - minus)
            fromImageView.layer.cornerRadius = 0
        }

        animator.addCompletion { position in
            toView.isHidden = false
            fromImageView.removeFromSuperview()
            snapshotContentView.removeFromSuperview()
            transitionContext.completeTransition(position == .end)
        }

        animator.startAnimation()
    }
    
    func presentImageVC(_ toViewController: TransitionViews, from fromViewController: TransitionViews, with transitionContext: UIViewControllerContextTransitioning, isPresenting:Bool) {
        guard let _ = fromViewController.animatedView,
              let _ = toViewController.animatedView else {
            return
        }
        
        self.performPresentImageVC(to: toViewController, from: fromViewController, with: transitionContext, isPresenting: isPresenting)
    }
}
