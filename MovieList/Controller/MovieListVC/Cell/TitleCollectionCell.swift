//
//  TitleCollectionCell.swift
//  MovieList
//
//  Created by Misha Dovhiy on 08.05.2022.
//

import UIKit

class TitleCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet private weak var mainLabel: UILabel!
    
    private var titleChanged:((_ newValue:String)->())?
    
    func set(title:String, titleChanged:((_ newValue:String)->())? = nil) {
        self.titleChanged = titleChanged
        mainLabel.text = title
        textField.text = title
        if titleChanged != nil {
            textField.delegate = self
        } else if textField.delegate != nil {
            textField.delegate = nil
        }
    }
}
extension TitleCollectionCell:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.alpha = 1
        mainLabel.alpha = 0
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.alpha = 0
        mainLabel.alpha = 1
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mainLabel.text = textField.text
        titleChanged?(textField.text ?? "")
        textField.endEditing(true)
        return true
    }
}
