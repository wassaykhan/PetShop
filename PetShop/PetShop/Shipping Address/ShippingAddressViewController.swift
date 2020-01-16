//
//  ShippingAddressViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 19/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SVProgressHUD

class ShippingAddressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var addressTableView: UITableView!
	
	var arrUser:Array<User> = []
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
		
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.getAccountDetail()
//		let firstName = UserDefaults.standard.string(forKey: "firstName")
//		let lastName = UserDefaults.standard.string(forKey: "lastName")
//		let email = UserDefaults.standard.string(forKey: "email")
//		let add2 = UserDefaults.standard.string(forKey: "add2")
//		let telephone = UserDefaults.standard.string(forKey: "telephone")
        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.arrUser.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 140
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:AddressTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "AddressTVCell", for: indexPath) as! AddressTableViewCell
		if let firstName = self.arrUser[indexPath.row].firstName{
			cell.lbName.text = firstName
		}
		if let lastName = self.arrUser[indexPath.row].lastName{
			cell.lbName.text = cell.lbName.text! + " " + lastName
		}
		if let email = self.arrUser[indexPath.row].email{
			print(email)
		}
		if let add1 = self.arrUser[indexPath.row].add1{
			cell.lbAddress.text = add1
		}
		if let telephone = self.arrUser[indexPath.row].telephone{
			cell.lbTelephone.text = telephone
		}
		if let city = self.arrUser[indexPath.row].city{
			cell.lbCity.text = city
		}
		if let country = self.arrUser[indexPath.row].country_id{
			cell.lbCountry.text = country
		}
		
		return cell
	}
	

	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
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
//				self.heightShipAdd.constant = CGFloat(76 * self.arrUser.count) + 50
//				self.viewShipAdd.layoutIfNeeded()
				self.addressTableView.reloadData()
				
				print("Account Details")
				
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}

}
