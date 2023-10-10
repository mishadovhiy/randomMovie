//
//  ImageVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 04.10.2023.
//

import UIKit

class ImageVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var smallImgView: UIImageView!
    var img:UIImage?
    var from:CGRect?
    var fromAdditional:CGPoint?
    var animateBackground:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgView.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: false)
     //   self.smallImgView.image = img
        self.imgView.image = img
    /*    self.smallImgView.image = img
     
        self.imgView.isHidden = true
        self.smallImgView.constraints.forEach({self.smallImgView.removeConstraint($0)})
        self.smallImgView.addConstaits([.left:(fromAdditional?.x ?? 0) + (from?.minX ?? 0), .top:(fromAdditional?.y ?? 0) + (from?.minY ?? 0)], superV: self.view)
        self.view.layoutIfNeeded()
        self.smallImgView.frame.size = .init(width: from?.width ?? 0, height: from?.height ?? 0)
        self.smallImgView.translatesAutoresizingMaskIntoConstraints = true
        self.imgView.image = img
     //   if !animateBackground {
            self.view.backgroundColor = #colorLiteral(red: 0.08600000292, green: 0.08600000292, blue: 0.08600000292, alpha: 1)
       // }
     */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     //   animate()
    }
    

    func animate() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            /*self.smallImgView.constraints.forEach({self.smallImgView.removeConstraint($0)})
            self.smallImgView.addConstaits([.left:0, .right:0, .top:0, .bottom:0], superV: self.view)
            self.view.layoutIfNeeded()*/
            self.smallImgView.frame = self.imgView.frame
        }, completion: { _ in
            self.imgView.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
                self.smallImgView.alpha = 0
            }, completion: { _ in
                
            })
        })
  /*      if animateBackground {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.backgroundColor = #colorLiteral(red: 0.08600000292, green: 0.08600000292, blue: 0.08600000292, alpha: 1)
            })
        }*/
        
    }

}

extension ImageVC {
    static func present(img:Data?, from:CGRect?, inVC:UIViewController, fromAdditional:CGPoint?, animateBack:Bool = true) {
        if let vc = ImageVC.configure(img: img, from: from, fromAdditional: fromAdditional, animateBack: animateBack) {
            //inVC.present(vc, animated: true)
            inVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    static func configure(img:Data?, from:CGRect?, fromAdditional:CGPoint?, animateBack:Bool = true) -> ImageVC? {
        if let data = img, let img = UIImage(data: data) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ImageVC") as! ImageVC
            vc.from = from
            vc.img = img
            vc.fromAdditional = fromAdditional
            vc.modalPresentationStyle = .formSheet
            vc.modalTransitionStyle = .crossDissolve
            vc.animateBackground = animateBack
            return vc
        } else {
            return nil
        }
    }
}




final class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? MovieVC,
            let toViewController = transitionContext.viewController(forKey: .to) as? ImageVC,
            let albumCoverImageView = fromViewController.movieImage,
            let albumDetailHeaderView = toViewController.imgView
        else {
            return
        }

        let containerView = transitionContext.containerView
        let snapshotContentView = UIView()
        snapshotContentView.backgroundColor = toViewController.view.backgroundColor
        snapshotContentView.frame = containerView.convert(albumCoverImageView.frame, from: albumCoverImageView)
        
        let snapshotAlbumCoverImageView = UIImageView()
        snapshotAlbumCoverImageView.clipsToBounds = true
        snapshotAlbumCoverImageView.contentMode = albumCoverImageView.contentMode
        snapshotAlbumCoverImageView.image = albumCoverImageView.image
        snapshotAlbumCoverImageView.layer.cornerRadius = albumCoverImageView.layer.cornerRadius
        snapshotAlbumCoverImageView.frame = containerView.convert(albumCoverImageView.frame, from: albumCoverImageView)
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapshotContentView)
        containerView.addSubview(snapshotAlbumCoverImageView)

        toViewController.view.isHidden = true
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            snapshotContentView.frame = containerView.convert(toViewController.view.frame, from: toViewController.view)
            snapshotAlbumCoverImageView.frame = containerView.convert(albumDetailHeaderView.frame, from: albumDetailHeaderView)
            snapshotAlbumCoverImageView.layer.cornerRadius = 0
        }

        animator.addCompletion { position in
            toViewController.view.isHidden = false
            snapshotAlbumCoverImageView.removeFromSuperview()
            snapshotContentView.removeFromSuperview()
            transitionContext.completeTransition(position == .end)
        }

        animator.startAnimation()
    }
}

private extension TransitionManager {
    
  /*  func presentViewController(_ toViewController: AlbumDetailViewController, from fromViewController: AlbumsViewController, with context: UIViewControllerContextTransitioning) {
        
    }*/
}
