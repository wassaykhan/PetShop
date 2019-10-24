//
//  CartTableViewCell.swift
//  PetShop
//
//  Created by Wassay Khan on 19/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

	@IBOutlet weak var imgProduct: UIImageView!
	@IBOutlet weak var lbName: UILabel!
	@IBOutlet weak var lbPrice: UILabel!
	@IBOutlet weak var lbSize: UIButton!
	@IBOutlet weak var lbQuantity: UIButton!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	
	var onSubTapped : (() -> Void)? = nil
	
	@IBAction func btnRemoveProductAction(_ sender: Any) {
		if let onSubTapped = self.onSubTapped {
			onSubTapped()
		}
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
