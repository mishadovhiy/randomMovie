//
//  TabBarVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.10.2023.
//

import UIKit
import AlertViewLibrary

class TabBarVC: UITabBarController {

    static var shared:TabBarVC? {
        let vc = (UIApplication.shared.keyWindow?.rootViewController as? UINavigationController)?.viewControllers.first as? TabBarVC
        print(vc, " gterfweregt")
        return vc
    }
    var segmented:SegmentView?
    var sideBar:SidebarManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setBackButton(vc: self)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        DispatchQueue(label: "db", qos: .userInitiated).async {
            NetworkModel().loadAppSettings {
//                NetworkModel().openAIMovies { //movies in
//                    
//                }
                DispatchQueue.main.async {
                    self.createSegmented()
                }
            }
        }
        sideBar = .init(superVC: self)
      //  DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            AppDelegate.shared?.banner.createBanner()
    //    })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.delegate = nil
    }
    
    private var viewAppeared:Bool = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.subviews.forEach({$0.alpha = 1})
        if !viewAppeared {
            viewAppeared = true
        }
    }

    
    
    
    func segmentedSelected(_ atItem:Int) {
        self.selectedIndex = atItem
    }
    
    //add sidebar
    
    private func createSegmented() {
//        let size:CGSize = .init(width: 250, height: 40)
//        let segment = SegmentView.init(titles: [
//            .init(name: "Random", tintColor: #colorLiteral(red: 0.3449999988, green: 0.3370000124, blue: 0.8389999866, alpha: 1), selectedTextColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), deselectedColor: #colorLiteral(red: 0.3449999988, green: 0.3370000124, blue: 0.8389999866, alpha: 1)),
//            .init(name: "Movie list", tintColor: #colorLiteral(red: 0.9100000262, green: 0.9100000262, blue: 0.9100000262, alpha: 1), selectedTextColor: #colorLiteral(red: 0.08600000292, green: 0.08600000292, blue: 0.08600000292, alpha: 1), deselectedColor: #colorLiteral(red: 0.2630000114, green: 0.2630000114, blue: 0.2630000114, alpha: 1))
//        ], size: .init(width: size.width, height: size.height), background: #colorLiteral(red: 0.08600000292, green: 0.08600000292, blue: 0.08600000292, alpha: 1), selected: segmentedSelected(_:))
//        segmented = segment
//        view.addSubview(segment)
//        segment.addConstaits([.centerX:0, .top:0, .width:size.width, .height:size.height], superV: self.view, toSafe: true)
        
        viewControllers?.forEach({
            $0.additionalSafeAreaInsets.top = 0
        })
        tabBar.isHidden = true
    }
    
}

extension TabBarVC {
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
    }
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
}

extension TabBarVC {
    static func configure() -> UIViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        return UINavigationController(rootViewController: vc)
    }
}
