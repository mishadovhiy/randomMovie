//
//  HeartButton.swift
//  MovieList
//
//  Created by Misha Dovhiy on 05.10.2023.
//

import UIKit

class HeartButton: Button {
    
    func animateImage(like:Bool) {
        if let img = self.image(for: .normal) {
            var startX:CGFloat = -50
            let maxX:CGFloat = 70
            let count = Int.random(in: 6..<(Int.random(in: 8..<10)))
            let stepX:CGFloat = (maxX + (startX * CGFloat(-1))) / CGFloat(count)
            
            
            for i in 0..<count {
                let new = UIImageView()
                new.translatesAutoresizingMaskIntoConstraints = true
                self.addSubview(new)
                let widthMult:CGFloat = [0.5, 0.8, 1.0, 0.88, 0.9, 0.45].randomElement() ?? 0
                new.frame = .init(x: 0, y: 0, width: self.frame.size.width * widthMult, height: self.frame.size.height * widthMult)
                new.image = img
                new.layer.zPosition = -1
                new.tintColor = self.tintColor
                let y = startX
                startX += stepX
                let stepYCalc = stepX * CGFloat(i)
                let stepY = stepYCalc >= maxX ? (stepYCalc - maxX) : stepYCalc
                let plasX = [-10, -12, 2, 5, 10, -5, -8, -2, 8, 3].randomElement() ?? 0
                let plasY = [1, 4, 2, 5, 12, 10, 9, 12, 8, 3].randomElement() ?? 0
                UIView.animate(withDuration: 1.1, delay: 0, animations: {
                    new.frame.origin = .init(x: (y + CGFloat(plasX)), y: ((stepY + CGFloat(plasY)) * -1))
                }, completion:{ _ in
                    new.removeFromSuperview()
                })
                UIView.animate(withDuration: 0.5, delay: 0.6, animations: {
                    new.alpha = 0
                })
            }
            
        }
    }

}
