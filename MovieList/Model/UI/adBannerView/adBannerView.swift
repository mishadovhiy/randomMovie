//
//  adBannerView.swift
//  Budget Tracker
//
//  Created by Misha Dovhiy on 24.04.2022.
//  Copyright © 2022 Misha Dovhiy. All rights reserved.
//

import UIKit
import GoogleMobileAds

class adBannerView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet private weak var adStack: UIStackView!
    
    var _size:CGFloat = 0
    var adHidden = true
    var adNotReceved = true
    
    public func createBanner() {
        GADMobileAds.sharedInstance().start { status in
            DispatchQueue.main.async {
                let window = AppDelegate.shared?.window ?? UIWindow()
                let height = self.backgroundView.frame.height
                let screenWidth:CGFloat = window.frame.width > 330 ? 320 : 300
                let adSize = GADAdSizeFromCGSize(CGSize(width: screenWidth, height: height))
                self.size = height
                let bannerView = GADBannerView(adSize: adSize)
                bannerView.adUnitID = "ca-app-pub-5463058852615321/4611360906"
                bannerView.rootViewController = AppDelegate.shared?.window?.rootViewController
                bannerView.load(GADRequest())
                bannerView.delegate = self
                self.adStack.addArrangedSubview(bannerView)
                self.addConstants(window)
                self.adStack.layer.cornerRadius = Styles.buttonRadius
                self.adStack.layer.masksToBounds = true
                self.layer.zPosition = 999
                self.backgroundView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, window.frame.height, 0)
            }
        }
    }

    
    public func appeare(force:Bool = false) {
        
        var go:Bool {
           /* if #available(iOS 13.0, *) {
                return force && !appData.proEnabeled
            } else {
                return !appData.proEnabeled
            }*/
            return true
        }
        if go {
            adHidden = false
            DispatchQueue.main.async {
                self.isHidden = false
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .allowAnimatedContent) {
                    //self.alpha = 1
                    self.backgroundView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 0)
                }
            }
        }
    }
    
    public func hide(remove:Bool = false, ios13Hide:Bool = false) {
        //add buy pro vc
       /* var go:Bool {
            if #available(iOS 13.0, *) {
                return (remove || appData.proEnabeled || ios13Hide) && !adHidden
            } else {
                return true
            }
        }
        if !adNotReceved && go {
            adHidden = true
            DispatchQueue.main.async {
                let window = AppDelegate.shared?.window ?? UIWindow()
                UIView.animate(withDuration: 0.3) {
                   // self.alpha = 0
                    self.backgroundView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, window.frame.height, 0)
                } completion: { _ in
                    self.isHidden = true
                    if remove {
                        self.removeAd()
                    }
                }
            }
        }*/
    }
    
    var clearBackground = true
    func setBackground(clear:Bool) {
        clearBackground = clear
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.backgroundColor = .black//clear ? .clear : K.Colors.primaryBacground
        }
    }
    
    
    
    
    
    var size:CGFloat {
        get {
            return adHidden ? 0 : _size
        }
        set {
            _size = newValue
        }
    }
    
    
    
    private func removeAd() {
        self.size = 0
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
    
    
    
    
    
    @IBAction private func closePressed(_ sender: UIButton) {
        //appData.presentBuyProVC(selectedProduct: 2)
    }
    
    
    
    private func addConstants(_ window:UIWindow) {
        window.addSubview(self)
        window.addConstraints([
            .init(item: self, attribute: .bottom, relatedBy: .equal, toItem: window.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: self, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: window.safeAreaLayoutGuide, attribute: .centerXWithinMargins, multiplier: 1, constant: 0),
            .init(item: self, attribute: .trailing, relatedBy: .equal, toItem: window.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0),
            .init(item: self, attribute: .leading, relatedBy: .equal, toItem: window.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0)
        ])
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "adBannerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}



