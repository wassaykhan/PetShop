//
//  OrderDetailPTableViewCell.swift
//  PetShop
//
//  Created by Wassay Khan on 20/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class OrderDetailPTableViewCell: UITableViewCell {

	@IBOutlet weak var lbName: UILabel!
	@IBOutlet weak var lbPrice: UILabel!
	@IBOutlet weak var lbSize: UIButton!
	@IBOutlet weak var lbQuantity: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
