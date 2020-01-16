//
//  ForgotPasswordViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 19/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {

	
	
	@IBOutlet weak var textForgotPassword: UITextField!
	@IBOutlet weak var btnForgotPassword: UIButton!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	func forgotPassword() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
//			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PForgotPassword
			
			let param:[String:AnyObject] = [
				"email" : self.textForgotPassword.text as AnyObject,
				"template" : "email_reset" as AnyObject
			]
			
//			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
//			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
//										   "Content-Type": "application/json"]
			
			AlamofireCalls.putCallAny(urlString: urlString, parameters: param, completion: {
				(token) -> Void in
				print("from Forget")
				print(token)
				if token == false{
					let alert = UIAlertController(title: "ALert", message: "Email Address not found", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
				}else{
					
					
					let alert = UIAlertController(title: "Password Send", message: "Check your email address for password", preferredStyle: UIAlertController.Style.alert)
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
	@IBAction func btnDoneAction(_ sender: Any) {
		
		if self.textForgotPassword.text == ""{
			self.alertOK(title: "Email", message: "Enter email address")
		}else if !isValidEmail(emailStr: textForgotPassword.text!){
			self.alertOK(title: "Email", message: "Enter valid email address")
		}else{
			self.forgotPassword()
		}
		
		
	}
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
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
