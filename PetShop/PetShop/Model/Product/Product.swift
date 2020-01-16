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
	var price:Float?
	var weight:Int?
	var quantity:Int?
	var storeId:Int?
	var typeID:String?
	var createdAt:String?
	var fileImage:String?
	var isConfig:String?
	var itemID:Int?
	
	init(dictionary : NSDictionary){
		self.id = dictionary["id"] as? Int
		self.categoryID = dictionary["category_id"] as? Int
		self.image = dictionary["image"] as? String
		self.name = dictionary["name"] as? String
		self.sku = dictionary["sku"] as? String
		self.price = dictionary["price"] as? Float
		self.weight = dictionary["weight"] as? Int
		self.quantity = dictionary["qty"] as? Int
		self.typeID = dictionary["type_id"] as? String
		self.storeId = dictionary["store_id"] as? Int
		self.createdAt = dictionary["created_at"] as? String
		self.isConfig = dictionary["type_id"] as? String
		var media:NSArray = []
		if dictionary["media_gallery_entries"] != nil {
			media = dictionary["media_gallery_entries"] as! NSArray
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
		
		//			if let typeArr = dic["types"] as? NSArray{
		//				if typeArr.count > 0{
		//
		//				}
		//			}
		//			let image = media[0] as! NSDictionary
		//			let finalImage = image["file"] as! String
		//			urlImageString = PBaseSUrl + "pub/media/catalog/product" + finalImage
		
	}
}
