//
//  BaseVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 08.05.2022.
//

import UIKit

class BaseVC: UIViewController {

    lazy var message = AppModel.message
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
