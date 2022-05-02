//
//  PaggingCell.swift
//  MovieList
//
//  Created by Misha Dovhiy on 02.05.2022.
//

import UIKit

class PaggingCell: UITableViewCell {

    @IBOutlet weak var pageStepper: UIStepper!
    @IBOutlet weak var pageLabel: UILabel!
    var valueSteppedAction:((Double) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    @IBAction private func valueStepped(_ sender: UIStepper) {
        if let val = valueSteppedAction {
            val(sender.value)
        }
    }
    
    
    
    
}
