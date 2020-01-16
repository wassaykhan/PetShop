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

	@IBOutlet weak var shipAddTableView: UITableView!
	@IBOutlet weak var reviewTableView: UITableView!
	@IBOutlet weak var lbSubtotal: UILabel!
	@IBOutlet weak var lbFlatRateShipping: UILabel!
	@IBOutlet weak var lbTotalOrder: UILabel!
	@IBOutlet weak var lbMainTotalOrder: UILabel!
	@IBOutlet weak var VAT: UILabel!
	@IBOutlet weak var totalVat: UILabel!
	@IBOutlet weak var heightShipAdd: NSLayoutConstraint!
	@IBOutlet weak var heightReviewTV: NSLayoutConstraint!
	@IBOutlet weak var viewShipAdd: UIView!
	@IBOutlet weak var textCode: UITextField!
	
	var cartArr:Array<Cart> = []
	var total:Float = 0.0
	var arrUser:Array<User> = []
	var defaultAdd = 0
	var isOrderPlace = false
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
		self.getAccountDetail()
		self.setBillingShippingDetail()
		
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		/*
		let customerToken = UserDefaults.standard.string(forKey: "customerToken")
		if customerToken != nil {
			
//			if total > 100{
//				print("no shipping cost")
//			}else{
//				total = total + 100
//
//			}
			
			self.lbSubtotal.text = String(format: "AED %.2f", total)//"AED " + String(total)
//			self.lbTotalOrder.text = "AED " + String(total)
			let tax = total*0.05
			self.VAT.text = String(format: "AED %.2f", tax)//"AED " + String(tax)
			let totaltax = total - tax
			self.totalVat.text = String(format: "AED %.2f", totaltax)//String(totaltax)
			self.lbMainTotalOrder.text = String(format: "AED %.2f", total)//"AED " + String(total)
			self.getCartProduct()
		}
//		self.estimateShippingDetail()
        // Do any additional setup after loading the view.
		*/
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView == self.reviewTableView{
			return self.cartArr.count
		}else{
			return self.arrUser.count
		}
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		if tableView == self.reviewTableView{
			return 131
		}else{
			return 76
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.defaultAdd = indexPath.row
		self.shipAddTableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if tableView == self.reviewTableView{
			let cellOrder:ReviewOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reviewCellIdentifier", for: indexPath) as! ReviewOrderTableViewCell
			cellOrder.lbName.text = self.cartArr[indexPath.row].name
			if self.cartArr[indexPath.row].quantity != nil {
				cellOrder.lbQuantity.text = String(format: "Quantity: %.0f", self.cartArr[indexPath.row].quantity!)
			}
			if self.cartArr[indexPath.row].price != nil {
				cellOrder.lbUnitPrice.text = String(format: "Unit Price: AED %.2f", self.cartArr[indexPath.row].price!)
			}
			if self.cartArr[indexPath.row].price != nil {
				cellOrder.lbPrice.text = String(format: "Total Price: AED %.2f", self.cartArr[indexPath.row].price!)
			}
			if self.cartArr[indexPath.row].fileImage != nil {
				cellOrder.imgProd.sd_setImage(with: URL(string:self.cartArr[indexPath.row].fileImage!), placeholderImage: UIImage(named: "imgDefault"))
			}
			
			return cellOrder
		}else{
			let cellOrder:ShippingAddTableViewCell = tableView.dequeueReusableCell(withIdentifier: "shipAddID", for: indexPath) as! ShippingAddTableViewCell
			if let name = arrUser[indexPath.row].firstName{
				cellOrder.lbName.text = name + " " + (arrUser[indexPath.row].lastName ?? "")
			}
			
			if let street = arrUser[indexPath.row].add1{
				cellOrder.lbStreet.text = street + "," + (arrUser[indexPath.row].add2 ?? "")
			}
			if let country = arrUser[indexPath.row].country_id{
				cellOrder.lbCountry.text = country + "," + (arrUser[indexPath.row].city ?? "")
			}
			
			if self.defaultAdd == indexPath.row {
				cellOrder.imgSelection.image = UIImage.init(named: "RadioSelected")//setImage(UIImage(named: "RadioSelected"), for: .normal)
			}else{
				cellOrder.imgSelection.image = UIImage.init(named: "radioUnselected")
			}
			
			return cellOrder
		}
		
	}
	
	@IBAction func btnApplyPromoAction(_ sender: Any) {
	}
	
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func btnPlaceOrderAction(_ sender: Any) {
		self.setBillingShippingDetail()
	}
	
	
	@IBAction func btnCodeAction(_ sender: Any) {
		if textCode.text == ""{
			self.alertOK(title: "Code", message: "Enter code")
		}else{
			applyCode()
		}
	}
	
	//MARK: Coupon Code 
	func applyCode() {
		
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PCode + self.textCode.text!
			
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			
			AlamofireCalls.putCallDictionaryNoParam(urlString: urlString, headers: headers, completion: {
				(success) -> Void in
				print("from coupon")
				print(success)
				if success{
					self.alertOK(title: "Coupon", message: "Coupon added")
					self.setBillingShippingDetail()
				}else{
					self.alertOK(title: "Coupon", message: "Invalid code")
				}
				
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
		
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
			SVProgressHUD.show()
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
				if self.isOrderPlace{
					self.purchaseOrder()
				}else{
					let totals = token["totals"] as! NSDictionary
					let grand_total = totals["subtotal"] as! Float
					self.total = grand_total
					let shipping_amount = totals["shipping_amount"] as! Float
					self.lbFlatRateShipping.text = String(format: "AED %.2f", shipping_amount)
					
					self.lbSubtotal.text = String(format: "AED %.2f", self.total)//"AED " + String(total)
					//			self.lbTotalOrder.text = "AED " + String(total)
					let tax = self.total*0.05
					self.VAT.text = String(format: "AED %.2f", tax)//"AED " + String(tax)
					let totaltax = self.total - tax
					self.totalVat.text = String(format: "AED %.2f", totaltax)//String(totaltax)
					self.lbMainTotalOrder.text = String(format: "AED %.2f", self.total)//"AED " + String(total)
					self.isOrderPlace = true
				}
				self.getCartProduct()
				
				
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
			SVProgressHUD.show()
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
					UserDefaults.standard.removeObject(forKey: "badgeCount")
					let alert = UIAlertController(title: "Order Place", message: "Thank you for placing your order at Petshop", preferredStyle: UIAlertController.Style.alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
						let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
						self.navigationController?.pushViewController(nextViewController, animated: true)
						
					}))
					self.present(alert, animated: true, completion: nil)
				}else {
					UserDefaults.standard.removeObject(forKey: "badgeCount")
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
			SVProgressHUD.show()
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
////
				()
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
			
			SVProgressHUD.show()
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
					self.getImages(sku: prod.sku!,index: self.cartArr.count)
					self.cartArr.append(prod)
				}
				self.lbSubtotal.text = "AED " + String(totalPrice)
				self.heightReviewTV.constant = CGFloat(131 * self.cartArr.count)
				self.reviewTableView.reloadData()
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	func getCartProduct() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			//			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PGetCartProducts
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			
			let cartItems:[String:AnyObject] = ["cus_token":customerToken as AnyObject, "admin_token":adminToken as AnyObject]
			
			let param:[String:AnyObject] = [
				"data" : cartItems as AnyObject
			]
			
			//			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			
			AlamofireCalls.postCallAnyWithHeaderDict(urlString: urlString, parameters: param, headers: headers, completion: {
				(token) -> Void in
				print("from Shipping")
				print(token)
				
				let arrProductDetail = token["product_detail"] as! NSArray
				
				if arrProductDetail.count > 0 {
					var totalPrice:Float = 0.0
					for dictionary in arrProductDetail{
						let prod:Cart = Cart(dictionary: dictionary as! NSDictionary)
						totalPrice += prod.price!
						//					self.getImages(sku: prod.sku!,index: self.cartArr.count)
						self.cartArr.append(prod)
					}
					self.lbSubtotal.text = "AED " + String(totalPrice)
					self.heightReviewTV.constant = CGFloat(131 * self.cartArr.count)
					self.reviewTableView.reloadData()
				}
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	func getAccountDetail(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			self.arrUser = []
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PCustomerAccount
			let parameters:[String:String] = [:]
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCallDictionary(urlString: urlString, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				let address = success["addresses"] as! NSArray
				for add in address{
					let userD = User(dictionaryAdd: add as! NSDictionary)
					self.arrUser.append(userD)
				}
				self.heightShipAdd.constant = CGFloat(76 * self.arrUser.count) + 50
				self.viewShipAdd.layoutIfNeeded()
				self.shipAddTableView.reloadData()
				
				print("Account Details")
				
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	func getImages(sku:String,index:Int) {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			let urlString =  PBaseUrl + "products/" + sku + "/media"
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			let parameters:[String:String] = [:]
			AlamofireCalls.getCall(urlString: urlString, parameters: parameters, headers: headers, completion: {
				(token) -> Void in
				print("from Cart Images")
				print(token)
				for imagesDict in token{
					let dic = imagesDict as! NSDictionary
					if let typeArr = dic["types"] as? NSArray{
						if typeArr.count > 0{
							let fileName = dic["file"] as! String
							let imageUrl = "http://www.thepetstore.ae/pub/media/catalog/product" + fileName
							self.cartArr[index].image = imageUrl
							self.reviewTableView.reloadData()
						}
					}
					
				}
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
