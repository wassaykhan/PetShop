//
//  WishlistTableViewCell.swift
//  PetShop
//
//  Created by Wassay Khan on 27/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class WishlistTableViewCell: UITableViewCell {

	@IBOutlet weak var imgProd: UIImageView!
	@IBOutlet weak var lbTitle: UILabel!
	@IBOutlet weak var imgPrice: UILabel!
	
	var onSubTapped : (() -> Void)? = nil
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	@IBAction func btnDeleteAction(_ sender: Any) {
		if let onSubTapped = self.onSubTapped {
			onSubTapped()
		}
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
