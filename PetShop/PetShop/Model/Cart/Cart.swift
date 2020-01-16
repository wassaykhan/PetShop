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
	var guestData:GuestCart?
	var image:String?
	var fileImage:String?
	var weight:String?
	var value:String?
	
	
	init(dictionary : NSDictionary){
		self.itemID = dictionary["item_id"] as? Int
		
		self.productType = dictionary["product_type"] as? String
		self.quantity = dictionary["qty"] as? Float
		self.name = dictionary["name"] as? String
		self.sku = dictionary["sku"] as? String
		
		//setting custom attribute
		var w = ""
		if let weightAtt = dictionary["att_value"] as? String{
			w = weightAtt
		}
		self.weight = w
		
		var v = ""
		if let valueAtt = dictionary["att_name"] as? String{
			v = valueAtt
		}
		self.value = v
		
		let itemDetail = dictionary["item_detail"] as! NSDictionary
		self.price = itemDetail["price"] as? Float
		var media:NSArray = []
		if itemDetail["media_gallery_entries"] != nil {
			media = itemDetail["media_gallery_entries"] as! NSArray
		}
		var urlImageString = ""
		if media.count > 0 {
			for item in media{
				let itemDict = item as! NSDictionary
				if let typeArr = itemDict["types"] as? NSArray{
					if typeArr.count > 1{
						//						let image = media[0] as! NSDictionary
						let finalImage = itemDict["file"] as! String
						urlImageString = PBaseSUrl + "pub/media/catalog/product" + finalImage
					}
				}
			}
		}
		
		self.fileImage = urlImageString
		
		/*
		var custom:NSArray = []
		if itemDetail["custom_attributes"] != nil {
			custom = itemDetail["custom_attributes"] as! NSArray
		}
		
		var w = ""
		if custom.count > 0 {
			for item in custom{
				let itemDict = item as! NSDictionary
				let attributeCode = itemDict["attribute_code"] as! String
				if attributeCode == "weight_custom"{
					w = itemDict["value"] as! String
				}
			}
		}
		self.weight = w
		*/
		
		
		
	}
	
	
	
	init(guestData:GuestCart){
		self.guestData = guestData
	}
	
	
	
}


/*
var itemID:Int?
var price:Float?
var productType:String?
var quantity:Float?
var name:String?
var sku:String?
var guestData:GuestCart?
var image:String?


init(dictionary : NSDictionary){
self.itemID = dictionary["item_id"] as? Int
self.price = dictionary["price"] as? Float
self.productType = dictionary["product_type"] as? String
self.quantity = dictionary["qty"] as? Float
self.name = dictionary["name"] as? String
self.sku = dictionary["sku"] as? String
}

init(guestData:GuestCart){
self.guestData = guestData
}
*/
