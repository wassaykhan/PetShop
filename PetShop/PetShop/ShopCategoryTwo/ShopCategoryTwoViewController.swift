//
//  ShopCategoryTwoViewController.swift
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

class ShopCategoryTwoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

	@IBOutlet weak var shopCategoryCollectionView: UICollectionView!
	@IBOutlet weak var lbTitle: UILabel!
	var categoryID = 0
	var petCategories:Array<PetCategories> = []
	var bannerImage = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		self.lbTitle.text = ""
		self.shopCategoryCollectionView.delegate = self
		self.shopCategoryCollectionView.dataSource = self
		// Do any additional setup after loading the view.
		self.getCategory()
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.petCategories.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellCategory:ShopCategoryCollectionViewCell = shopCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellIdentifier", for: indexPath) as! ShopCategoryCollectionViewCell
		cellCategory.lbProd.text = self.petCategories[indexPath.row].name
		if self.petCategories[indexPath.row].image != nil {
			cellCategory.imgProd.sd_setImage(with: URL(string:self.petCategories[indexPath.row].image!), placeholderImage: UIImage(named: ""))
		}
		return cellCategory
	}
	
	func getCategory(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PCategories + String(self.categoryID)
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCall(urlString: urlString, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				self.petCategories = []
				for dictionary in success{
					
					let JSON = dictionary as! NSDictionary
					self.lbTitle.text = JSON["name"] as? String
//					self.bannerImage = JSON["banner"] as! String
					if JSON["children"] != nil {
						let arr = JSON["children"] as! NSArray
						for dictChild in arr{
							let categoryData:PetCategories = PetCategories(dictionaryWithProduct: dictChild as! NSDictionary)
							self.petCategories.append(categoryData)
						}
					}
					
				}
				self.shopCategoryCollectionView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		//iphone X XS
		if UIScreen.main.nativeBounds.height == 2436 {
			return CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/4 - 10)
		}//2688 iphone XS_Max
		if UIScreen.main.nativeBounds.height == 2688 {
			return CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/4 - 10)
		}//1792 iphone XR
		if UIScreen.main.nativeBounds.height == 1792 {
			return CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/4 - 10)
		}
		return CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/3 - 10)
	}
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "productListID") as! ProductListViewController
				//				let arrM = self.petCategories[indexPath.row - 2].productArr
		nextViewController.productList = self.petCategories[indexPath.row].productArr
		self.navigationController?.pushViewController(nextViewController, animated: true)
		
		
		
	}
	
	//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/

}
