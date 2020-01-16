//
//  AddressTableViewCell.swift
//  PetShop
//
//  Created by Wassay Khan on 24/11/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

	@IBOutlet weak var lbName: UILabel!
	@IBOutlet weak var lbAddress: UILabel!
	@IBOutlet weak var lbCountry: UILabel!
	@IBOutlet weak var lbCity: UILabel!
	@IBOutlet weak var lbTelephone: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
