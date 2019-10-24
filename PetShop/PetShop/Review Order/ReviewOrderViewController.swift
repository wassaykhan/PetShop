//
//  ReviewOrderViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 19/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SVProgressHUD

class ReviewOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var reviewTableView: UITableView!
	@IBOutlet weak var lbSubtotal: UILabel!
	@IBOutlet weak var lbFlatRateShipping: UILabel!
	@IBOutlet weak var lbTotalOrder: UILabel!
	@IBOutlet weak var lbMainTotalOrder: UILabel!
	
	var cartArr:Array<Cart> = []
	var total:Float = 0.0
	
	override func viewDidLoad() {
        super.viewDidLoad()
		let customerToken = UserDefaults.standard.string(forKey: "customerToken")
		if customerToken != nil {
			self.lbSubtotal.text = "AED " + String(total)
			self.lbTotalOrder.text = "AED " + String(total)
			self.lbMainTotalOrder.text = "AED " + String(total)
			self.getCartDetail()
		}
		self.estimateShippingDetail()
        // Do any additional setup after loading the view.
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.cartArr.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 131
		
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellOrder:ReviewOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reviewCellIdentifier", for: indexPath) as! ReviewOrderTableViewCell
		cellOrder.lbName.text = self.cartArr[indexPath.row].name
		if self.cartArr[indexPath.row].quantity != nil {
			cellOrder.lbQuantity.text = String(format: "Quantity: %.2f", self.cartArr[indexPath.row].quantity!)
		}
		if self.cartArr[indexPath.row].price != nil {
			cellOrder.lbUnitPrice.text = String(format: "Unit Price: AED %.2f", self.cartArr[indexPath.row].price!)
		}
		if self.cartArr[indexPath.row].price != nil {
			cellOrder.lbPrice.text = String(format: "AED %.2f", self.cartArr[indexPath.row].price!)
		}
		return cellOrder
	}
	
	@IBAction func btnApplyPromoAction(_ sender: Any) {
	}
	
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func btnPlaceOrderAction(_ sender: Any) {
		self.setBillingShippingDetail()
	}
	
	
	
	/*
	UserDefaults.standard.set(self.user?.firstName, forKey: "firstName")
	UserDefaults.standard.set(self.user?.lastName, forKey: "lastName")
	UserDefaults.standard.set(self.user?.email, forKey: "email")
	UserDefaults.standard.set(self.user?.userID, forKey: "id")
	UserDefaults.standard.set(self.user?.add1, forKey: "add1")
	UserDefaults.standard.set(self.user?.add2, forKey: "add2")
	UserDefaults.standard.set(self.user?.telephone, forKey: "telephone")
	*/
	
	func setBillingShippingDetail() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PShippingInformation
			let firstName = UserDefaults.standard.string(forKey: "firstName")
			let lastName = UserDefaults.standard.string(forKey: "lastName")
			let telephone = UserDefaults.standard.string(forKey: "telephone")
			let add1 = UserDefaults.standard.string(forKey: "add1")
			let add2 = UserDefaults.standard.string(forKey: "add2")
			
			let email = UserDefaults.standard.string(forKey: "email")
			let shippingAddress:[String:AnyObject] = ["lastname":lastName as AnyObject,"firstname" : firstName as AnyObject,
													  "postcode" : "10577" as AnyObject,
													  "street" : [add1,add2] as AnyObject,
													  "city": "AL" as AnyObject,
													  "same_as_billing": 1 as AnyObject,
													  "country_id" :"AE" as AnyObject,
													  "telephone" : telephone as AnyObject,
													  "customer_id" : customerID as AnyObject,
													  "email" : email as AnyObject]
			let billingAddress:[String:AnyObject] = ["lastname":lastName as AnyObject,"firstname" : firstName as AnyObject,
													 "postcode" : "10577" as AnyObject,
													 "street" : [add1,add2] as AnyObject,
													 "city": "AL" as AnyObject,
													 "same_as_billing": 1 as AnyObject,
													 "country_id" :"AE" as AnyObject,
													 "telephone" : telephone as AnyObject,
													 "customer_id" : customerID as AnyObject,
													 "email" : email as AnyObject]
			
			let addressInformation:[String:AnyObject] = ["shipping_address":shippingAddress as AnyObject, "billing_address":billingAddress as AnyObject, "shipping_carrier_code" : "tablerate" as AnyObject, "shipping_method_code" : "bestway" as AnyObject]
			
			let param:[String:AnyObject] = [
				"addressInformation" : addressInformation as AnyObject
			]
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			
			AlamofireCalls.postCallAnyWithHeaderDict(urlString: urlString, parameters: param, headers: headers, completion: {
				(token) -> Void in
				print("from Shipping")
				print(token)
				self.purchaseOrder()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func purchaseOrder() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PPlaceOrder
			let firstName = UserDefaults.standard.string(forKey: "firstName")
			let lastName = UserDefaults.standard.string(forKey: "lastName")
			let telephone = UserDefaults.standard.string(forKey: "telephone")
			let add1 = UserDefaults.standard.string(forKey: "add1")
			let add2 = UserDefaults.standard.string(forKey: "add2")
			
						let email = UserDefaults.standard.string(forKey: "email")
			let attributes:[String:AnyObject] = ["comment":"abc" as AnyObject,"subscribe" : false as AnyObject,"agreement_ids": ["2"] as AnyObject]
			let paymentMethod:[String:AnyObject] = ["method":"cashondelivery" as AnyObject,"extension_attributes" : attributes as AnyObject]
			let billingAddress:[String:AnyObject] = ["lastname":lastName as AnyObject,"firstname" : firstName as AnyObject,
													 "postcode" : "10577" as AnyObject,
													 "street" : [add1,add2] as AnyObject,
													 "city": "AL" as AnyObject,
													 "same_as_billing": 1 as AnyObject,
													 "country_id" :"AE" as AnyObject,
													 "telephone" : telephone as AnyObject,
													 "customer_id" : customerID as AnyObject,
													 "email" : email as AnyObject]
			
			let param:[String:AnyObject] = ["paymentMethod":paymentMethod as AnyObject, "billing_address":billingAddress as AnyObject]
			
			//			let param:[String:AnyObject] = [
			//				"addressInformation" : addressInformation as AnyObject
			//			]
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			
			AlamofireCalls.postCallAnyWithHeaderDictString(urlString: urlString, parameters: param, headers: headers, completion: {
				(token) -> Void in
				print("from Shipping")
				print(token)
				if self.tabBarController!.selectedIndex == 0 {
					let alert = UIAlertController(title: "Order Place", message: "Thank you for placing your order at Petshop", preferredStyle: UIAlertController.Style.alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
						let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
						self.navigationController?.pushViewController(nextViewController, animated: true)
						
					}))
					self.present(alert, animated: true, completion: nil)
				}else {
					let alert = UIAlertController(title: "Order Place", message: "Thank you for placing your order at Petshop", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					self.present(alert, animated: true, completion: nil)
				}
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func estimateShippingDetail() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let customerID = UserDefaults.standard.integer(forKey: "id")
			let firstName = UserDefaults.standard.string(forKey: "firstName")
			let lastName = UserDefaults.standard.string(forKey: "lastName")
			let telephone = UserDefaults.standard.string(forKey: "telephone")
			let add1 = UserDefaults.standard.string(forKey: "add1")
			let add2 = UserDefaults.standard.string(forKey: "add2")
			let urlString =  PBaseUrl + PEstimateShipping
			let email = UserDefaults.standard.string(forKey: "email")
			let address:[String:AnyObject] = ["lastname":lastName as AnyObject,"firstname" : firstName as AnyObject,
											  "postcode" : "10577" as AnyObject,
											  "street" : [add1,add2] as AnyObject,
											  "city": "Purchase" as AnyObject,
											  "same_as_billing": 1 as AnyObject,
											  "country_id" :"AE" as AnyObject,
											  "telephone" : telephone as AnyObject,
											  "customer_id" : customerID as AnyObject,
											  "email" : email as AnyObject]
			
			let param:[String:AnyObject] = [
				"address" : address as AnyObject
			]
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			
			AlamofireCalls.postCallAnyWithHeader(urlString: urlString, parameters: param, headers: headers, completion: {
				(token) -> Void in
				print("from Shipping")
				print(token)
//				let alert = UIAlertController(title: "Confirm Payment", message: "Your total ammount is AED 200.00", preferredStyle: UIAlertController.Style.actionSheet)
//
//				alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
//					print("Yay! You brought your towel!")
////					self.setBillingShippingDetail()
//				}))
//				alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//				//				alert.addAction(defaultAction)
//				self.present(alert, animated: true, completion: nil)
				//alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
				//print("Yay! You brought your towel!")
				//}))
				
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func getCartDetail(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PCart
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCall(urlString: encodedUrl!, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				var totalPrice:Float = 0.0
				for dictionary in success{
					let prod:Cart = Cart(dictionary: dictionary as! NSDictionary)
					totalPrice += prod.price!
					self.cartArr.append(prod)
				}
				self.lbSubtotal.text = "AED " + String(totalPrice)
				self.reviewTableView.reloadData()
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
