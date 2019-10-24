//
//  LoginViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 09/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SVProgressHUD

class LoginViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

	@IBOutlet weak var viewSignIn: UIView!
	//Sign In Outlets
	@IBOutlet weak var textEmailAddress: UITextField!
	@IBOutlet weak var txtPassword: UITextField!
	//Sign Up Outlets
	@IBOutlet weak var textFirstName: UITextField!
	@IBOutlet weak var textLastName: UITextField!
	@IBOutlet weak var textEmail: UITextField!
	@IBOutlet weak var textPassword: UITextField!
	@IBOutlet weak var textCountry: UITextField!
	@IBOutlet weak var textCity: UITextField!
	@IBOutlet weak var textAddressLine1: UITextField!
	@IBOutlet weak var textAddressLine2: UITextField!
	@IBOutlet weak var textPhoneNumber: UITextField!
	
	var user:User?
	
	var city = ["ABUDHABI", "AJMAN", "AL AIN", "DUBAI", "FUJAIRAH", "RAS AL KHAIMAH", "SHARJAH", "UMM AL QUWAI"]
	var country = ["United Arab Emirates"]
	
	override func viewDidLoad() {
        super.viewDidLoad()
		let customerToken = UserDefaults.standard.string(forKey: "customerToken")
		if customerToken != nil {
			let firstname = UserDefaults.standard.string(forKey: "firstName")
			let email = UserDefaults.standard.string(forKey: "email")
			let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "myAccountID") as! MyAccountViewController
			nextViewController.userName = firstname!
			nextViewController.emailAddress = email!
			self.navigationController?.pushViewController(nextViewController, animated: true)
		}
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
	
    
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func btnSignInAction(_ sender: Any) {
		self.viewSignIn.isHidden = false
	}
	@IBAction func btnCreateAccountAction(_ sender: Any) {
		self.viewSignIn.isHidden = true
	}
	
	@IBAction func btnLoginAction(_ sender: Any) {
		if self.textEmailAddress.text != "" && self.txtPassword.text != "" {
			self.getToken(userName: self.textEmailAddress.text!,password: self.txtPassword.text!)
		}else{
			let alert = UIAlertController(title: "Missing Fields", message: "Please fill all the given fields", preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
		
		
	}
	@IBAction func btnCreateUserAction(_ sender: Any) {
		
		if self.textFirstName.text != "" && self.textLastName.text != "" && self.textEmail.text != "" && self.textPhoneNumber.text != "" {
			self.createUser()
		}else{
			let alert = UIAlertController(title: "Missing Fields", message: "Please fill all the given fields", preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
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
	
	@IBOutlet weak var CPickerView: UIPickerView!
	
	func getToken(userName:String,password:String) {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PCustomerToken
			let parameters:[String:String] = ["username":userName,"password":password]
			AlamofireCalls.postCall(urlString: urlString, parameters: parameters, completion: {
				(token) -> Void in
				print("from Login")
				print(token)
				if token != "" {
					UserDefaults.standard.set(userName, forKey: "emailAddress")
					UserDefaults.standard.set(password, forKey: "password")
					UserDefaults.standard.set(token, forKey: "customerToken")
					self.getAccountDetail()
				}
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func createUser() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PCreateCustomer
			let address:[String:Any] = ["addresses" : [
				"defaultBilling" : true,
				"defaultShipping" : true,
				"firstname" : self.textFirstName.text as Any,
				"lastname" : self.textLastName.text as Any,
				"countryId" : "AE",
				"postcode" : "10755",
				"city" : "Purchase",
				"street" : [
				"123 Oak Ave"
				],
				"telephone" : self.textPhoneNumber.text as Any
				
				]]
			
			let customer:[String:AnyObject] = ["lastname":self.textLastName.text as AnyObject,"firstname" : self.textFirstName.text as AnyObject,
											   "email" : self.textEmail.text as AnyObject,
											   "store_id": 1 as AnyObject,
											   "website_id": 1 as AnyObject,
											   "addresses" :address as AnyObject]
			let param:[String:AnyObject] = [
				"customer" : customer as AnyObject,
				"password" : self.textPassword.text as AnyObject
				]
			
			//let parameters:[String:String] = ["username":self.textEmailAddress.text!,"password":self.txtPassword.text!]
			
			AlamofireCalls.postCallAny(urlString: urlString, parameters: param, completion: {
				(token) -> Void in
				print("from Login")
				print(token)
				
				self.getToken(userName: self.textEmail.text!,password: self.textPassword.text!)
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
			
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PCustomerAccount
			let parameters:[String:String] = [:]
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCallDictionary(urlString: urlString, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				self.user = User(dictionary: success)
				print("Account Details")
				UserDefaults.standard.set(self.user?.firstName, forKey: "firstName")
				UserDefaults.standard.set(self.user?.lastName, forKey: "lastName")
				UserDefaults.standard.set(self.user?.email, forKey: "email")
				UserDefaults.standard.set(self.user?.userID, forKey: "id")
				UserDefaults.standard.set(self.user?.add1, forKey: "add1")
				UserDefaults.standard.set(self.user?.add2, forKey: "add2")
				UserDefaults.standard.set(self.user?.telephone, forKey: "telephone")
				
				let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "myAccountID") as! MyAccountViewController
				nextViewController.userName = success["firstname"] as! String
				nextViewController.emailAddress = success["email"] as! String
				self.navigationController?.pushViewController(nextViewController, animated: true)
				
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
