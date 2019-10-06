//
//  MyAccountViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 19/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SVProgressHUD
import SDWebImage


class MyAccountViewController: UIViewController {

	@IBOutlet weak var lbName: UILabel!
	
	@IBOutlet weak var lbEmail: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.lbName.text = ""
		self.lbEmail.text = ""
		self.getAccountDetail()
		
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
	}
    
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func lbLogoutAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
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
				
				print(success)
				self.lbName.text = success["firstname"] as? String
				self.lbEmail.text = success["email"] as? String
				
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
