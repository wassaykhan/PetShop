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
import BadgeSwift

class ProductListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate {

	@IBOutlet weak var productListTableView: UITableView!
	@IBOutlet weak var productListTitle: UILabel!
	@IBOutlet weak var lbBadgeCount: BadgeSwift!
	
	var productList:Array<Product> = []
	var arrProductList:Array<Product> = []
	var productID = 0
	var isFromBrand = false
	var productTitle = "Product"
	var valueFromBrand = ""
	var valueFromCategory = 0
	var page = 1
	var strAppend = ""
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		self.navigationController?.popToRootViewController(animated: false)
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
		self.productList = []
		self.productListTitle.text = productTitle
		if isFromBrand{
			productList = arrProductList
			self.getBrandProduct(value: valueFromBrand)
		}else{
			productList = arrProductList
			self.getCategoryProduct(value: String(valueFromCategory))
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		tabBarController?.delegate = self
		
        // Do any additional setup after loading the view.
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.productList.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 200
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		if isFromBrand{
			if ((self.productList.count > 9) && (self.page != 0)){
				if indexPath.row == (self.productList.count - 1) {
					self.page += 1
					self.getBrandProduct(value: valueFromBrand)
				}
			}
		}else{
			if ((self.productList.count > 9) && (self.page != 0)){
				if indexPath.row == (self.productList.count - 1) {
					self.page += 1
					self.getCategoryProduct(value: String(valueFromCategory))
				}
			}
		}
		
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cellCategory:ArrivalsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "arrivalsCellIdentifier", for: indexPath) as! ArrivalsTableViewCell
		
		let a:Product = self.productList[indexPath.row]
		cellCategory.lbName.text = a.name
		if a.price != nil {
			cellCategory.lbPrice.text = String(format: "AED %.2f", a.price!)
		}
		
		if self.productList[indexPath.row].fileImage != nil {
			cellCategory.imgProd.sd_setImage(with: URL(string:a.fileImage!), placeholderImage: UIImage(named: "imgDefault"))
		}
		
		if self.productList[indexPath.row].image != nil {
			cellCategory.imgProd.sd_setImage(with: URL(string:a.image!), placeholderImage: UIImage(named: "imgDefault"))
		}
		
		if isFromBrand {
			if self.productList[indexPath.row].fileImage != nil {
				cellCategory.imgProd.sd_setImage(with: URL(string:a.fileImage!), placeholderImage: UIImage(named: "imgDefault"))
			}
		}
		
		if self.productList[indexPath.row].isConfig == "configurable" {
			cellCategory.lbMoreChoices.isHidden = false
		}else{
			cellCategory.lbMoreChoices.isHidden = true
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
	
	func getBrandProduct(value:String){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			if page < 3{
				SVProgressHUD.show()
			}
//			SVProgressHUD.show(withStatus: "Loading Request")
//			self.brandProduct = []
			let urlString =  PBaseUrl + "products?searchCriteria[filterGroups][0][filters][0][field]=manufacturer& searchCriteria[filterGroups][0][filters][0][value]=" + value + "& searchCriteria[sortOrders][0][direction]=DESC& searchCriteria[pageSize]=10& searchCriteria[currentPage]=" + String(self.page) + "&searchCriteria[filterGroups][1][filters][0][field]=status&searchCriteria[filterGroups][2][filters][0][field]=visibility& searchCriteria[filterGroups][2][filters][0][value]=1& searchCriteria[filterGroups][1][filters][0][value]=1& searchCriteria[filterGroups][2][filters][0][condition_type]=neq&" + self.strAppend
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCallDictionary(urlString: encodedUrl!	, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				//				print(success)
				let items = success["items"] as! NSArray
				
				if items.count > 0{
					for dictionary in items{
						let prod:Product = Product(dictionary: dictionary as! NSDictionary)
						if prod.name == "" {}
						self.productList.append(prod)
					}
				}else{
					self.page = 0
				}
				
				
				
//				let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "productListID") as! ProductListViewController
//				nextViewController.productList = self.brandProduct
//				nextViewController.isFromBrand = true
//				nextViewController.productTitle = title
//				self.navigationController?.pushViewController(nextViewController, animated: true)
				
				self.productListTableView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func getCategoryProduct(value:String){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			if page < 3{
				SVProgressHUD.show()
			}
			
			
			//			self.brandProduct = []
			let urlString =  PBaseUrl + "products?searchCriteria[filterGroups][0][filters][0][field]=category_id& searchCriteria[filterGroups][0][filters][0][value]=" + value + "& searchCriteria[sortOrders][0][direction]=DESC& searchCriteria[pageSize]=10& searchCriteria[currentPage]=" + String(self.page) + "&searchCriteria[filterGroups][1][filters][0][field]=status&searchCriteria[filterGroups][2][filters][0][field]=visibility& searchCriteria[filterGroups][2][filters][0][value]=1& searchCriteria[filterGroups][1][filters][0][value]=1& searchCriteria[filterGroups][2][filters][0][condition_type]=neq&" + self.strAppend
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCallDictionary(urlString: encodedUrl!	, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				//				print(success)
				let items = success["items"] as! NSArray
				if items.count > 0{
					for dictionary in items{
						let prod:Product = Product(dictionary: dictionary as! NSDictionary)
						if prod.name == "" {}
						self.productList.append(prod)
					}
				}else{
					self.page = 0
				}
				
				//				let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "productListID") as! ProductListViewController
				//				nextViewController.productList = self.brandProduct
				//				nextViewController.isFromBrand = true
				//				nextViewController.productTitle = title
				//				self.navigationController?.pushViewController(nextViewController, animated: true)
				
				self.productListTableView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if (segue.identifier == "productListID") {
			let vc = segue.destination as! ProductViewController
			let indexPaths = self.productListTableView.indexPathForSelectedRow
			let indexPath = indexPaths! as NSIndexPath
			vc.productName = self.productList[indexPath.row].sku!
			
			//			vc.params = self.params
		}
		//filterProductListID
		if (segue.identifier == "filterProductListID") {
			let vc = segue.destination as! ViewController
			if isFromBrand{
				vc.categoryId = self.valueFromBrand
			}else{
				vc.categoryId = String(self.valueFromCategory)
			}
			
			
			//			vc.params = self.params
		}
		
	}
//	productListID

}
