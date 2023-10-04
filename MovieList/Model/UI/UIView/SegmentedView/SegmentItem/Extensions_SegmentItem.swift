//
//  Extensions_SegmentItem.swift
//  MovieList
//
//  Created by Misha Dovhiy on 30.07.2023.
//

import UIKit

extension SegmentItem {
    func create() {
        self.addSubview(stackView)
        stackView.distribution = .equalSpacing
        stackView.spacing = 1
        stackView.alignment = .center
        stackView.addConstaits([.top:0,.bottom:0,.centerX:0], superV: self)
        createContent()
        NSLayoutConstraint.activate([
            self.stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: 0),
            self.stackView.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 0)
        ])
    }
    
    private func createContent() {
        label.text = name
        label.textColor = .white
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .regular)

        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        image.addConstaits([.width:16, .height:16], superV: stackView)
        
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(label)
    }
    
}
