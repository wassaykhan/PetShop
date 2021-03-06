//
//  ShopCategoryOneViewController.swift
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

class ShopCategoryOneViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITabBarControllerDelegate {

	@IBOutlet weak var shopCategoryCollectionView: UICollectionView!
	
	@IBOutlet weak var lbBadgeCount: BadgeSwift!
	@IBOutlet weak var textSearch: UITextField!
	@IBOutlet weak var lbTitle: UILabel!
	var categoryID = 0
	var petCategories:Array<PetCategories> = []
	var bannerImage = ""
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewDidAppear(_ animated: Bool) {
//		self.setStatusBarColor()
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
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		self.navigationController?.popToRootViewController(animated: false)
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
//		self.setStatusBarColor()
		tabBarController?.delegate = self
		print(categoryID)
		self.lbTitle.text = ""
		self.shopCategoryCollectionView.delegate = self
		self.shopCategoryCollectionView.dataSource = self
        // Do any additional setup after loading the view.
		self.getCategory()
    }
    

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if self.petCategories.count > 0 {
			return self.petCategories.count + 2
		}else {
			return 0
		}
		
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if indexPath.row == 0 {
			let cellCategory:ShopCategoryCollectionViewCell = shopCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryLongCellIdentifier", for: indexPath) as! ShopCategoryCollectionViewCell
			cellCategory.imgProd.sd_setImage(with: URL(string:self.bannerImage), placeholderImage: UIImage(named: "imgDefaultBanner"))
			return cellCategory
		}else if indexPath.row == 1 {
			let cellCategory:ShopCategoryCollectionViewCell = shopCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryAZCellIdentifier", for: indexPath) as! ShopCategoryCollectionViewCell
			return cellCategory
		}else {
			let cellCategory:ShopCategoryCollectionViewCell = shopCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellIdentifier", for: indexPath) as! ShopCategoryCollectionViewCell
			cellCategory.lbProd.text = self.petCategories[indexPath.row - 2].name
			if self.petCategories[indexPath.row - 2].image != nil {
				cellCategory.imgProd.sd_setImage(with: URL(string:self.petCategories[indexPath.row - 2].image!), placeholderImage: UIImage(named: "imgDefault"))
			}
			
			
			return cellCategory
		}
		
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		if indexPath.row == 0 {
			return CGSize(width: UIScreen.main.bounds.width - 20, height: 170)
		}
		
		//iphone X XS
		if UIScreen.main.nativeBounds.height == 2436 {
			//			return CGSize(width: UIScreen.main.bounds.width/2 - 20, height: UIScreen.main.bounds.height/4 - 20)
			return CGSize(width: UIScreen.main.bounds.width/2 - 17, height: UIScreen.main.bounds.height/4 - 33)
		}//2688 iphone XS_Max
		if UIScreen.main.nativeBounds.height == 2688 {
			return CGSize(width: UIScreen.main.bounds.width/2 - 17, height: UIScreen.main.bounds.height/4 - 33)
		}//1792 iphone XR
		if UIScreen.main.nativeBounds.height == 1792 {
			return CGSize(width: UIScreen.main.bounds.width/2 - 17, height: UIScreen.main.bounds.height/4 - 33)
		}
		return CGSize(width: UIScreen.main.bounds.width/2 - 17, height: 170)
	}
	
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	
	func getCategory(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
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
					self.bannerImage = JSON["banner"] as! String
					self.lbTitle.text = JSON["name"] as? String
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
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if indexPath.row == 1{
			let vc = self.storyboard?.instantiateViewController(withIdentifier: "BrandVCID") as! BrandViewController
			vc.brandID = self.categoryID
			self.navigationController?.pushViewController(vc, animated: true)
		}
		
		if indexPath.row > 1 {
			if self.petCategories[indexPath.row - 2].childern != "" {
				let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "categoryTwoID") as! ShopCategoryTwoViewController
				nextViewController.categoryID = self.petCategories[indexPath.row - 2].id!
				self.navigationController?.pushViewController(nextViewController, animated: true)
			}else {
				let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "productListID") as! ProductListViewController
//				let arrM = self.petCategories[indexPath.row - 2].productArr
				nextViewController.productList = self.petCategories[indexPath.row - 2].productArr
				nextViewController.productTitle = self.petCategories[indexPath.row - 2].name!
				nextViewController.valueFromCategory = self.petCategories[indexPath.row - 2].id!
				self.navigationController?.pushViewController(nextViewController, animated: true)
			}
		}
		
		
		
	}

	@IBAction func btnSearchAction(_ sender: Any) {
	}
	
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
