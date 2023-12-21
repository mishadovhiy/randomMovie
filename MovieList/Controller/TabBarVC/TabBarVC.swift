//
//  TabBarVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 03.10.2023.
//

import UIKit

class TabBarVC: UITabBarController {

    static var shared:TabBarVC?
    var segmented:SegmentView?
    var sideBar:SidebarManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setBackButton(vc: self)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        TabBarVC.shared = self
        createSegmented()
        sideBar = .init(superVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.delegate = nil
    }
    
    private var viewAppeared:Bool = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//            self.testAI()
//        })
        if !viewAppeared {
            viewAppeared = true
            DispatchQueue(label: "db", qos: .userInitiated).async {
            }
        }
    }
    
    func testAI(canMany:Bool = true) {
        let ai = AppModel.Appearence.ai
        ai.showLoading {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                ai.showAlert(title: canMany ? nil : "some erfewd egrfwd tegrf wer svdcsd rwe", appearence: .with({
                    if canMany {
                        $0.primaryButton = .with({
                            $0.title = "many alerts"
                            $0.action = {
                                for i in 0..<5{
                                    self.testRegulare()
                                }
                            }
                        })
                    } else {
                        $0.primaryButton = .with({
                            $0.style = .link
                            $0.title = "loading test"
                            $0.action = self.loadingTest
                        })
                    }
                    $0.secondaryButton = .with({
                        $0.style = .error
                        $0.close = false
                        $0.action = {
                            self.testAI(canMany: false)
                        }
                        $0.title = "fuck you"
                    })
                    $0.type = canMany ? .internetError : .standard
                }))
            })
            
        }
    }
    
    private func loadingTest() {
        let ai = AppModel.Appearence.ai
        ai.showLoading(title: "some title", completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                ai.showAlert(title: "areer", appearence: .with({
                    $0.image = .image(.add)
                }))
            })
        })
        
    }
    
    private func testRegulare() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            let ai = AppModel.Appearence.ai
//t
        })
    }
    
    
    func segmentedSelected(_ atItem:Int) {
        self.selectedIndex = atItem
    }
    
    //add sidebar
    
    private func createSegmented() {
        let size:CGSize = .init(width: 250, height: 40)
        let segment = SegmentView.init(titles: [
            .init(name: "Random", tintColor: #colorLiteral(red: 0.3449999988, green: 0.3370000124, blue: 0.8389999866, alpha: 1), selectedTextColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), deselectedColor: #colorLiteral(red: 0.3449999988, green: 0.3370000124, blue: 0.8389999866, alpha: 1)),
            .init(name: "Movie list", tintColor: #colorLiteral(red: 0.9100000262, green: 0.9100000262, blue: 0.9100000262, alpha: 1), selectedTextColor: #colorLiteral(red: 0.08600000292, green: 0.08600000292, blue: 0.08600000292, alpha: 1), deselectedColor: #colorLiteral(red: 0.2630000114, green: 0.2630000114, blue: 0.2630000114, alpha: 1))
        ], size: .init(width: size.width, height: size.height), background: #colorLiteral(red: 0.08600000292, green: 0.08600000292, blue: 0.08600000292, alpha: 1), selected: segmentedSelected(_:))
        segmented = segment
        view.addSubview(segment)
        segment.addConstaits([.centerX:0, .top:0, .width:size.width, .height:size.height], superV: self.view, toSafe: true)
        
        viewControllers?.forEach({
            $0.additionalSafeAreaInsets.top = size.height
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
