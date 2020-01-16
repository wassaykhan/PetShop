//
//  Attributes.swift
//  PetShop
//
//  Created by Wassay Khan on 17/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class Attributes: NSObject {
	var value:String?
	var label:String?
	
	init(dictionary : NSDictionary){
		self.value = dictionary["value"] as? String
		self.label = dictionary["label"] as? String
	}
}
