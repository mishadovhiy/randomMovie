//
//  SegmentedView.swift
//  MovieList
//
//  Created by Misha Dovhiy on 30.07.2023.
//

import UIKit

class SegmentView:UIView {
    
    let titles:[Segment]
    let selectedIndicator:UIView!
    var selectedShadowView:UIView!
    var selectedIndicatorGradient:CALayer?
    var additionalGradientView:UIView?
    let stackView:UIStackView!
    let size:CGSize
    var selectedIndex:Int = 0
    let selected:(Int)->()
    let mainBackgroundColor:UIColor
    let fontWeight:UIFont.Weight
    
    var radious:CGFloat?
    private var touching = false
    private var touchingIndex = 0
    
    var titleLabels:[SegmentItem] = []
    
    
    init(titles:[Segment], size:CGSize, radious:CGFloat? = nil, background:UIColor?, fontWeight:UIFont.Weight = .regular, selected:@escaping (Int)->()) {
        self.titles = titles
        self.selectedIndicator = .init()
        self.stackView = .init()
        self.size = size
        self.selected = selected
        self.radious = radious
        self.mainBackgroundColor = background ?? .init(hex: "275DBF")!
        self.fontWeight = fontWeight
        super.init(frame: .zero)
        create()
        self.shadow(opasity: Styles.buttonShadow)
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func selectedSegment(_ value:Int) {
        if selectedIndex != value {
            let newValue = value <= 0 ? 0 : (value >= (titles.count - 1) ? (titles.count - 1) : value)
            selectedIndex = newValue
            selected(newValue)
            animateSelected(at: newValue)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: Styles.pressedAnimation) {
            self.selectedShadowView.alpha = 0.8
        }
        touching = true
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchEnded(touches)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if touching {
            let touch = touches.first?.location(in: self)

            let half = selectedIndicator.frame.width
            let index = (touch?.x ?? 0) / half
            let intIndex = Int(index)
            let valid = intIndex <= (titles.count - 1) && intIndex >= 0
            if intIndex != touchingIndex && valid {
                touchingIndex = intIndex
                animateSelected(at: intIndex)
            }
        }
    }
    private func touchEnded(_ touches: Set<UITouch>) {
        let touchingHolder = touching
        touching = false
        UIView.animate(withDuration: Styles.pressedAnimation) {
            self.selectedShadowView.alpha = 1
        }

        if touchingHolder {
            let touch = touches.first?.location(in: self)
            let half = selectedIndicator.frame.width
            let index = (touch?.x ?? 0) / half
            let intIndex = Int(index)
            
            if intIndex != selectedIndex {
                selectedSegment(intIndex)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEnded(touches)
        
    }
    
}

