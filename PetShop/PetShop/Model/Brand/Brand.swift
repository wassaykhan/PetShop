//
//  Brand.swift
//  PetShop
//
//  Created by Wassay Khan on 04/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class Brand: NSObject {
	var label:String?
	var value:String?
	
	init(dictionary : NSDictionary){
		self.label = dictionary["display"] as? String
		self.value = dictionary["value"] as? String
	}
}
