//
//  adBannerView.swift
//  Budget Tracker
//
//  Created by Misha Dovhiy on 24.04.2022.
//  Copyright © 2022 Misha Dovhiy. All rights reserved.
//

import UIKit
import GoogleMobileAds

protocol FullScreenDelegate {
    func toggleAdView(_ show:Bool)
}

class adBannerView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet private weak var adStack: UIStackView!
    
    var _size:CGFloat = 0
    var adHidden = true
    var adNotReceved = true
    private var showedBannerTime:Data?
    var bannerWatchedFull:Bool = false
    private var bannerShowCompletion:((_ presented:Bool)->())?
    private var showedBanner:Date?
    var fullScreenDelegates:[String:FullScreenDelegate] = [:]
    let videoShowDelay:Double = (3 * 60) * 60
    var interstitial: GADFullScreenPresentingAd?

    public func createBanner() {
        if #available(iOS 13.0, *) {
            GADMobileAds.sharedInstance().start { status in
                DispatchQueue.main.async {
                   // let window = AppDelegate.shared?.window ?? UIWindow()
                                    let window = UIApplication.shared.keyWindow!

                    let height = self.backgroundView.frame.height
                    let screenWidth:CGFloat = window.frame.width > 330 ? 320 : 300
                    let adSize = GADAdSizeFromCGSize(CGSize(width: screenWidth, height: height))
                    self.size = height
                    let bannerView = GADBannerView(adSize: adSize)
                    bannerView.adUnitID = "ca-app-pub-5463058852615321/8859730315"
                    bannerView.rootViewController = AppDelegate.shared?.window?.rootViewController
                    //                bannerView.rootViewController = window.rootViewController

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
        } else {
            
        }
    }

    func toggleFullScreenAdd(_ vc:UIViewController, loaded:@escaping(GADFullScreenPresentingAd?)->(), closed:@escaping(_ presented:Bool)->()) {
        if #available(iOS 13.0, *) {
            bannerCanShow { show in
                if show {
                    self.bannerShowCompletion = closed
                    if !self.adHidden {
                        self.hide(ios13Hide: true, completion: {
                            self.presentFullScreen(vc, loaded: loaded)
                        })
                    } else {
                        self.presentFullScreen(vc, loaded: loaded)

                    }
                } else {
                    closed(false)
                }
            }

        } else {
            closed(true)
        }
    }
    private weak var rootVC:UIViewController?

    private func presentFullScreen(_ vc:UIViewController, loaded:@escaping(GADFullScreenPresentingAd?)->()) {
        //here
        rootVC = vc
        let id = "ca-app-pub-5463058852615321/7352213464"
        GADInterstitialAd.load(withAdUnitID: id, request: GADRequest()) { ad, error in
            loaded(ad)
            if error != nil {
                print(error ?? "-", "bannerror")
            }
            ad?.present(fromRootViewController: vc)
        }
    }
    
    func bannerCanShow(completion:@escaping(_ show:Bool)->()) {
        if #available(iOS 13.0, *) {
            if let from = self.showedBanner {
                let now = Date()
                let dif = now.timeIntervalSince(from)
                if dif >= self.videoShowDelay {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
    }
    
    
    public func appeare(force:Bool = false, completion:(()->())? = nil) {
        
        var go:Bool {
            if #available(iOS 13.0, *) {
                return true
            } else {
                return false
            }
        }
        if go {
            adHidden = false
            DispatchQueue.main.async {
                self.isHidden = false
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
                    //self.alpha = 1
                    self.backgroundView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 0)
                }) { _ in
                    completion?()
                }
            }
        } else {
            completion?()
        }
    }
    
    public func hide(remove:Bool = false, ios13Hide:Bool = false, completion:(()->())? = nil) {
        //add buy pro vc
        var go:Bool
        {
            if #available(iOS 13.0, *) {
                return true
            } else {
                return false
            }
        }
        if !adNotReceved && go {
            adHidden = true
            DispatchQueue.main.async {
                //let window = AppDelegate.shared?.window ?? UIWindow()

                let window = UIApplication.shared.keyWindow ?? .init()
                UIView.animate(withDuration: 0.3) {
                   // self.alpha = 0
                    self.backgroundView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, window.frame.height, 0)
                } completion: { _ in
                    self.isHidden = true
                    if remove {
                        self.removeAd()
                    }
                    completion?()
                }
            }
        } else {
            completion?()
        }
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



extension adBannerView {
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        bannerWatchedFull = false
        showedBannerTime = Data()
        AppDelegate.shared?.ai.hide()
      //  let shape = UIApplication.shared.keyWindow?.layer.drawSeparetor(color: UIColor.link, y: UIApplication.shared.keyWindow?.safeAreaInsets.top, width: 3)
        let window = UIApplication.shared.keyWindow ?? .init()
        let shape = UIApplication.shared.keyWindow?.layer.drawLine([.init(x: 0, y: window.safeAreaInsets.top), .init(x: window.frame.width, y: window.safeAreaInsets.top)], color: .red, width: 3)
        shape?.zPosition = 999
        shape?.name = "adFullBanerLine"
        shape?.performAnimation(key: .stokeEnd, to: CGFloat(1), code: .general, duration: 10, completion: {
            UIView.animate(withDuration: 0.3) {
                shape?.strokeColor = UIColor.green.cgColor
            }
        })
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in
            if self.bannerShowCompletion != nil {
                self.bannerWatchedFull = true
            }
        })
    }
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        let holderCompletion = bannerShowCompletion
        bannerShowCompletion = nil
        let layer = UIApplication.shared.keyWindow?.layer.sublayers?.first(where: {$0.name == "adFullBanerLine"})
        
        if self.bannerWatchedFull {
            self.showedBanner = Date()
            self.fullScreenDelegates.forEach({
                $0.value.toggleAdView(false)
            })
            Timer.scheduledTimer(withTimeInterval: videoShowDelay, repeats: false, block: { _ in
                self.fullScreenDelegates.forEach({
                    $0.value.toggleAdView(true)
                })
            })
            self.appeare(force: true) {
                holderCompletion?(true)
            }
        } else {
            AppDelegate.shared?.message.show(title:"Ad not watched till the end", type: .error)

            self.appeare(force: true)
        }
        UIView.animate(withDuration: 0.6, animations: {
            layer?.opacity = 0
        }, completion: {
            if !$0 {
                return
            }
            layer?.removeAllAnimations()
            layer?.removeFromSuperlayer()
        })

    }
}
