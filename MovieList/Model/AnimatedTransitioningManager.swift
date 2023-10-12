//
//  AnimatedImageManagerNav.swift
//  MovieList
//
//  Created by Misha Dovhiy on 11.10.2023.
//

import UIKit

final class AnimatedTransitioningManager: NSObject, UIViewControllerAnimatedTransitioning {
    //NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        if let movieVC = fromVC as? MovieVC ?? toVC as? MovieVC,
           let imageVC = toVC as? ImageVC ?? fromVC as? ImageVC {
            self.transactionPerform(movieVC: movieVC, imageVC: imageVC, using: transitionContext)
        } else if let movieVC = fromVC as? MovieVC ?? toVC as? MovieVC,
                  let listVC = toVC as? MovieListVC ?? fromVC as? MovieListVC {
            self.transactionPerform(movieVC: movieVC, listVC: listVC, using: transitionContext)
        }
        
    }
    
}

private extension AnimatedTransitioningManager {
    struct TransitionViews {
        let animatedView:UIImageView?
        let primatyView:UIView?
    }
    
    func transactionPerform(movieVC:MovieVC, listVC:MovieListVC, using transitionContext: UIViewControllerContextTransitioning) {
        let show = (transitionContext.viewController(forKey: .from) as? MovieVC) != nil
        
        presentImageVC(.init(animatedView: show ? listVC.selectedImageView : movieVC.movieImage, primatyView: show ? listVC.view : movieVC.view), from: .init(animatedView: show ? movieVC.movieImage : listVC.selectedImageView, primatyView: show ? movieVC.view : listVC.view), with: transitionContext, isPresenting: show)
    }
    
    func transactionPerform(movieVC:MovieVC, imageVC:ImageVC, using transitionContext: UIViewControllerContextTransitioning) {
        let show = (transitionContext.viewController(forKey: .from) as? MovieVC) != nil
        
        presentImageVC(.init(animatedView: show ? imageVC.imgView : movieVC.movieImage, primatyView: show ? imageVC.view : movieVC.view), from: .init(animatedView: show ? movieVC.movieImage : imageVC.imgView, primatyView: show ? movieVC.view : imageVC.view), with: transitionContext, isPresenting: show)
    }
    
    private func presentImageVC(_ toViewController: TransitionViews, from fromViewController: TransitionViews, with transitionContext: UIViewControllerContextTransitioning, isPresenting:Bool) {
        guard let fromAnimated = fromViewController.animatedView,
              let toAnimated = toViewController.animatedView,
              let fromView = fromViewController.primatyView,
              let toView = toViewController.primatyView
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
        let toFrame = containerView.convert(toAnimated.frame, from: toAnimated)
        print(fromView.safeAreaInsets.bottom)
        print(fromView.safeAreaInsets.bottom)

        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            let minus:CGFloat = fromView.safeAreaInsets.bottom - 10
            fromImageView.frame = .init(x: toFrame.minX, y: toFrame.minY - minus, width: toFrame.width, height: toFrame.height - minus)
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


}

extension AnimatedTransitioningManager:UINavigationControllerDelegate {
    func navigationController(
            _ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
            from fromVC: UIViewController,
            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            
                return self
        }
}

