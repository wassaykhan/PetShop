//
//  Filter.swift
//  PetShop
//
//  Created by Wassay Khan on 14/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class Filter: NSObject {
	
	var count:String?
	var display:String?
	var value:String?
	
	init(dictionary : NSDictionary){
		self.count = dictionary["count"] as? String
		self.display = dictionary["display"] as? String
		self.value = dictionary["value"] as? String
		
	}
}
