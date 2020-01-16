//
//  SearchProductViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 04/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SVProgressHUD
import SDWebImage
import BadgeSwift

class SearchProductViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate {

	@IBOutlet weak var searchTableView: UITableView!
	
	@IBOutlet weak var btnNoResult: UIButton!
	@IBOutlet weak var lbBadgeCount: BadgeSwift!
	@IBOutlet weak var txtSearch: UITextField!
	var searchText = ""
	var searchProduct:Array<LatestProduct> = []
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
		let badgeCount = UserDefaults.standard.string(forKey: "badgeCount")
		if badgeCount != nil {
			self.lbBadgeCount.isHidden = true
		}else {
			self.lbBadgeCount.isHidden = true
		}
	}
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		self.navigationController?.popToRootViewController(animated: false)
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tabBarController?.delegate = self
		self.txtSearch.text = self.searchText
		if searchText != "" {
			self.getSearchProduct()
		}
		
        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.searchProduct.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 180
		
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellCategory:ArrivalsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "arrivalsCellIdentifier", for: indexPath) as! ArrivalsTableViewCell
		if self.searchProduct[indexPath.row].file != nil {
			cellCategory.imgProd.sd_setImage(with: URL(string: PBaseSUrl + "/pub/media/catalog/product" + self.searchProduct[indexPath.row].file!), placeholderImage: UIImage(named: ""))
		}
		
		cellCategory.lbName.text = self.searchProduct[indexPath.row].name
		if self.searchProduct[indexPath.row].price != nil {
			cellCategory.lbPrice.text = String(format: "AED %.2f", self.searchProduct[indexPath.row].price!)
		}
		if self.searchProduct[indexPath.row].isConfig == "configurable" {
			cellCategory.lbMoreChoices.isHidden = false
		}else{
			cellCategory.lbMoreChoices.isHidden = true
		}
		
		return cellCategory
	}
	
	
	
	func getSearchProduct(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
			self.searchProduct = []
			let urlString =  PBaseUrl + "products?searchCriteria[pageSize]=10&searchCriteria[currentPage]=1&searchCriteria[filterGroups][1][filters][0][field]=status&searchCriteria[filterGroups][2][filters][0][field]=visibility& searchCriteria[filterGroups][2][filters][0][value]=1& searchCriteria[filterGroups][2][filters][0][condition_type]=neq&searchCriteria[filterGroups][0][filters][0][field]=name&searchCriteria[filterGroups][0][filters][0][value]=%" + self.searchText + "%&searchCriteria[filterGroups][0][filters][0][condition_type]=like&searchCriteria[filterGroups][1][filters][0][value]=1&searchCriteria[filterGroups][1][filters][0][conditionType]=gteq&searchCriteria[sortOrders][6][field]=created_at&searchCriteria[sortOrders][6][direction]=DESC"
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
					self.searchProduct.append(latestProd)
				}
				
				if self.searchProduct.count > 0{
					self.searchTableView.reloadData()
					self.searchTableView.isHidden = false
					self.btnNoResult.isHidden = true
				}else{
					self.searchTableView.isHidden = true
					self.btnNoResult.isHidden = false
				}
				
				
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	

	@IBAction func btnSearchAction(_ sender: Any) {
		self.searchText = self.txtSearch.text ?? ""
		if self.searchText != "" {
			self.getSearchProduct()
		}
		
	}
	
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if (segue.identifier == "searchProdID") {
			let vc = segue.destination as! ProductViewController
			let indexPaths = self.searchTableView.indexPathForSelectedRow
			let indexPath = indexPaths! as NSIndexPath
			vc.productName = self.searchProduct[indexPath.row].sku!
			
			//			vc.params = self.params
		}
	}

}
