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
            fatalError()
        }
        if let movieVC = fromVC as? MovieVC ?? toVC as? MovieVC,
           let imageVC = toVC as? ImageVC ?? fromVC as? ImageVC {
            self.transactionPerform(movieVC: movieVC, imageVC: imageVC, using: transitionContext)
        } else if let movieVC = fromVC as? MovieVC ?? toVC as? MovieVC,
                  let listVC = toVC as? MovieListVC ?? fromVC as? MovieListVC {
            self.transactionPerform(movieVC: movieVC, listVC: listVC, using: transitionContext)
        } else if let movieVC = fromVC as? MovieVC ?? toVC as? MovieVC,
                  let tabvc = (toVC as? MovieListVC ?? fromVC as? MovieListVC) ?? (toVC as? TabBarVC ?? fromVC as? TabBarVC),
                  let tabbarVC = tabvc as? UITabBarController,
                  let listVC = tabbarVC.viewControllers?.first(where: {$0 is MovieListVC}) as? MovieListVC
        {
            self.transactionPerform(movieVC: movieVC, tabVC: tabbarVC as! TabBarVC, using: transitionContext)
        } else {
            print("sdfdqfwe")
            print(fromVC)
            print(toVC)

            fatalError()
        }
        
    }
    
}

//movieListVC - movieVC
private extension AnimatedTransitioningManager {
    func transactionPerform(movieVC:MovieVC, tabVC:TabBarVC, using transitionContext: UIViewControllerContextTransitioning) {
        let show = (transitionContext.viewController(forKey: .from) as? MovieVC) != nil
        let animFrame:CGRect = .init(x: 100, y: 100, width: 0, height: 0)
        movieVC.frameHolder = animFrame
        let listVC = tabVC.viewControllers?.first(where: {$0 is MovieListVC}) as? MovieListVC
        movieVC.movieImage.frame = .init(origin: movieVC.movieImage.frame.origin, size: listVC?.selectedImageView?.frame.size ?? movieVC.movieImage.frame.size)
        presentImageVC(.init(animatedView: show ? listVC?.selectedImageView : movieVC.movieImage,
                             primatyView: show ? tabVC.view : movieVC.view,
                             animatedFrame: !show ? movieVC.frameHolder : animFrame/*,
                             animatedRegView: show ? tabVC.segmented : movieVC.movieImage*/
                            ),
                       from: .init(animatedView: show ? movieVC.movieImage : listVC?.selectedImageView,
                                   primatyView: show ? movieVC.view : tabVC.view,
                                   animatedFrame: show ? movieVC.frameHolder : animFrame/*,
                                   animatedRegView: show ? movieVC.movieImage : tabVC.segmented*/
                                  ),
                       with: transitionContext,
                       isPresenting: show)
    }
    
    func transactionPerform(movieVC:MovieVC, listVC:MovieListVC, using transitionContext: UIViewControllerContextTransitioning) {
        let show = (transitionContext.viewController(forKey: .from) as? MovieVC) != nil
        let animFrame:CGRect = .init(x: 100, y: 100, width: 0, height: 0)
        movieVC.frameHolder = animFrame
        movieVC.movieImage.frame = .init(origin: movieVC.movieImage.frame.origin, size: listVC.selectedImageView?.frame.size ?? movieVC.movieImage.frame.size)

        let isReg = listVC.selectedImageView == nil
        presentImageVC(.init(animatedView: isReg ? nil : (show ? listVC.selectedImageView : movieVC.movieImage),
                             primatyView: show ? listVC.view : movieVC.view,
                             animatedFrame: !show ? movieVC.frameHolder : animFrame,
                             animatedRegView: !isReg ? nil : (show ? listVC.shakeButton : movieVC.movieImage)
                            ),
                       from: .init(animatedView: isReg ? nil : (show ? movieVC.movieImage : listVC.selectedImageView),
                                   primatyView: show ? movieVC.view : listVC.view,
                                   animatedFrame: show ? movieVC.frameHolder : animFrame,
                                   animatedRegView: isReg ? (show ? movieVC.movieImage : listVC.shakeButton) : nil
                                  ),
                       with: transitionContext,
                       isPresenting: show)
    }
}


