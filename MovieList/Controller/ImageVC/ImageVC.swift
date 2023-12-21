//
//  ImageVC.swift
//  MovieList
//
//  Created by Misha Dovhiy on 04.10.2023.
//

import UIKit

class ImageVC: BaseVC {

    @IBOutlet weak var imgView: UIImageView!
    var img:UIImage?
    var from:CGRect?
    var fromAdditional:CGPoint?
    var animateBackground:Bool = true
    var fromVC:BaseVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupVCpanGesture = .init(vc: self)
        self.imgView.image = img
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
    }
    

    @objc func dismiss(_ sender:UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImageVC {
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
    }
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
    }
    
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
          //  vc.modalPresentationStyle = .formSheet
          //  vc.modalTransitionStyle = .crossDissolve
            vc.animateBackground = animateBack
            return vc
        } else {
            return nil
        }
    }
}
