//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by Misha Dovhiy on 05.05.2022.
//

import UIKit


class RangeSliderTrackLayer: CALayer {
    weak var rangeSlider: RangeSlider?
    
    override func draw(in ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }
        
        // Clip
        let cornerRadius = bounds.height * slider.curvaceousness / 2.0
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        
        // Fill the track
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        
        // Fill the highlighted range
        ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
        let lowerValuePosition = CGFloat(slider.positionForValue(slider.lowerValue))
        let upperValuePosition = CGFloat(slider.positionForValue(slider.upperValue))
        let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
        ctx.fill(rect)
    }
}

class RangeSliderThumbLayer: CALayer {
  
    
    
    var highlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    weak var rangeSlider: RangeSlider?
    
    var strokeColor: UIColor = UIColor.gray {
        didSet {
            setNeedsDisplay()
        }
    }
    var lineWidth: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    

    
    override func draw(in ctx: CGContext) {
        guard let slider = rangeSlider else {
            return
        }
        
        let thumbFrame = bounds.insetBy(dx: 2.0, dy: 2.0)
        let cornerRadius = thumbFrame.height * slider.curvaceousness / 2.0
        let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
        
        // Fill
        ctx.setFillColor(slider.thumbTintColor.cgColor)
        ctx.addPath(thumbPath.cgPath)
        ctx.fillPath()
        
        // Outline
        ctx.setStrokeColor(strokeColor.cgColor)
        ctx.setLineWidth(lineWidth)
        ctx.addPath(thumbPath.cgPath)
        ctx.strokePath()
        
        if highlighted {
            ctx.setFillColor(Text.Colors.lightGrey.cgColor)
            ctx.addPath(thumbPath.cgPath)
            ctx.fillPath()
        }
    }
}

@IBDesignable
class RangeSlider: UIControl {

    fileprivate var thumbWidth: CGFloat = 30
    fileprivate var thumbHeight: CGFloat = 30
    
    var upperLabel:UILabel?
    var lowerLabel:UILabel?
    
    @IBInspectable var lowerValue: Double = 0.0 {
        didSet {
            updateLayerFrames()
            newValue(upper: false)
        }
    }
    
    @IBInspectable var upperValue: Double = 100 {
        didSet {
            print(upperValue)
            updateLayerFrames()
            newValue(upper: true)
        }
    }
    
    func addLabels() {
        DispatchQueue.main.async {
            let uppar =  UILabel(frame: CGRect(x: -5, y: -7, width: 40, height: 15))
            uppar.textAlignment = .right
            uppar.textColor = .black
            uppar.alpha = 1
            uppar.textAlignment = .center
            uppar.font = .systemFont(ofSize: 12)
            uppar.adjustsFontSizeToFitWidth = true
            uppar.backgroundColor = Text.Colors.white.withAlphaComponent(0.7)
            uppar.layer.cornerRadius = Styles.buttonRadius
            uppar.layer.masksToBounds = true
            self.upperLabel = uppar
            self.addSubview(uppar)
            
            let lower = UILabel(frame: CGRect(x: -5, y: -7, width: 40, height: 15))
            lower.textColor = .black
            lower.textAlignment = .center
            lower.alpha = 1
            lower.font = .systemFont(ofSize: 12)
            lower.adjustsFontSizeToFitWidth = true
            lower.layer.masksToBounds = true
            lower.backgroundColor = Text.Colors.white.withAlphaComponent(0.7)
            lower.layer.cornerRadius = Styles.buttonRadius
            self.lowerLabel = lower
            self.addSubview(lower)
            self.newValue(upper: true)
            self.newValue(upper: false)
        }
    }
    
  
  @IBInspectable var lowerLayerSelected = Bool()

