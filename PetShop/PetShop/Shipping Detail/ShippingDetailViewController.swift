//
//  ShippingDetailViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 09/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SVProgressHUD

class ShippingDetailViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

	@IBOutlet weak var textFirstName: UITextField!
	@IBOutlet weak var textLastName: UITextField!
	@IBOutlet weak var textCountry: UITextField!
	@IBOutlet weak var textAddress1: UITextField!
	@IBOutlet weak var textAddress2: UITextField!
	@IBOutlet weak var textPhoneNumber: UITextField!
	@IBOutlet weak var CPickerView: UIPickerView!
	@IBOutlet weak var textCity: UITextField!
	
	var city = ["ABUDHABI", "AJMAN", "AL AIN", "DUBAI", "FUJAIRAH", "RAS AL KHAIMAH", "SHARJAH", "UMM AL QUWAI"]
	var country = ["United Arab Emirates"]
	
	override func viewDidLoad() {
        super.viewDidLoad()
		let firstname = UserDefaults.standard.string(forKey: "firstName")
		
		let lastname = UserDefaults.standard.string(forKey: "latName")
		self.textFirstName.text = firstname
		self.textLastName.text = lastname
//		self.textFirstName.text = firstname
        // Do any additional setup after loading the view.
    }
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		
		if pickerView.tag == 1 {
			return city.count
		}else{
			return country.count
		}
		
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		if pickerView.tag == 1 {
			return city[row]
		}else{
			return country[row]
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
		
		if pickerView.tag == 1 {
			self.textCity.text = city[row]
			self.CPickerView.isHidden = true
		}else {
			self.textCountry.text = country[row]
			self.CPickerView.isHidden = true
		}
	}
	
	
	
	@IBAction func btnCountryAction(_ sender: Any) {
		self.CPickerView.tag = 2
		self.CPickerView.reloadAllComponents()
		self.CPickerView.isHidden = false
	}
	@IBAction func btnCityAction(_ sender: Any) {
		self.CPickerView.tag = 1
		self.CPickerView.reloadAllComponents()
		self.CPickerView.isHidden = false
	}
	@IBAction func btnEstimateShippingAction(_ sender: Any) {
		if textLastName.text != "" && textFirstName.text != "" && textCity.text != "" && textCountry.text != "" && textAddress1.text != "" && textPhoneNumber.text != "" {
			self.navigationController?.popViewController(animated: true)
//			self.shippingDetail()
		}else{
			let alert = UIAlertController(title: "Missing Fields", message: "Please fill all the given fields", preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
		
	}
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	
	func shippingDetail() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PEstimateShipping
			let email = UserDefaults.standard.string(forKey: "email")
			let address:[String:AnyObject] = ["lastname":self.textLastName.text as AnyObject,"firstname" : self.textFirstName.text as AnyObject,
											   "postcode" : "10577" as AnyObject,
											   "street" : ["123 Oak Ave"] as AnyObject,
											   "city": self.textCity.text as AnyObject,
											   "same_as_billing": 1 as AnyObject,
											   "country_id" :"AE" as AnyObject,
											   "telephone" : self.textPhoneNumber.text as AnyObject,
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
				let alert = UIAlertController(title: "Confirm Payment", message: "Your total ammount is AED 200.00", preferredStyle: UIAlertController.Style.actionSheet)
				
				alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
					print("Yay! You brought your towel!")
					self.setBillingShippingDetail()
					}))
				alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
//				alert.addAction(defaultAction)
				self.present(alert, animated: true, completion: nil)
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
	
	func setBillingShippingDetail() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PShippingInformation
			
			
			let email = UserDefaults.standard.string(forKey: "email")
			let shippingAddress:[String:AnyObject] = ["lastname":self.textLastName.text as AnyObject,"firstname" : self.textFirstName.text as AnyObject,
											  "postcode" : "10577" as AnyObject,
											  "street" : ["123 Oak Ave"] as AnyObject,
											  "city": self.textCity.text as AnyObject,
											  "same_as_billing": 1 as AnyObject,
											  "country_id" :"AE" as AnyObject,
											  "telephone" : self.textPhoneNumber.text as AnyObject,
											  "customer_id" : customerID as AnyObject,
											  "email" : email as AnyObject]
			let billingAddress:[String:AnyObject] = ["lastname":self.textLastName.text as AnyObject,"firstname" : self.textFirstName.text as AnyObject,
													  "postcode" : "10577" as AnyObject,
													  "street" : ["123 Oak Ave"] as AnyObject,
													  "city": self.textCity.text as AnyObject,
													  "same_as_billing": 1 as AnyObject,
													  "country_id" :"AE" as AnyObject,
													  "telephone" : self.textPhoneNumber.text as AnyObject,
													  "customer_id" : customerID as AnyObject,
													  "email" : "jdoe@example.com" as AnyObject]
			
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
			
			
//			let email = UserDefaults.standard.string(forKey: "email")
			let attributes:[String:AnyObject] = ["comment":"abc" as AnyObject,"subscribe" : false as AnyObject,"agreement_ids": ["2"] as AnyObject]
			let paymentMethod:[String:AnyObject] = ["method":"cashondelivery" as AnyObject,"extension_attributes" : attributes as AnyObject]
			let billingAddress:[String:AnyObject] = ["lastname":self.textLastName.text as AnyObject,"firstname" : self.textFirstName.text as AnyObject,
													 "postcode" : "10577" as AnyObject,
													 "street" : ["123 Oak Ave"] as AnyObject,
													 "city": self.textCity.text as AnyObject,
													 "same_as_billing": 1 as AnyObject,
													 "country_id" :"AE" as AnyObject,
													 "telephone" : self.textPhoneNumber.text as AnyObject,
													 "customer_id" : customerID as AnyObject,
													 "email" : "jdoe@example.com" as AnyObject]
			
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
					let alert = UIAlertController(title: "Cart Updated", message: "Visit Cart to view your product", preferredStyle: UIAlertController.Style.alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
						let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
						self.navigationController?.pushViewController(nextViewController, animated: true)
						
					}))
					self.present(alert, animated: true, completion: nil)
				}else {
					let alert = UIAlertController(title: "Cart Updated", message: "Visit Cart to view your product", preferredStyle: UIAlertController.Style.alert)
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
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
