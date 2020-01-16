//
//  AttributeTableViewCell.swift
//  PetShop
//
//  Created by Wassay Khan on 27/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class AttributeTableViewCell: UITableViewCell {

	@IBOutlet weak var lbWeight: UILabel!
	@IBOutlet weak var btnRadio: UIButton!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	@IBOutlet weak var lbPrice: UILabel!
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