    @IBInspectable var minimumValue: Double = 0.0 {
        willSet(newValue) {
            assert(newValue < maximumValue, "RangeSlider: minimumValue should be lower than maximumValue")
        }
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable var maximumValue: Double = 3000 {
        willSet(newValue) {
            assert(newValue > minimumValue, "RangeSlider: maximumValue should be greater than minimumValue")
        }
        didSet {
            updateLayerFrames()
        }
    }
    
    
    
    private func newValue(upper:Bool) {
        if upper {
            DispatchQueue.main.async {
                self.upperLabel?.text = String.init(decimalsCount: self.digitsCount, from: self.upperValue)
            }
        } else {
            DispatchQueue.main.async {
                self.lowerLabel?.text = String.init(decimalsCount: self.digitsCount, from: self.lowerValue)
            }
        }
    }
    
    var digitsCount = 2
    
    var gapBetweenThumbs: Double {
        return 0.6 * Double(thumbWidth) * (maximumValue - minimumValue) / Double(bounds.width)
    }
    
    @IBInspectable var trackTintColor: UIColor = UIColor.clear {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable var trackHighlightTintColor: UIColor = UIColor.clear {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable var thumbTintColor: UIColor = Text.Colors.white {
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable var thumbBorderColor: UIColor = UIColor.gray {
        didSet {
            lowerThumbLayer.strokeColor = thumbBorderColor
            upperThumbLayer.strokeColor = thumbBorderColor
        }
    }
    
    @IBInspectable var thumbBorderWidth: CGFloat = 0.5 {
        didSet {
            lowerThumbLayer.lineWidth = thumbBorderWidth
            upperThumbLayer.lineWidth = thumbBorderWidth
        }
    }
    
    @IBInspectable var curvaceousness: CGFloat = 1.0 {
        didSet {
            if curvaceousness < 0.0 {
                curvaceousness = 0.0
            }
            
            if curvaceousness > 1.0 {
                curvaceousness = 1.0
            }
            
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    fileprivate var previouslocation = CGPoint()
    
    let trackLayer = RangeSliderTrackLayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    
    
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeLayers()
    }
    
    override func layoutSublayers(of: CALayer) {
        super.layoutSublayers(of:layer)
        updateLayerFrames()
    }
    
    fileprivate func initializeLayers() {
        layer.backgroundColor = UIColor.clear.cgColor
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.main.scale
      
        layer.addSublayer(lowerThumbLayer)
      
      
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperThumbLayer)
    }
    
    func updateLayerFrames() {
        let lineStyle = !(thumbWidth == thumbHeight)
        let yPosition:CGFloat = lineStyle ? -5.0 : 10
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            
            self.trackLayer.frame = self.bounds.insetBy(dx: 0.0, dy: self.bounds.height/3)
            self.trackLayer.setNeedsDisplay()
            
            let lowerThumbCenter = CGFloat(self.positionForValue(self.lowerValue))
            let lowerX = lowerThumbCenter - self.thumbWidth/2.0
            self.lowerLabel?.layer.transform = CATransform3DTranslate(CATransform3DIdentity, lowerX, 0, 0)
            //"\(self.lowerValue)"
            self.lowerThumbLayer.frame = CGRect(x: lowerX, y: yPosition, width: self.thumbWidth, height: self.thumbHeight)
            self.lowerThumbLayer.setNeedsDisplay()
            
            let upperThumbCenter = CGFloat(self.positionForValue(self.upperValue))
            let upperX = upperThumbCenter - self.thumbWidth/2.0
            self.upperLabel?.layer.transform = CATransform3DTranslate(CATransform3DIdentity, upperX, 0, 0)
            //"\(self.upperValue)"
            self.upperThumbLayer.frame = CGRect(x: upperX, y: yPosition, width: self.thumbWidth, height: self.thumbHeight)
            self.upperThumbLayer.setNeedsDisplay()
            
            CATransaction.commit()
        }
    }
    
    func positionForValue(_ value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) + Double(thumbWidth/2.0)
    }
    
    func boundValue(_ value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    
    // MARK: - Touches
    

    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previouslocation = touch.location(in: self)
        isHighlighted = true

        // Hit test the thumb layers
        if lowerThumbLayer.frame.contains(previouslocation) {
            
            lowerThumbLayer.highlighted = true
            lowerLayerSelected = lowerThumbLayer.highlighted
            
         /*   DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    self.lowerLabel?.alpha = 1
                }
            }*/

        } else if upperThumbLayer.frame.contains(previouslocation) {
            upperThumbLayer.highlighted = true
            lowerLayerSelected = lowerThumbLayer.highlighted
           /* DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    self.upperLabel?.alpha = 1
                }
            }*/

        }
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        isHighlighted = true
        let location = touch.location(in: self)
        
        // Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previouslocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - bounds.height)
        
        previouslocation = location
        
        // Update the values
        if lowerThumbLayer.highlighted {
            lowerValue = boundValue(lowerValue + deltaValue, toLowerValue: minimumValue, upperValue: upperValue - gapBetweenThumbs)
        } else if upperThumbLayer.highlighted {
            upperValue = boundValue(upperValue + deltaValue, toLowerValue: lowerValue + gapBetweenThumbs, upperValue: maximumValue)
        }
        
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
        isHighlighted = false
        self.sendActions(for: .valueChanged)
       /* DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.5) {
                self.lowerLabel?.alpha = 0
                self.upperLabel?.alpha = 0
            }
        }*/
    }
}
