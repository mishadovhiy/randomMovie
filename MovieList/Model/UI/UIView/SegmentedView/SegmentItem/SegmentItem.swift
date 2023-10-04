//
//  SegmentItem.swift
//  MovieList
//
//  Created by Misha Dovhiy on 30.07.2023.
//

import UIKit

class SegmentItem:UIView {
    
    let stackView:UIStackView
    let label:UILabel
    let image:UIImageView
    let name:String
    let selected:(Int)->()
   
    let imgNameHolder:String?
    let id:Int
    
    init(title:String, imgName:String?, id:Int, selected:@escaping (Int)->()) {
        self.name = title
        self.stackView = .init()
        self.label = .init()
        self.imgNameHolder = imgName
        let icon:UIImage? = imgName != "" ? .init(named: imgName ?? "") : nil
        self.image = .init(image: icon)
        self.selected = selected
        self.id = id
        super.init(frame: .zero)
        self.create()
        self.isUserInteractionEnabled = false
        
        self.label.textAlignment = .center
        self.label.adjustsFontSizeToFitWidth = true
        self.image.isHidden = icon == nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
