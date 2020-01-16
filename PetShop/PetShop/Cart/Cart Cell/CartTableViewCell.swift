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
	@IBOutlet weak var lbQty: UILabel!
	@IBOutlet weak var lbSizeValue: UILabel!
	@IBOutlet weak var viewBot: UIView!
	@IBOutlet weak var heightTopName: NSLayoutConstraint!

	@IBOutlet weak var heightLbSize: NSLayoutConstraint!
	@IBOutlet weak var widthLbSize: NSLayoutConstraint!
	@IBOutlet weak var lbCustomName: UILabel!
	var onSubTapped : (() -> Void)? = nil
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	
	
	
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
