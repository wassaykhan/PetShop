//
//  ProductListViewController.swift
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

class ProductListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var productListTableView: UITableView!
	
	var productList:Array<Product>?
	var productID = 0
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
//		print(productList!)
//		self.getProduct()
        // Do any additional setup after loading the view.
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.productList!.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 142
		
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cellCategory:ArrivalsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "arrivalsCellIdentifier", for: indexPath) as! ArrivalsTableViewCell
		
		let a:Product = self.productList![indexPath.row]
		cellCategory.lbName.text = a.name
		if a.price != nil {
			cellCategory.lbPrice.text = String(format: "AED %.2f", a.price!)
		}
		
		if self.productList![indexPath.row].image != nil {
			cellCategory.imgProd.sd_setImage(with: URL(string:a.image!), placeholderImage: UIImage(named: ""))
		}
		
		return cellCategory
	}
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	/*
	func getProduct(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PCategories + String(self.productID)
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCall(urlString: urlString, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				self.productList = []
				for dictionary in success{
					
					let JSON = dictionary as! NSDictionary
					if JSON["children"] != nil {
						let arr = JSON["children"] as! NSArray
						for dictChild in arr{
							let dictGetProd = dictChild as! NSDictionary
							
							let arrOfProd = dictGetProd["products"] as! NSArray
							for products in arrOfProd {
								let categoryData:Product = Product(dictionary: products as! NSDictionary)
								self.productList.append(categoryData)
							}
						}
					}
					
				}
				self.productListTableView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	*/
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if (segue.identifier == "productListID") {
			let vc = segue.destination as! ProductViewController
			let indexPaths = self.productListTableView.indexPathForSelectedRow
			let indexPath = indexPaths! as NSIndexPath
			vc.productName = self.productList![indexPath.row].sku!
			
			//			vc.params = self.params
		}
	}
//	productListID

}
