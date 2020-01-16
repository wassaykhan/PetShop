//
//  BrandViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 20/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SVProgressHUD
import SDWebImage
import BadgeSwift

class BrandViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate {

	@IBOutlet weak var brandTableView: UITableView!
	
	@IBOutlet weak var lbBadgeCount: BadgeSwift!
	var brandDictionary = [String: [String]]()
	var brandData:Array<Brand> = []
	var brandSectionTitles = [String]()
	var brands = [String]()
	var brandID = 0
	
	var brandProduct:Array<Product> = []
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		self.navigationController?.popToRootViewController(animated: false)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
		tabBarController?.delegate = self
		self.brandTableView.sectionIndexColor = UIColor.init(red: 2/255, green: 166/255, blue: 178/255, alpha: 1)
		self.brandTableView.sectionIndexBackgroundColor = UIColor.clear
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
		
		self.getBrand()
        // Do any additional setup after loading the view.
    }
	
	func setBrand(){
		
		brands = []
		
		for label in self.brandData {
			let setB = label.label
			brands.append(setB!)
		}
		
//		brands = ["A Pet Hub", "ABO Gear", "Adams", "BMW", "Bugatti", "Bentley","Chevrolet", "Cadillac","Dodge","Ferrari", "Ford","Honda","Jaguar","Lamborghini","Mercedes", "Mazda","Nissan","Porsche","Rolls Royce","Toyota","Volkswagen"]
		
		for brand in brands {
			let brandKey = String(brand.prefix(1))
			if var brandValues = brandDictionary[brandKey] {
				brandValues.append(brand)
				brandDictionary[brandKey] = brandValues
			} else {
				brandDictionary[brandKey] = [brand]
			}
		}
		
		// 2
		brandSectionTitles = [String](brandDictionary.keys)
		brandSectionTitles = brandSectionTitles.sorted(by: { $0 < $1 })
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		// 1
		return brandSectionTitles.count
	}
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let brandKey = brandSectionTitles[section]
		if let brandValues = brandDictionary[brandKey] {
			return brandValues.count
		}
		
		return 10
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellOrder:BrandTableViewCell = tableView.dequeueReusableCell(withIdentifier: "brandCellIdentifier", for: indexPath) as! BrandTableViewCell
		let brandKey = brandSectionTitles[indexPath.section]
		if let brandValues = brandDictionary[brandKey] {
			cellOrder.lbBrand.text = brandValues[indexPath.row]
		}
		
		
		return cellOrder
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return brandSectionTitles[section]
	}
	
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return brandSectionTitles
	}
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
		
		let currentCell = self.brandTableView.cellForRow(at: indexPath!) as! BrandTableViewCell
		let brandLabel = currentCell.lbBrand.text
		var brandValue = ""
		for items in self.brandData{
			if items.label == brandLabel{
				brandValue = items.value!
			}
		}
//		print(currentCell.textLabel!.text)
		
		let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "productListID") as! ProductListViewController
//		nextViewController.productList = self.brandProduct
		nextViewController.isFromBrand = true
		nextViewController.productTitle = currentCell.lbBrand.text!
		nextViewController.valueFromBrand = brandValue
		self.navigationController?.pushViewController(nextViewController, animated: true)
		
//		self.getBrandProduct(value:brandValue,title: currentCell.lbBrand.text!)
	}

	func getBrandProduct(value:String, title:String){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
			self.brandProduct = []
			let urlString =  PBaseUrl + "products?searchCriteria[filterGroups][0][filters][0][field]=manufacturer& searchCriteria[filterGroups][0][filters][0][value]=" + value + "& searchCriteria[sortOrders][0][direction]=DESC& searchCriteria[pageSize]=10& searchCriteria[currentPage]=1&searchCriteria[filterGroups][1][filters][0][field]=status&searchCriteria[filterGroups][2][filters][0][field]=visibility& searchCriteria[filterGroups][2][filters][0][value]=1& searchCriteria[filterGroups][1][filters][0][value]=1& searchCriteria[filterGroups][2][filters][0][condition_type]=neq"
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
					let prod:Product = Product(dictionary: dictionary as! NSDictionary)
					if prod.name == "" {}
					self.brandProduct.append(prod)
				}
				
				let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "productListID") as! ProductListViewController
				nextViewController.productList = self.brandProduct
				nextViewController.isFromBrand = true
				nextViewController.productTitle = title
				self.navigationController?.pushViewController(nextViewController, animated: true)
				
//				self.brandTableView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func getBrand(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PBrand + String(self.brandID)
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCallDictionary(urlString: urlString, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				self.brandData = []
				
				let dict = success["availablefilter"] as! NSArray
				
				for dictionary in dict {
					
					let brand = dictionary as! NSDictionary
					
					if brand["name"] as! String  == "Brand"{
						
						let data = brand["data"] as! NSArray
						
						for brandP in data{
							let brands:Brand = Brand(dictionary: brandP as! NSDictionary)
							if brands.value != ""{
								self.brandData.append(brands)
							}
						}
						
						
					}
				}
				
				self.setBrand()
				
				self.brandTableView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	/*
	func getBrand(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show(withStatus: "")
			let urlString =  PBaseUrl + PAtoZ
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCall(urlString: urlString, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				self.brandData = []
				for dictionary in success {
					let brands:Brand = Brand(dictionary: dictionary as! NSDictionary)
					if brands.value != ""{
						self.brandData.append(brands)
					}
					
				}
				
				self.setBrand()
				
				self.brandTableView.reloadData()
				
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
		
		if (segue.identifier == "prodBrandID") {
			let vc = segue.destination as! ProductListViewController
//			let indexPaths = self.newArrivalTableView.indexPathForSelectedRow
//			let indexPath = indexPaths! as NSIndexPath
			vc.productList = []	
			
			//			vc.params = self.params
		}
	}

}
