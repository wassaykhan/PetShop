//
//  NewArrivalsViewController.swift
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
import BadgeSwift

class NewArrivalsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
	@IBOutlet weak var newArrivalTableView: UITableView!
	@IBOutlet weak var lbBadgeCount: BadgeSwift!
	
	var newArrivalProduct:Array<LatestProduct> = []
	var page = 1
	var strAppend = ""
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
		let badgeCount = UserDefaults.standard.string(forKey: "badgeCount")
		if badgeCount != nil {
			self.lbBadgeCount.isHidden = false
			self.lbBadgeCount.text = badgeCount
		}else {
			self.lbBadgeCount.isHidden = true
		}
		self.newArrivalProduct = []
		self.getNewArrivalProduct()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
//		print(self.tabBarItem.tag)
        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.newArrivalProduct.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 200
		
		
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if self.newArrivalProduct.count > 9{
			if indexPath.row == (self.newArrivalProduct.count - 1) {
				self.page += 1
				self.getNewArrivalProduct()
			}
		}
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellCategory:ArrivalsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "arrivalsCellIdentifier", for: indexPath) as! ArrivalsTableViewCell
		cellCategory.imgProd.sd_setImage(with: URL(string: PBaseSUrl + "/pub/media/catalog/product" + self.newArrivalProduct[indexPath.row].file!), placeholderImage: UIImage(named: ""))
		cellCategory.lbName.text = self.newArrivalProduct[indexPath.row].name
		cellCategory.lbPrice.text = String(format: "AED %.2f", self.newArrivalProduct[indexPath.row].price!)
		if self.newArrivalProduct[indexPath.row].isConfig == "configurable" {
			cellCategory.lbMoreChoices.isHidden = false
		}else{
			cellCategory.lbMoreChoices.isHidden = true
		}
		return cellCategory
	}

	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func getNewArrivalProduct(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
//			self.newArrivalProduct = []
			let urlString =  PBaseUrl + "products?searchCriteria[filterGroups][0][filters][0][field]=category_id& searchCriteria[filterGroups][0][filters][0][value]=709& searchCriteria[sortOrders][0][direction]=DESC& searchCriteria[pageSize]=10& searchCriteria[currentPage]=" + String(self.page) + "&searchCriteria[filterGroups][1][filters][0][field]=status&searchCriteria[filterGroups][2][filters][0][field]=visibility& searchCriteria[filterGroups][2][filters][0][value]=1& searchCriteria[filterGroups][1][filters][0][value]=1& searchCriteria[filterGroups][2][filters][0][condition_type]=neq&" + self.strAppend
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCallDictionary(urlString: encodedUrl!	, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
								print(success)
				let items = success["items"] as! NSArray
				for dictionary in items{
					let latestProd:LatestProduct = LatestProduct(dictionary: dictionary as! NSDictionary)
					self.newArrivalProduct.append(latestProd)
				}
				self.newArrivalTableView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if (segue.identifier == "arrivalProdID") {
			let vc = segue.destination as! ProductViewController
			let indexPaths = self.newArrivalTableView.indexPathForSelectedRow
			let indexPath = indexPaths! as NSIndexPath
			vc.productName = self.newArrivalProduct[indexPath.row].sku!
			
			//			vc.params = self.params
		}
	}

}
