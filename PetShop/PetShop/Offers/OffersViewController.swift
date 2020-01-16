//
//  OffersViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 03/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SVProgressHUD
import SDWebImage
import BadgeSwift

class OffersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
	var offerProduct:Array<LatestProduct> = []
	@IBOutlet weak var offerTableView: UITableView!
	@IBOutlet weak var lbBadgeCount: BadgeSwift!
	@IBOutlet weak var btnNoData: UIButton!
	
	var page = 1
	
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
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.getOfferProduct()
        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.offerProduct.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 200
		
		
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == (self.offerProduct.count - 1) {
			self.page += 1
			self.getOfferProduct()
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellCategory:ArrivalsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "arrivalsCellIdentifier", for: indexPath) as! ArrivalsTableViewCell
		if self.offerProduct[indexPath.row].file != nil {
			cellCategory.imgProd.sd_setImage(with: URL(string: PBaseSUrl + "/pub/media/catalog/product" + self.offerProduct[indexPath.row].file!), placeholderImage: UIImage(named: ""))
		}
		
		if self.offerProduct[indexPath.row].isConfig == "configurable" {
			cellCategory.lbMoreChoices.isHidden = false
		}else{
			cellCategory.lbMoreChoices.isHidden = true
		}
		
		cellCategory.lbName.text = self.offerProduct[indexPath.row].name
		cellCategory.lbPrice.text = String(format: "AED %.2f", self.offerProduct[indexPath.row].price!)
		return cellCategory
	}
	
	func getOfferProduct(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
//			self.offerProduct = []
			let urlString =  PBaseUrl + "products?searchCriteria[filterGroups][0][filters][0][field]=category_id& searchCriteria[filterGroups][0][filters][0][value]=714& searchCriteria[sortOrders][0][direction]=DESC& searchCriteria[pageSize]=10& searchCriteria[currentPage]=" + String(self.page) + "&searchCriteria[filterGroups][1][filters][0][field]=status&searchCriteria[filterGroups][2][filters][0][field]=visibility& searchCriteria[filterGroups][2][filters][0][value]=1& searchCriteria[filterGroups][1][filters][0][value]=1& searchCriteria[filterGroups][2][filters][0][condition_type]=neq"
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCallDictionary(urlString: encodedUrl!	, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				//				print(success)
				let items = success["items"] as! NSArray
				for dictionary in items{
					let latestProd:LatestProduct = LatestProduct(dictionary: dictionary as! NSDictionary)
					self.offerProduct.append(latestProd)
				}
				if self.offerProduct.count == 0{
					self.offerTableView.isHidden = true
					self.btnNoData.isHidden = false
				}
				self.offerTableView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if (segue.identifier == "offerProdID") {
			let vc = segue.destination as! ProductViewController
			let indexPaths = self.offerTableView.indexPathForSelectedRow
			let indexPath = indexPaths! as NSIndexPath
			vc.productName = self.offerProduct[indexPath.row].sku!
			
			//			vc.params = self.params
		}
	}

}
