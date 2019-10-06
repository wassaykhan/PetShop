//
//  OrderItems.swift
//  PetShop
//
//  Created by Wassay Khan on 06/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class OrderItems: NSObject {
	var orderID:Int?
	var price:Float?
	var weight:Float?
	var quantity:Float?
	var name:String?
	
	init(dictionary : NSDictionary){
		self.orderID = dictionary["order_id"] as? Int
		self.price = dictionary["price"] as? Float
		self.weight = dictionary["increment_id"] as? Float
		self.quantity = dictionary["qty_ordered"] as? Float
		self.name = dictionary["name"] as? String
		
	}
}
