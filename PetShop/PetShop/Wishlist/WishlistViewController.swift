//
//  WishlistViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 27/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SVProgressHUD
import SDWebImage

//arrivalsCellIdentifier
class WishlistViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var wishListTableView: UITableView!
	var productList:Array<Product>?
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.getWishListProducts()
        // Do any additional setup after loading the view.
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (self.productList?.count)!
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 180
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellWishList:WishlistTableViewCell = tableView.dequeueReusableCell(withIdentifier: "wishlistCellIdentifier", for: indexPath) as! WishlistTableViewCell
		cellWishList.lbTitle.text = self.productList![indexPath.row].name
		if self.productList![indexPath.row].price != nil {
			cellWishList.imgPrice.text = String(format: "AED %.2f", self.productList![indexPath.row].price!)
		}

		if self.productList![indexPath.row].fileImage != nil{
			cellWishList.imgProd.sd_setImage(with: URL(string:self.productList![indexPath.row].fileImage!), placeholderImage: UIImage(named: "imgDefault"))
		}

		cellWishList.onSubTapped = {
			if let itemId = self.productList?[indexPath.row].itemID{
				self.deleteWishListProducts(itemID: String(itemId),index: indexPath.row)
			}
			
		}
		
		return cellWishList
	}
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func getWishListProducts(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
			self.productList = []
			let urlString =  PBaseUrl + PWishList
//			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCallDictionary(urlString: urlString	, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				self.productList = []
				let wishListItem = success["wishlist_items"] as! NSArray
				for dictionary in wishListItem{
					let dict = dictionary as! NSDictionary
//					let products = dict["product"] as! NSDictionary
					let productFound = Product(dictionary: dict["product"] as! NSDictionary)
					productFound.itemID = dict["item_id"] as? Int
					
					self.productList?.append(productFound)
				}
				self.wishListTableView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func deleteWishListProducts(itemID:String,index:Int){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
//			self.productList = []
			let idUser = UserDefaults.standard.string(forKey: "id")
			let urlString =  PBaseUrl + PWishListDelete + idUser! + "/?wishlistItemId=" + itemID
			//			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCall(urlString: urlString	, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
//				self.productList = []
				self.productList?.remove(at: index)
				self.wishListTableView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	//wishListID
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if (segue.identifier == "wishListID") {
			let vc = segue.destination as! ProductViewController
			let indexPaths = self.wishListTableView.indexPathForSelectedRow
			let indexPath = indexPaths! as NSIndexPath
			vc.productName = self.productList![indexPath.row].sku!
			
			//			vc.params = self.params
		}
	}

}
