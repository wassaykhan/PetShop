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
	@IBOutlet weak var btnSize: UIButton!
	@IBOutlet weak var btnQuantity: UIButton!
	@IBOutlet weak var imgProd: UIImageView!
	@IBOutlet weak var heightTop: NSLayoutConstraint!
	@IBOutlet weak var lbSizeHeading: UILabel!
	@IBOutlet weak var viewSecond: UIView!
	@IBOutlet weak var lbSize: UILabel!
	@IBOutlet weak var lbQuantity: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
