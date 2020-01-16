//
//  ProductAttributes.swift
//  PetShop
//
//  Created by Wassay Khan on 04/11/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class ProductAttributes: NSObject {
	var value:String?
	var label:String?
	var weights:NSArray?
	var child_sku:String?
	var weight_custom:String?
	var price:Float?
//	var productAttributes:Array<Attributes>?
	
	
	init(value : String,label : String,weights : NSArray ){
		self.value = value
		self.label = label
		self.weights = weights
//		self.productAttributes = productAttributes
	}
	
	init(sku : String,weight : String,price : Float){
		self.child_sku = sku
		self.weight_custom = weight
		self.price = price
	}
}
