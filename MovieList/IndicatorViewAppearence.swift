//
//  IndicatorViewAppearence.swift
//  Budget Tracker
//
//  Created by Mikhailo Dovhyi on 31.03.2022.
//  Copyright © 2022 Misha Dovhiy. All rights reserved.
//

import UIKit


extension AlertViewLibraryy {
    func setBacground(higlight:Bool, ai:Bool) {
        DispatchQueue.main.async {
            let higlighten = {
                UIView.animate(withDuration: 0.3) {
                    self.backgroundView.backgroundColor = ai ? self.normalBackgroundColor : self.accentBackgroundColor
                }
            }
            if higlight {
                UIView.animate(withDuration: 0.3) {
                    self.mainView.layer.shadowOpacity = 0.9
                    self.titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
                    self.backgroundView.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.8)
                } completion: { _ in
                    higlighten()
                }
            } else {
                higlighten()
            }
            
        }
    }
    
    func buttonStyle(_ button:UIButton, type:button) {
        DispatchQueue.main.async {
            button.setTitleColor(self.buttonToColor(type.style), for: .normal)
            button.setTitle(type.title, for: .normal)
            if button.isHidden != false {
                button.isHidden = false
            }
            if button.superview?.isHidden != false {
                button.superview?.isHidden = false
            }
        }
    }
    
    private func buttonToColor(_ type:ButtonType) -> UIColor {
        switch type {
        case .error: return .red
        case .link: return linkColor
        case .regular: return regularColor
        }
    }
    
    func getAlertImage(image:Image?, type:ViewType) -> UIImage? {
        if let image = image {
            return .init(named: image.rawValue)
        } else {
            let error:UIImage? = (type == .error || type == .internetError) ? .init(named: Image.error.rawValue) : nil
            let scs:UIImage? = (type == .succsess) ? .init(named: Image.succsess.rawValue) : nil
            return error ?? (scs ?? nil)
        }
    }
    
}
