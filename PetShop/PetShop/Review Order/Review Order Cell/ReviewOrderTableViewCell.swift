//
//  ReviewOrderTableViewCell.swift
//  PetShop
//
//  Created by Wassay Khan on 19/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class ReviewOrderTableViewCell: UITableViewCell {

	@IBOutlet weak var lbPrice: UILabel!
	@IBOutlet weak var lbUnitPrice: UILabel!
	@IBOutlet weak var lbQuantity: UILabel!
	@IBOutlet weak var lbName: UILabel!
	@IBOutlet weak var imgProd: UIImageView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
