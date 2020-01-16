//
//  EditProfileViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 20/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class EditProfileViewController: UIViewController {

	
	@IBOutlet weak var textFirstName: UITextField!
	@IBOutlet weak var textLastName: UITextField!
	@IBOutlet weak var textEmail: UITextField!
	@IBOutlet weak var textPassword: UITextField!
	
	var user:User?
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		let email = UserDefaults.standard.string(forKey: "email")
		self.textEmail.text = email
		let firstname = UserDefaults.standard.string(forKey: "firstName")
		self.textFirstName.text = firstname
		let lastname = UserDefaults.standard.string(forKey: "lastName")
		self.textLastName.text = lastname
        // Do any additional setup after loading the view.
    }
    
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	@IBAction func btnSaveAction(_ sender: Any) {
		
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
		}else if (self.textPassword.text?.count)! < 8{
			self.alertOK(title: "Password", message: "Password should be more than 7 characters")
		}else{
			self.editProfile()
		}
		
		
		
//		if self.textEmail.text != "" && self.textFirstName.text != "" && self.textLastName.text != "" && self.textPassword.text != ""{
////			self.navigationController?.popViewController(animated: true)
//			self.editProfile()
//		}else{
//			self.alertOK(title: "Missing Fields", message: "Please fill all the given fields")
//		}
		
		
	}
	
	func editProfile() {
		
		let extension_attributes:[String:AnyObject] = ["is_subscribed": false as AnyObject]
		let customerID = UserDefaults.standard.integer(forKey: "id")
		let customer:[String:AnyObject] = ["id": customerID as AnyObject,
										   "created_in": "English" as AnyObject,
										   "email": self.textEmail.text as AnyObject,
										   "firstname": self.textFirstName.text as AnyObject,
										   "lastname": self.textLastName.text as AnyObject,
										   "store_id": 1 as AnyObject,
										   "website_id": 1 as AnyObject,
										   "disable_auto_group_change": 0 as AnyObject,
										   "extension_attributes":extension_attributes as AnyObject]
		let param:[String:AnyObject] = ["customer" : customer as AnyObject,"password" : self.textPassword!.text as AnyObject]
		
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PEditProfile + String(customerID)
			
			
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
													   "Content-Type": "application/json"]
			
			AlamofireCalls.putCallDictionary(urlString: urlString, parameters: param, headers: headers, completion: {
				(success) -> Void in
				print("from Edit")
				print(success)
				self.user = User(dictionary: success)
				UserDefaults.standard.set(self.user?.firstName, forKey: "firstName")
				UserDefaults.standard.set(self.user?.lastName, forKey: "lastName")
				UserDefaults.standard.set(self.user?.email, forKey: "email")
				UserDefaults.standard.set(self.user?.userID, forKey: "id")
				UserDefaults.standard.set(self.user?.telephone, forKey: "telephone")
				self.navigationController?.popViewController(animated: true)
//				if token == false{
//					let alert = UIAlertController(title: "ALert", message: "Email Address not found", preferredStyle: UIAlertController.Style.alert)
//					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//					alert.addAction(defaultAction)
//				}else{
//
//
//					let alert = UIAlertController(title: "Password Send", message: "Check your email address for password", preferredStyle: UIAlertController.Style.alert)
//					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//					alert.addAction(defaultAction)
//					self.present(alert, animated: true, completion: nil)
//
//
//				}
				
				
				
				
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
