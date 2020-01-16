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
	@IBOutlet weak var textConfirmPassword: UITextField!
	@IBOutlet weak var lbTitle: UILabel!
	@IBOutlet weak var btnSignIn: UIButton!
	@IBOutlet weak var btnCreateAccount: UIButton!
	
	let picker = UIPickerView()
	var cartArr:Array<Cart> = []
	var user:User?
	var totalItem = 0
	var city = ["ABUDHABI", "AJMAN", "AL AIN", "DUBAI", "FUJAIRAH", "RAS AL KHAIMAH", "SHARJAH", "UMM AL QUWAI"]
	var country = ["United Arab Emirates"]
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
		self.textAddressLine1.text = ""
		self.textAddressLine2.text = ""
		if let sign = UserDefaults.standard.string(forKey: "signIn"){
			signIn()
			UserDefaults.standard.removeObject(forKey: "signIn")
			
		}
		if let create = UserDefaults.standard.string(forKey: "createAccount"){
			createAccount()
			UserDefaults.standard.removeObject(forKey: "createAccount")
		}
		
		
		self.textCountry.text = country[0]
		self.textCity.text = city[3]
		let customerToken = UserDefaults.standard.string(forKey: "customerToken")
		if customerToken != nil {
			let firstname = UserDefaults.standard.string(forKey: "firstName")
			let email = UserDefaults.standard.string(forKey: "email")
			let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "myAccountID") as! MyAccountViewController
			nextViewController.userName = firstname!
			nextViewController.emailAddress = email!
			self.navigationController?.pushViewController(nextViewController, animated: true)
		}
		
		let tapOnScreen: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
		tapOnScreen.cancelsTouchesInView = false
		view.addGestureRecognizer(tapOnScreen)
		
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		
		
        // Do any additional setup after loading the view.
    }
	
	@objc func dismissKeyboard() {
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
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
		signIn()
	}
	
	func signIn(){
		self.viewSignIn.isHidden = false
		self.lbTitle.text = "Sign In"
		self.btnSignIn.backgroundColor = .white
		self.btnSignIn.setTitleColor(UIColor.init(red: 2/255, green: 166/255, blue: 178/255, alpha: 1), for: .normal)
		self.btnCreateAccount.setTitleColor(.white, for: .normal)
//		self.btnCreateAccount.titleLabel?.textColor = .white
		self.btnCreateAccount.backgroundColor = UIColor.init(red: 2/255, green: 166/255, blue: 178/255, alpha: 1)
	}
	
	@IBAction func btnCreateAccountAction(_ sender: Any) {
		createAccount()
	}
	
	func createAccount() {
		self.viewSignIn.isHidden = true
		self.lbTitle.text = "Create Account"
		self.btnCreateAccount.backgroundColor = .white
		//		self.btnCreateAccount.titleLabel?.textColor = UIColor.init(red: 2/255, green: 166/255, blue: 178/255, alpha: 1)
		self.btnCreateAccount.setTitleColor(UIColor.init(red: 2/255, green: 166/255, blue: 178/255, alpha: 1), for: .normal)
		self.btnSignIn.setTitleColor(.white, for: .normal)
		self.btnSignIn.backgroundColor = UIColor.init(red: 2/255, green: 166/255, blue: 178/255, alpha: 1)
	}
	
	@IBAction func btnLoginAction(_ sender: Any) {
		if self.textEmailAddress.text == ""{
			self.alertOK(title: "Email", message: "Enter email")
		}else if !isValidEmail(emailStr: textEmailAddress.text!){
			self.alertOK(title: "Email", message: "Enter valid email address")
		}else if self.txtPassword.text == ""{
			self.alertOK(title: "Password", message: "Enter password")
		}else{
			self.getToken(userName: self.textEmailAddress.text!,password: self.txtPassword.text!)
		}
		
		
	}
	@IBAction func btnCreateUserAction(_ sender: Any) {
		
		if self.textEmail.text == ""{
			self.alertOK(title: "Email", message: "Enter email")
		}else if !isValidEmail(emailStr: textEmail.text!){
			self.alertOK(title: "Email", message: "Enter valid email address")
		}else if self.textFirstName.text == ""{
			self.alertOK(title: "First name", message: "Enter first name")
		}else if self.textLastName.text == ""{
			self.alertOK(title: "Last name", message: "Enter last name")
		}else if self.textPassword.text == ""{
			self.alertOK(title: "Password", message: "Enter password")
		}else if self.textConfirmPassword.text == ""{
			self.alertOK(title: "Confirm Password", message: "Enter confirm password")
		}else if self.textPassword.text != self.textConfirmPassword.text{
			self.alertOK(title: "Password", message: "Password mismatch")
		}else if self.textCountry.text == ""{
			self.alertOK(title: "Country", message: "Enter country")
		}else if self.textCity.text == ""{
			self.alertOK(title: "City", message: "Enter city")
		}else if self.textAddressLine1.text == ""{
			self.alertOK(title: "Address", message: "Enter street/villa")
		}else if self.textPhoneNumber.text == ""{
			self.alertOK(title: "Phone number", message: "Enter phone number")
		}else if ((self.textPassword.text?.count)!) < 8{
			self.alertOK(title: "Password", message: "Password should be more than 7 characters")
		}else if ((self.textPhoneNumber.text?.count)!) < 10{
			self.alertOK(title: "Phone number", message: "Phone number should be atleast 10 digits")
		}else if (self.textPhoneNumber.text?.prefix(2) != "05"){
			self.alertOK(title: "Phone number", message: "Phone number should start from 05")
		}else{
			self.createUser()
		}
//
//
//		if self.textFirstName.text != "" && self.textLastName.text != "" && self.textEmail.text != "" && self.textPhoneNumber.text != "" && self.textConfirmPassword.text != ""{
//			if self.textPassword.text != self.textConfirmPassword.text{
//				let alert = UIAlertController(title: "Password Mismatch", message: "Confirm Password Mismatch", preferredStyle: UIAlertController.Style.alert)
//				let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//				alert.addAction(defaultAction)
//				self.present(alert, animated: true, completion: nil)
//			}else{
//				self.createUser()
//			}
//
//		}else{
//			self.alertOK(title: "Missing Fields", message: "Please fill all the given fields")
//		}
		
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
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PCustomerToken
			let parameters:[String:String] = ["username":userName,"password":password]
			AlamofireCalls.postCall(urlString: urlString, parameters: parameters, completion: {
				(token,statusCode) -> Void in
				print("from Login")
				if statusCode == "401"{
					let alert = UIAlertController(title: "Invalid Credentials", message: token, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					self.present(alert, animated: true, completion: nil)
					return
				}
				print(token)
				print(statusCode)
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
			SVProgressHUD.show()
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
				self.textAddressLine1.text,
				self.textAddressLine2.text
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
				(token,statusCode) -> Void in
				print("from Login")
				print(token)
				if statusCode == "400"{
					var message = "Incorrect"
					if let msg = token["message"] as? String{
						message = msg
					}
					let alert = UIAlertController(title: "Invalid Credentials", message: message, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					self.present(alert, animated: true, completion: nil)
					return
				}
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
			
			SVProgressHUD.show()
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
				/*
				if self.isKeyPresentInUserDefaults(key: "items"){
					let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "items") as! Data) as! [GuestCart]
					self.totalItem = decodedArray.count
					for count in 1...decodedArray.count{
//						let cart = Cart(guestData: items)
						self.getCartID(cart: decodedArray[count-1], index: count)
					}
				}else{
					let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "myAccountID") as! MyAccountViewController
					nextViewController.userName = success["firstname"] as! String
					nextViewController.emailAddress = success["email"] as! String
					self.navigationController?.pushViewController(nextViewController, animated: true)
				}
				*/
				
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	func getCartID(cart:GuestCart,index:Int) {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PCartId
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			if customerToken == nil {
				return
			}
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.postCallAnyWithOnlyHeader(urlString: urlString, headers: headers, completion: {
				(token) -> Void in
				print("from Product View")
				print(token)
				self.setCartItem(quoteID: token,cart: cart, index: index)
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func setCartItem(quoteID:Int,cart:GuestCart,index:Int) {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			//			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PCart
			
			let extensionAttributes:[String:AnyObject] = [:]
			
			var cartItems:[String:AnyObject] = [:]
			
			if cart.type == "configurable" {
//				cartItems = ["sku":cart.sku as AnyObject, "qty": cart.qty as AnyObject, "quote_id" : quoteID as AnyObject]
				cartItems = ["sku":cart.sku as AnyObject, "qty": cart.qty as AnyObject, "quote_id" : quoteID as AnyObject]
				
			}else {
				cartItems = ["sku":cart.sku as AnyObject, "qty":cart.qty as AnyObject, "quote_id" : quoteID as AnyObject, "extension_attributes" : extensionAttributes as AnyObject]
//				cartItems = ["sku":cart.sku as AnyObject, "qty":cart.qty as AnyObject, "quote_id" : quoteID as AnyObject, "extension_attributes" : extensionAttributes as AnyObject]
			}
			
			let param:[String:AnyObject] = [
				"cartItem" : cartItems as AnyObject
			]
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			
			AlamofireCalls.postCallAnyWithHeaderDict(urlString: urlString, parameters: param, headers: headers, completion: {
				(token) -> Void in
				print("from Shipping")
				print(token)
				
				//				self.getCartDetail()
				self.getCartProduct()
				
				if self.totalItem == index{
					
					let defaults = UserDefaults.standard
					defaults.removeObject(forKey: "items")
					_ = self.tabBarController?.selectedIndex = 0
					
				}
				
				
				
//				let alert = UIAlertController(title: "Product Added to Cart", message: "Happy Shopping", preferredStyle: UIAlertController.Style.alert)
//				let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//				alert.addAction(defaultAction)
//				self.present(alert, animated: true, completion: nil)
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	/*
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
					self.cartArr = []
					for dictionary in arrProductDetail{
						let prod:Cart = Cart(dictionary: dictionary as! NSDictionary)
						self.cartArr.append(prod)
					}
					if self.cartArr.count > 0 {
						UserDefaults.standard.set(String(self.cartArr.count), forKey: "badgeCount")
//						self.lbBadgeCount.text = String(self.cartArr.count)
//						self.lbBadgeCount.isHidden = false
					}else {
						UserDefaults.standard.removeObject(forKey: "badgeCount")
//						self.lbBadgeCount.isHidden = true
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
	*/
	
	func getCartProduct() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PGetCuont
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			
			
			let param:[String:AnyObject] = [
				"customer_token" : customerToken as AnyObject
			]
			let headers:[String:String] = [
				"Content-Type": "application/json"]
			
			AlamofireCalls.postCallAnyWithHeaderDict(urlString: urlString, parameters: param, headers: headers, completion: {
				(token) -> Void in
				print("from Count")
				print(token)
				
				var count = 0
				
				count = token["count"] as! Int
				
				if count > 0 {
					UserDefaults.standard.set(String(count), forKey: "badgeCount")
				}else {
					UserDefaults.standard.removeObject(forKey: "badgeCount")
				}
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}

}

extension UIViewController{
	func alertOK(title:String,message:String){
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
		let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(defaultAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func isValidEmail(emailStr:String) -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		
		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: emailStr)
	}
	
}

extension UIToolbar {
	
	func ToolbarPiker(mySelect : Selector) -> UIToolbar {
		
		let toolBar = UIToolbar()
		
		toolBar.barStyle = UIBarStyle.default
		toolBar.isTranslucent = true
		toolBar.tintColor = UIColor.black
		toolBar.sizeToFit()
		
		let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
		
		toolBar.setItems([spaceButton, doneButton], animated: false)
		toolBar.isUserInteractionEnabled = true
		
		return toolBar
	}
	
}
