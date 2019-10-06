//
//  Slider.swift
//  PetShop
//
//  Created by Wassay Khan on 02/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class Slider: NSObject {
	var id:String?
	var link:String?
	var name:String?
	
	init(dictionary : NSDictionary){
		self.id = dictionary["id"] as? String
		self.link = dictionary["link"] as? String
		self.name = dictionary["name"] as? String
	}
}
