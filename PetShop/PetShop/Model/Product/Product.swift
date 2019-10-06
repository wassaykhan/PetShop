//
//  Product.swift
//  PetShop
//
//  Created by Wassay Khan on 03/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class Product: NSObject {
	var id:Int?
	var categoryID:Int?
	var name:String?
	var image:String?
	var sku:String?
	var price:Int?
	var weight:Int?
	var quantity:Int?
	var storeId:Int?
	var typeID:String?
	var createdAt:String?
	
	init(dictionary : NSDictionary){
		self.id = dictionary["id"] as? Int
		self.categoryID = dictionary["category_id"] as? Int
		self.image = dictionary["image"] as? String
		self.name = dictionary["name"] as? String
		self.sku = dictionary["sku"] as? String
		self.price = dictionary["price"] as? Int
		self.weight = dictionary["weight"] as? Int
		self.quantity = dictionary["qty"] as? Int
		self.typeID = dictionary["type_id"] as? String
		self.storeId = dictionary["store_id"] as? Int
		self.createdAt = dictionary["created_at"] as? String
	}
}
