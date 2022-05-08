//
//  RangeSliderManager.swift
//  RangeSlider
//
//  Created by Misha Dovhiy on 05.05.2022.
//

import UIKit

struct RangeSliderView {
    let min:Double
    let max:Double
    let selectedMin:Double
    let selectedMax:Double
    let digitsCount:Int
}

class RangeSliderManager {
    private let view:UIView
    private let newPosition: ((Double, Double)) -> ()
    var digitsCount:Int
    
    var thumbtimeSeconds: Int = 100
    var isSliderEnd = true
    var rangeSlider: RangeSlider! = nil
    var initSelectedDuration: (Double, Double) = (0, 0)
    
    init(view:UIView,
         range:RangeSliderView,
         newPosition:@escaping ((Double, Double)) -> ()) {
        print("range slider: to: ", range.selectedMax)
        self.digitsCount = range.digitsCount
        self.minValue = range.min
        self.maxValue = range.max
        self.thumbtimeSeconds = Int(range.selectedMax)
        self.selectedMaxValue = range.selectedMax
        self.view = view
        self.newPosition = newPosition
        
        rangeSlider = RangeSlider(frame: view.bounds)
        rangeSlider.lowerValue = range.selectedMin
        loadSliderToVC()
        rangeSlider.sendActions(for: .valueChanged)
    }

    var selectedMaxValue:Double = 0.0
    func rangeAppeared(data:RangeSliderView) {
        self.digitsCount = data.digitsCount
        self.minValue = data.min
        self.maxValue = data.max
        self.thumbtimeSeconds = Int(data.selectedMax)
        DispatchQueue.main.async {
            self.rangeSlider.lowerValue = data.selectedMin
            self.rangeSlider.upperValue = data.selectedMax
            self.digitsCount = data.digitsCount
            self.rangeSlider.sendActions(for: .valueChanged)
        }
    }
    
    var _selectedDuration: (Double, Double) = (0.0, 0.0)
    var selectedDuration: (Double, Double) {
        get {
            _selectedDuration
        }
        set {
            _selectedDuration = newValue
            if initSelectedDuration == (0, 0) {
                initSelectedDuration = newValue
            }
          //  let difference = newValue.1 - newValue.0
            
        }
    }
    
    
    
    
    
    func loadSliderToVC() {
        rangeSlider.addLabels()
        createRangeSlider()
        
    }

    
    
    private func createRangeSlider()
    {
        let subViews = self.view.subviews
      for subview in subViews{
        if subview.tag == 1000 {
          subview.removeFromSuperview()
        }
      }

        
        rangeSlider.digitsCount = digitsCount

        view.addSubview(rangeSlider)
      rangeSlider.tag = 1000

        rangeSlider.addTarget(self, action: #selector(self.rangeSliderValueChanged(_:)), for: .valueChanged)
      
      let time = DispatchTime.now() + Double(Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: time) {
        self.rangeSlider.trackHighlightTintColor = UIColor.clear
        self.rangeSlider.curvaceousness = 1.0
          
      }
    }
    var firstLoad = true
    var minValue:Double
    var maxValue:Double
    @objc func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {

    if(isSliderEnd == true)
    {
      rangeSlider.minimumValue = minValue
      rangeSlider.maximumValue = maxValue
      
        rangeSlider.upperValue = !firstLoad ? Double(thumbtimeSeconds) : self.selectedMaxValue
      isSliderEnd = !isSliderEnd

    }

        selectedDuration = (rangeSlider.lowerValue, rangeSlider.upperValue)
        if !firstLoad {
            newPosition(selectedDuration)
        } else {
            firstLoad = false
        }
        
        
  }
}
