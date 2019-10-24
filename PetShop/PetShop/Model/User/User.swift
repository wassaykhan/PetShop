//
//  User.swift
//  PetShop
//
//  Created by Wassay Khan on 18/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class User: NSObject {
	var userID:Int?
	var email:String?
	var firstName:String?
	var lastName:String?
	var telephone:String?
	var add1:String?
	var add2:String?
	
	
	init(dictionary : NSDictionary){
		self.userID = dictionary["id"] as? Int
		self.email = dictionary["email"] as? String
		self.firstName = dictionary["firstname"] as? String
		self.lastName = dictionary["lastname"] as? String
		let address = dictionary["addresses"] as! NSArray
		var data:NSDictionary = [:]
		for addressData in address {
			data = addressData as! NSDictionary
		}
		self.telephone = data["telephone"] as? String
		let street = data["street"] as! NSArray
		if street.count > 0{
			self.add1 = street[0] as? String
			if street.count > 1 {
				self.add2 = street[1] as? String
			}else{
				self.add2 = street[0] as? String
			}
		}else{
			self.add1 = ""
			self.add2 = ""
		}
		
	}
}

