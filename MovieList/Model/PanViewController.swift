//
//  PanViewController.swift
//  MovieList
//
//  Created by Misha Dovhiy on 14.10.2023.
//

import UIKit

class PanViewController {
    
    private let vc:UIViewController
    
    var delegate:PanViewControllerProtocol?
    private var properies:ScrollProperties = .init()
    
    init(vc:UIViewController) {
        self.vc = vc
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(pinched(_:)))
        gesture.name = "PanViewControllerUIPanGestureRecognizer"
        vc.view.addGestureRecognizer(gesture)
        vc.createPanIndicator()
    }
       
    deinit {
        print("PanViewdeinitdeinitdeinitdeinit")
        let gesture = vc.view.gestureRecognizers?.first(where: {$0.name == "PanViewControllerUIPanGestureRecognizer"})
        gesture?.delegate = nil
        gesture?.isEnabled = false
    }
    
    @objc private func pinched(_ sender:UIPanGestureRecognizer) {
        let finger = sender.location(in: nil)
        let height = vc.view.frame.height
        if sender.state == .began {
            properies.scrolling = (finger.y  - height) < 80
            properies.wasShowing = properies.vcShowing
            properies.startScrollingPosition = finger.y
          //  vc.vibrate(style: .soft)
            properies.isHidding = false
            touches(true)
        }
        let currentPosition = self.vc.view.frame.minY
        let toHide:CGFloat = properies.wasShowing ? 200 : 80
        let isHidding = currentPosition > toHide ? false : true
        if isHidding != properies.isHidding {
            properies.isHidding = isHidding
            vc.vibrate(style: .soft)
        }
        if properies.scrolling || properies.vcShowing {
            if sender.state == .began || sender.state == .changed {
                
                let newPosition = (finger.y - height) >= 0 ? 0 : (finger.y - height)
                print(finger.y, " yrtgerfegtr")
                print(newPosition, " yhtrgefgrthy")
                print(height, " rbegrfwe")
                self.vc.view.layer.move(.top, value: (newPosition + properies.toHideVC) - properies.startScrollingPosition)
            } else if sender.state == .ended || sender.state == .cancelled {
                
                print("gerfwdwef")
                print(currentPosition)
                print(finger.x)
                print("gbrvfcd")
                touches(false)
                toggleView(show: isHidding, animated: true)
                
            }
        }
    }
    

    func toggleView(show:Bool, animated:Bool = true, completion:((_ show:Bool)->())? = nil) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.vc.view.layer.move(.top, value: show ? 0 : self.properies.toHideVC)
        }, completion: { _ in
            if !show {
                self.properies.vcShowing = false
                self.properies.scrolling = false
                completion?(false)
            } else {
                self.properies.vcShowing = true
                self.properies.scrolling = false
                completion?(true)
            }
        })
        if !show {
            self.dismissVC() {
                
            }
        }
    }
    
    
    private func dismissVC(completion:(()->())? = nil) {
        vc.navigationController?.popViewController(animated: true)
        completion?()
    }
    
    
    private func touches(_ begun:Bool) {
        let panIndocator = vc.view.subviews.first(where: {
            $0.layer.name == UIViewController.panIndicatorLayerName
        })
        UIView.animate(withDuration: 0.3, animations: {
            panIndocator?.alpha = begun ? 0.3 : 0.1
        })
    }

    
}

protocol PanViewControllerProtocol {
    func panDismissed()
    func panAppeared()
}

extension PanViewController {
    struct ScrollProperties {
        var scrolling:Bool = false
        var wasShowing:Bool = false
        var vcShowing:Bool = true
        var startScrollingPosition:CGFloat = 0
        var isHidding:Bool = false
        var toHideVC:CGFloat {
            return UIApplication.shared.keyWindow?.frame.height ?? 0
        }
    }
}
