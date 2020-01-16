//
//  GuestCart.swift
//  PetShop
//
//  Created by Wassay Khan on 17/11/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class GuestCart: NSObject,NSCoding {
	
	var item:[String:AnyObject]?
	var image:String?
	var price:Float?
	var name:String?
	var productType:String?
	var option_id:String?
	var option_value:String?
	var sku:String?
	var qty:Int?
	var quote_id:Int?
	var type:String?
	
	
	init(itemArr : [String:AnyObject], image:String, price:Float, name:String, productType:String,option_id:String,option_value:String,sku:String,qty:Int,quote_id:Int,type:String){
		self.price = price
		self.image = image
		self.item = itemArr
		self.name = name
		self.productType = productType
		self.option_id = option_id
		self.option_value = option_value
		self.sku = sku
		self.qty = qty
		self.quote_id = quote_id
		self.type = type
		
		
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(self.price, forKey: "price")
		aCoder.encode(self.image, forKey: "image")
		aCoder.encode(self.item, forKey: "item")
		aCoder.encode(self.name, forKey: "name")
		aCoder.encode(self.productType, forKey: "productType")
		aCoder.encode(self.option_id, forKey: "option_id")
		aCoder.encode(self.option_value, forKey: "option_value")
		aCoder.encode(self.sku, forKey: "sku")
		aCoder.encode(self.qty, forKey: "qty")
		aCoder.encode(self.quote_id, forKey: "quote_id")
		aCoder.encode(self.type, forKey: "type")
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.price = aDecoder.decodeObject(forKey: "price") as? Float
		self.image = aDecoder.decodeObject(forKey: "image") as? String
		self.item = aDecoder.decodeObject(forKey: "item") as? [String : AnyObject]
		self.name = aDecoder.decodeObject(forKey: "name") as? String
		self.productType = aDecoder.decodeObject(forKey: "productType") as? String
		self.option_id = aDecoder.decodeObject(forKey: "option_id") as? String
		self.option_value = aDecoder.decodeObject(forKey: "option_value") as? String
		self.sku = aDecoder.decodeObject(forKey: "sku") as? String
		self.qty = aDecoder.decodeObject(forKey: "qty") as? Int
		self.quote_id = aDecoder.decodeObject(forKey: "quote_id") as? Int
		self.type = aDecoder.decodeObject(forKey: "type") as? String

	}

}
