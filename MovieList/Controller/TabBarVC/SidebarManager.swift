//
//  SideBar_Extension_TabBarVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.10.2023.
//

import UIKit

class SidebarManager {
    var containerView:SideBarView?
    var superView:TabBarVC
    
    private var helperView:UIView?
    private var scrolling = false
    var isShowing = false
    private var wasShowing = false
    var button:Button?
    init(superVC:TabBarVC) {
        self.superView = superVC
        self.createSidebar()
    }
    
    private func createSidebar() {
        let sideBarContainer = SideBarView()
        sideBarContainer.alpha = 0
        let width:CGFloat = 270
        superView.view.addSubview(sideBarContainer)
        sideBarContainer.addConstaits([.left:0, .top:0, .bottom:0, .width:width], superV: superView.view)
        sideBarContainer.backgroundColor = .black
        let vc = SideBarVC.configure()
        sideBarContainer.vc = vc
        superView.addChild(vc)
        sideBarContainer.addSubview(vc.view)
        vc.view.addConstaits([.left:0, .top:0, .right:0, .bottom:CGFloat(65) * -1], superV: sideBarContainer, toSafe: true)
        vc.didMove(toParent: superView)
        containerView = sideBarContainer
        self.toggleSideBar(false, animated: false)
        let view = TouchView()
        superView.view.addSubview(view)
        view.addConstaits([.left:CGFloat(width - 20), .top:0, .bottom:0, .width:60], superV: superView.view, toSafe: true)
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pinched(_:))))
        helperView = view
        
        let button = Button(type: .system)
        button.setImage(.init(systemName: "line.3.horizontal"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.2630000114, green: 0.2630000114, blue: 0.2630000114, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.08600000292, green: 0.08600000292, blue: 0.08600000292, alpha: 1)
        button.layer.cornerRadius = Styles.buttonRadius3
        view.addSubview(button)
        button.addConstaits([.top:0, .left:30, .width:40, .height:40], superV: view, toSafe: true)
        button.addTarget(self, action: #selector(sidebarPressed(_:)), for: .touchUpInside)
        button.layer.zPosition = -1
        button.shadow(opasity: Styles.buttonShadow)
        self.button = button
        view.alpha = 0
        //scrolling
        view.customTouchAnimation = {
     //       if !self.scrolling && !$0 {
                self.button?.touch($0)
       //     }
        }

    }
    
    
    @objc private func sidebarPressed(_ sender:UIButton) {
        toggleSideBar(!isShowing, animated: true)
    }
    
    private var width:CGFloat {
        return containerView?.frame.width ?? 0
    }
    
    @objc private func pinched(_ sender:UIPanGestureRecognizer) {
        let finger = sender.location(in: superView.view)
        if sender.state == .began {
            scrolling = (finger.x  - width) < 80
            wasShowing = isShowing
            superView.vibrate(style: .soft)
        }
        if scrolling || isShowing {
            if sender.state == .began || sender.state == .changed {
                let newPosition = (finger.x - width) >= 0 ? 0 : (finger.x - width)
                UIView.animate(withDuration: Styles.pressedAnimation) {
                    self.containerView?.layer.transform = CATransform3DTranslate(CATransform3DIdentity, newPosition, 0, 0)
                    self.helperView?.layer.transform = CATransform3DTranslate(CATransform3DIdentity, newPosition, 0, 0)
                }
                self.button?.touch(true)

            } else {
                if sender.state == .ended || sender.state == .cancelled {
                    let toHide:CGFloat = wasShowing ? 200 : 80
                    toggleSideBar(finger.x > toHide ? true : false, animated: true)
                }
            }
        }
    }
    
    func toggleSideBar(_ show: Bool, animated:Bool) {
        isShowing = show
        DispatchQueue.main.async {
            let newPosition = show ? 0 : -self.width//hereddas
            UIView.animate(withDuration: animated ? (Styles.pressedAnimation + 0.1) : 0, delay: 0, options: .allowUserInteraction) {
                self.containerView?.layer.transform = CATransform3DTranslate(CATransform3DIdentity, newPosition, 0, 0)
                self.helperView?.layer.transform = CATransform3DTranslate(CATransform3DIdentity, newPosition, 0, 0)

            } completion: { _ in
                if show {
                    DispatchQueue(label: "db", qos: .userInitiated).async {
                        SideBarVC.shared?.getData()
                    }
                }
                if self.containerView?.alpha == 0 {
                    self.containerView?.alpha = 1
                    self.helperView?.alpha = 1
                }
                if SideBarVC.shared?.changed ?? false {
                    SideBarVC.shared?.changed = false
                    self.superView.viewControllers?.forEach({
                        if let vc = $0 as? BaseVC, vc.appeared {
                            vc.filterChanged()
                        }
                    })
                }
                self.button?.touch(false)
                self.scrolling = false
            }

        }
    }
    
    class SideBarView:UIView {
        var vc:SideBarVC?
    }
}
