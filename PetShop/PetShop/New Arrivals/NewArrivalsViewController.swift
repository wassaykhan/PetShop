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

class NewArrivalsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
	@IBOutlet weak var newArrivalTableView: UITableView!
	
	var newArrivalProduct:Array<LatestProduct> = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.getNewArrivalProduct()
//		print(self.tabBarItem.tag)
        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.newArrivalProduct.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 142
		
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellCategory:ArrivalsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "arrivalsCellIdentifier", for: indexPath) as! ArrivalsTableViewCell
		cellCategory.imgProd.sd_setImage(with: URL(string: PBaseSUrl + "/pub/media/catalog/product" + self.newArrivalProduct[indexPath.row].file!), placeholderImage: UIImage(named: ""))
		cellCategory.lbName.text = self.newArrivalProduct[indexPath.row].name
		cellCategory.lbPrice.text = String(format: "AED %.2f", self.newArrivalProduct[indexPath.row].price!)
		return cellCategory
	}

	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func getNewArrivalProduct(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show(withStatus: "Loading Request")
			self.newArrivalProduct = []
			let urlString =  PBaseUrl + "products?searchCriteria[filterGroups][0][filters][0][field]=category_id& searchCriteria[filterGroups][0][filters][0][value]=709& searchCriteria[sortOrders][0][direction]=DESC& searchCriteria[pageSize]=10& searchCriteria[currentPage]=1"
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
