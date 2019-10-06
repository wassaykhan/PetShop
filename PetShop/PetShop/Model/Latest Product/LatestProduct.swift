//
//  LatestProduct.swift
//  PetShop
//
//  Created by Wassay Khan on 03/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class LatestProduct: NSObject {
	
	var id:Int?
	var name:String?
	var price:Float?
	var file:String?
	var sku:String?
	
	
	init(dictionary : NSDictionary){
		self.id = dictionary["id"] as? Int
		self.price = dictionary["price"] as? Float
		self.name = dictionary["name"] as? String
		self.sku = dictionary["sku"] as? String
		let imageLink = dictionary["media_gallery_entries"] as! NSArray
		for item in imageLink {
			let getDict = item as! NSDictionary
			self.file = getDict["file"] as! String?
		}
	}

}