//movieVC - ImgVC
private extension AnimatedTransitioningManager {
    struct TransitionViews {
        let animatedView:UIImageView?
        let primatyView:UIView?
        var animatedFrame:CGRect? = nil
        var animatedRegView:UIView? = nil
        var viewFrame:CGRect? = nil
    }
        
    func transactionPerform(movieVC:MovieVC, imageVC:ImageVC, using transitionContext: UIViewControllerContextTransitioning) {
        let show = (transitionContext.viewController(forKey: .from) as? MovieVC) != nil
        
        presentImageVC(.init(animatedView: show ? imageVC.imgView : movieVC.movieImage, primatyView: show ? imageVC.view : movieVC.view), from: .init(animatedView: show ? movieVC.movieImage : imageVC.imgView, primatyView: show ? movieVC.view : imageVC.view), with: transitionContext, isPresenting: show)
    }
    
    private func presentImageVC(_ toViewController: TransitionViews, from fromViewController: TransitionViews, with transitionContext: UIViewControllerContextTransitioning, isPresenting:Bool) {
        guard let fromAnimated = fromViewController.animatedView ?? fromViewController.animatedRegView,
              let toAnimated = toViewController.animatedView ?? toViewController.animatedRegView,
              let fromView = fromViewController.primatyView,
              let toView = toViewController.primatyView
        else {
            fatalError()
        }
          print("isPresentingisPresenting: ", isPresenting)
        let containerView = transitionContext.containerView
        let snapshotContentView = UIView()
        snapshotContentView.frame =  containerView.convert(fromAnimated.frame, from: fromAnimated)
            //.init(origin: .zero, size: .init(width: fromViewController.primatyView?.frame.width ?? 10, height: fromViewController.primatyView?.frame.height ?? 0))
        
        let fromImageView = UIImageView()
        fromImageView.clipsToBounds = true
        fromImageView.contentMode = fromAnimated.contentMode
        fromImageView.image = (fromAnimated as? UIImageView)?.image//fromAnimated.image
        toViewController.animatedView?.image = (fromAnimated as? UIImageView)?.image
        let imgFrame = containerView.convert(fromAnimated.frame, from: fromAnimated)
       // toViewController.animatedView?.frame = .init(origin: toViewController.animatedView?.frame.origin ?? .zero, size: imgFrame.size)
        fromImageView.layer.cornerRadius =  fromAnimated.layer.cornerRadius
        fromImageView.frame = imgFrame
        //containerView.convert(.init(x: fromAnimated.frame.minX + adFr.minX, y: fromAnimated.frame.minY + adFr.minY, width: adFr.width + fromAnimated.frame.width, height: adFr.height + fromAnimated.frame.height), from: fromAnimated)
        
        containerView.addSubview(toView)
        containerView.addSubview(snapshotContentView)
        containerView.addSubview(fromImageView)
       // fromView.alpha = 0
        toView.alpha = 0
        snapshotContentView.alpha = 0
        let toadFr = toViewController.animatedFrame ?? fromViewController.animatedFrame ?? .zero
      //  let r = toadFr + toAnimated.frame
        let toFrame = containerView.convert(.init(x: toAnimated.frame.minX + toadFr.minX, y: toAnimated.frame.minY + toadFr.minY, width: toadFr.width + toAnimated.frame.width, height: toadFr.height + toAnimated.frame.height), from: toAnimated)
        let toFrame1 = containerView.convert(.init(x: toAnimated.frame.minX, y: toAnimated.frame.minX, width: toAnimated.frame.width - 10, height: toAnimated.frame.height - 10), from: toAnimated)
        print(fromView.safeAreaInsets.bottom)
        let animatorPuls = UIViewPropertyAnimator(duration: duration / 2, curve: .easeIn, animations: {
            toView.alpha = 1
           // fromView.alpha = 1
        })
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut) {
            fromImageView.frame = toFrame1
            fromImageView.layer.cornerRadius = 0
            snapshotContentView.backgroundColor = toView.backgroundColor
            
        }

        animator.addCompletion { position in
          //  toView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                fromImageView.alpha = 0
                snapshotContentView.alpha = 0
            }, completion: { _ in
                fromImageView.removeFromSuperview()
                snapshotContentView.removeFromSuperview()
                
            })
            transitionContext.completeTransition(position == .end)
            
        }
        animatorPuls.startAnimation()
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

