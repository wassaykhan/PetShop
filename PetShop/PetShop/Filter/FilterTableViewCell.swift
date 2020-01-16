//
//  FilterTableViewCell.swift
//  PetShop
//
//  Created by Wassay Khan on 13/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

	@IBOutlet weak var lbFilter: UILabel!
	@IBOutlet weak var btnFilter: UIButton!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
