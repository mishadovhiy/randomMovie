//
//  BaseVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 08.05.2022.
//

import UIKit
//var count = 0
class BaseVC: UIViewController {

    var appearence:AppModel.Appearence? {
        return AppDelegate.shared?.appearence
    }
    
    private var sbvsLoaded = false
    var apiError:String?
    var appeared:Bool = false
    var updateData:Bool = false
    
    var popupVCpanGesture:PanViewController?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !sbvsLoaded {
            sbvsLoaded = true
            self.additionalSafeAreaInsets.bottom = 65
            self.firstLayoutSubviews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setBackButton(vc:self)
        /*//test message
        if count > 1 {
            count = 0
        }
        
        self.message.show(type: count == 0 ? .internetError : .standart)
        count += 1*/
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appeared = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        
    }

    /// Called when LocalDB set value
    /// Called from AppDelegate
    func dataBaseUpdated() { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    func firstLayoutSubviews() {
        
    }
    
    func filterChanged() {
        
    }
}
