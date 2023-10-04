//
//  Extensions_SegmentedView.swift
//  MovieList
//
//  Created by Misha Dovhiy on 30.07.2023.
//

import UIKit

extension SegmentView {

    struct Segment {
        let name:String
        var iconName:String? = nil
        let tintColor:UIColor
        let selectedTextColor:UIColor
        var deselectedColor:UIColor? = nil
    }
    
    func animateSelected(at:Int) {
        let one = self.size.width / CGFloat(titles.count)
        let transform = one * CGFloat(at)
        let hideGradient:Bool = true//titles[at].hideGradient
        let shadowColor:UIColor = titles[at].tintColor
        let selectedBackgroundColor:UIColor = titles[at].tintColor


        self.titleLabels.forEach { label in
            let tint = self.titles[label.tag].selectedTextColor
            let color = label.tag == at ? tint : (self.titles[label.tag].deselectedColor ?? tint)
            
            UIView.animate(withDuration: 0.6) {
                label.label.textColor = color
            }
        }
        
        UIView.animate(withDuration: Styles.pressedAnimation + 0.1) {
            self.selectedShadowView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, transform, 0, 0)
            self.selectedIndicator.layer.transform = CATransform3DTranslate(CATransform3DIdentity, transform, 0, 0)
            self.additionalGradientView?.alpha = hideGradient ? 0 : 1
            self.selectedIndicatorGradient?.opacity = hideGradient ? 0 : 1
            self.selectedShadowView.layer.shadow(opasity: !hideGradient ? 0.8 : 0.9, color: shadowColor, radius: !hideGradient ? 7 : 8)
            self.selectedIndicator.backgroundColor = selectedBackgroundColor
        }
    }

}

