//
//  SideBarSliderCell.swift
//  MovieList
//
//  Created by Misha Dovhiy on 05.05.2022.
//

import UIKit

class SideBarSliderCell: UITableViewCell {

    @IBOutlet weak var rangeHolderView: UIView!
    var range:RangeSliderManager?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
