//
//  ShippingAddTableViewCell.swift
//  PetShop
//
//  Created by Wassay Khan on 01/12/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class ShippingAddTableViewCell: UITableViewCell {

	@IBOutlet weak var lbName: UILabel!
	@IBOutlet weak var lbCountry: UILabel!
	@IBOutlet weak var lbStreet: UILabel!
	@IBOutlet weak var imgSelection: UIImageView!
	
	//shipAddID
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
