//
//  PetCategories.swift
//  PetShop
//
//  Created by Wassay Khan on 03/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class PetCategories: NSObject {
	var id:Int?
	var name:String?
	var image:String?
	var childern:String?
	var productArr: Array<Product> = []
	
	init(dictionary : NSDictionary){
		self.id = dictionary["id"] as? Int
		self.image = dictionary["image"] as? String
		self.name = dictionary["name"] as? String
		self.childern = dictionary["children"] as? String
	}
	init(dictionaryWithProduct : NSDictionary){
		self.id = dictionaryWithProduct["id"] as? Int
		self.image = dictionaryWithProduct["image"] as? String
		self.name = dictionaryWithProduct["name"] as? String
		self.childern = dictionaryWithProduct["children"] as? String
		let arr = dictionaryWithProduct["products"] as! NSArray
		self.productArr = []
		for dictChild in arr{
			let categoryData:Product = Product(dictionary: dictChild as! NSDictionary)
			self.productArr.append(categoryData)
		}
	}
	/*
	self.productArr = []
	for dict in orderDictinary["items"] as! NSArray{
	let product:Product = Product(dictionary: dict as! NSDictionary)
	self.productArr.append(product)
	}
*/
}
