//
//  BaseVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 08.05.2022.
//

import UIKit
//var count = 0
class BaseVC: UIViewController {

    lazy var message = AppModel.Appearence.message
    lazy var ai = AppModel.Appearence.ai
    
    private var sbvsLoaded = false
    var apiError:String?
    var appeared:Bool = false
    var dismissedAction:(()->())?
    var updateData:Bool = false
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
        dismissedAction?()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    func firstLayoutSubviews() {
        
    }
    
    func filterChanged() {
        
    }
}
