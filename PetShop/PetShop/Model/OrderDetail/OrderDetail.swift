//
//  OrderDetail.swift
//  PetShop
//
//  Created by Wassay Khan on 05/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class OrderDetail: NSObject {
	var grandTotal:Double?
	var incrementID:String?
	var status:String?
	var orderItems: Array<OrderItems> = []
	
	init(dictionary : NSDictionary){
		self.grandTotal = dictionary["grand_total"] as? Double
		self.incrementID = dictionary["increment_id"] as? String
		self.status = dictionary["status"] as? String
		let arrOrder = dictionary["items"] as! NSArray
		self.orderItems = []
		for order in arrOrder{
			let orderData:OrderItems = OrderItems(dictionary: order as! NSDictionary)
			self.orderItems.append(orderData)
		}
	}
}
