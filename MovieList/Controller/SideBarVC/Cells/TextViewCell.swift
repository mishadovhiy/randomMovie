//
//  TextViewCell.swift
//  MovieList
//
//  Created by Mykhailo Dovhyi on 15.09.2025.
//

import UIKit

class TextViewCell: UITableViewCell {
    
    @IBOutlet weak private var textView: UITextView!
    private var textDidChange: ((_ newText: String)->())?
    
    func set(text: String, textChanged: @escaping(_ newText: String)->()) {
        textView.text = text
        textDidChange = textChanged
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [flexSpace, closeButton]

        textView.inputAccessoryView = toolbar

    }
    
    @objc func dismissKeyboard() {
        textView.resignFirstResponder()
    }
}

extension TextViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textDidChange?(textView.text)
    }
}
