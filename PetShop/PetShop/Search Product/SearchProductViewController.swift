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

class SearchProductViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var searchTableView: UITableView!
	
	@IBOutlet weak var txtSearch: UITextField!
	var searchText = ""
	var searchProduct:Array<LatestProduct> = []
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.txtSearch.text = self.searchText
		self.getSearchProduct()
        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.searchProduct.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 142
		
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellCategory:ArrivalsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "arrivalsCellIdentifier", for: indexPath) as! ArrivalsTableViewCell
		if self.searchProduct[indexPath.row].file != nil {
			cellCategory.imgProd.sd_setImage(with: URL(string: PBaseSUrl + "/pub/media/catalog/product" + self.searchProduct[indexPath.row].file!), placeholderImage: UIImage(named: ""))
		}
		
		cellCategory.lbName.text = self.searchProduct[indexPath.row].name
		cellCategory.lbPrice.text = String(format: "AED %.2f", self.searchProduct[indexPath.row].price!)
		return cellCategory
	}
	
	
	
	func getSearchProduct(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show(withStatus: "Loading Request")
			self.searchProduct = []
			let urlString =  PBaseUrl + "products?searchCriteria[filter_groups][0][filters][0][field]=name&searchCriteria[filter_groups][0][filters][0][value]=%" + self.searchText + "%&searchCriteria[filter_groups][0][filters][0][condition_type]=like&searchCriteria[pageSize]=10&searchCriteria[currentPage]=1"
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
				self.searchTableView.reloadData()
				
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
		self.getSearchProduct()
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
