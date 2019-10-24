//
//  Cart.swift
//  PetShop
//
//  Created by Wassay Khan on 07/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class Cart: NSObject {
	var itemID:Int?
	var price:Float?
	var productType:String?
	var quantity:Float?
	var name:String?
	var sku:String?
	
	init(dictionary : NSDictionary){
		self.itemID = dictionary["item_id"] as? Int
		self.price = dictionary["price"] as? Float
		self.productType = dictionary["product_type"] as? String
		self.quantity = dictionary["qty"] as? Float
		self.name = dictionary["name"] as? String
		self.sku = dictionary["sku"] as? String
		
	}
}
