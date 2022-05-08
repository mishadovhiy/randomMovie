//
//  LoadingButton.swift
//  MovieList
//
//  Created by Misha Dovhiy on 09.05.2022.
//

import UIKit

class LoadingButton: Button {

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.ai == nil {
            addAi()
        }
    }

    private func addAi() {
        let ai = UIActivityIndicatorView()
        self.ai = ai
        self.addSubview(ai)
        
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .black
        ai.backgroundColor = Text.Colors.white.withAlphaComponent(0.2)
        
        self.addConstraints([
            .init(item: ai, attribute: .trailing, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1.0, constant: 0),
            .init(item: ai, attribute: .leading, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .leading, multiplier: 1.0, constant: 0),
            .init(item: ai, attribute: .top, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0),
            .init(item: ai, attribute: .bottom, relatedBy: .equal, toItem: self.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0),
            .init(item: ai, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: self.frame.width),
            .init(item: ai, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: self.frame.height)
        ])
        ai.hidesWhenStopped = true
        ai.isHidden = self.isEnabled
        self.isEnabled = isEnabled
    }
    
    private var ai:UIActivityIndicatorView?
    
    private func setEnabled(_ value:Bool) {
        if let ai = ai {
            if isEnabled {
                ai.stopAnimating()
            } else {
                if ai.isHidden {
                    ai.isHidden = false
                }
                ai.startAnimating()
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            print(Thread.isMainThread, " isMainThread")
            print(isEnabled)
            setEnabled(isEnabled)
        }
    }
}
