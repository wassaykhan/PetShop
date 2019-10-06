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

class LoginViewController: UIViewController {

	@IBOutlet weak var viewSignIn: UIView!
	@IBOutlet weak var textEmailAddress: UITextField!
	@IBOutlet weak var txtPassword: UITextField!
	override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
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
		
		self.getToken()
		
	}
	@IBAction func btnCreateUserAction(_ sender: Any) {
	}
	
	
	func getToken() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PCustomerToken
			//for testing
//			let parameters:[String:String] = ["username":"haroonmind@gmail.com","password":"admin123456!"]
			//origional
			let parameters:[String:String] = ["username":self.textEmailAddress.text!,"password":self.txtPassword.text!]
			AlamofireCalls.postCall(urlString: urlString, parameters: parameters, completion: {
				(token) -> Void in
				print("from Login")
				print(token)
				if token != "" {
					UserDefaults.standard.set(token, forKey: "customerToken")
					let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "myAccountID") as! MyAccountViewController
					//		nextViewController.arrProduct = self.arrProducts
					//		nextViewController.productID = NSNumber(value: Int(productID!)!)
					self.navigationController?.pushViewController(nextViewController, animated: true)
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
