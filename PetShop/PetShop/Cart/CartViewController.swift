//
//  CartViewController.swift
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

class CartViewController: UIViewController,UITabBarControllerDelegate,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var viewFooter: UIView!
	@IBOutlet weak var cartTableView: UITableView!
	@IBOutlet weak var lbSubTotal: UILabel!
	@IBOutlet weak var btnNoData: UIButton!
	var cartArr:Array<Cart> = []
	var finalPrice:Float = 0.0
	var isUser = false
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
		self.lbSubTotal.text = ""
		let customerToken = UserDefaults.standard.string(forKey: "customerToken")
		if customerToken != nil {
			isUser = true
			self.getCartProduct()
		}else{
			
			self.cartArr = []
			self.viewFooter.isHidden = false
			self.btnNoData.isHidden = true
			self.cartTableView.isHidden = false
			return
			isUser = false
			
			if isKeyPresentInUserDefaults(key: "items"){
				let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "items") as! Data) as! [GuestCart]
				for items in decodedArray{
					let cart = Cart(guestData: items)
					self.cartArr.append(cart)
				}
				
				if cartArr.count < 1 {
					self.viewFooter.isHidden = true
					self.btnNoData.isHidden = false
					self.cartTableView.isHidden = true
				}else{
					self.viewFooter.isHidden = false
					self.btnNoData.isHidden = true
					self.cartTableView.isHidden = false
				}
				
				self.cartTableView.reloadData()
			}
			
			
			//			print(decodedArray[0].name as Any)
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		
        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.cartArr.count
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 215
	
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellOrder:CartTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cartCellIdentifier", for: indexPath) as! CartTableViewCell
		
		if isUser{
			cellOrder.lbName.text = self.cartArr[indexPath.row].name
			if self.cartArr[indexPath.row].quantity != nil {
				cellOrder.lbQty.text = String(format: "%.0f", self.cartArr[indexPath.row].quantity!)
			}
			if self.cartArr[indexPath.row].price != nil {
				cellOrder.lbPrice.text = String(format: "AED %.2f", self.cartArr[indexPath.row].price!)
			}
			
			if self.cartArr[indexPath.row].weight != nil {
				if self.cartArr[indexPath.row].weight == ""{
					cellOrder.lbSizeValue.text =  self.cartArr[indexPath.row].weight!
				}else{
					cellOrder.lbSizeValue.text =  self.cartArr[indexPath.row].weight!
				}
				
			}
			
			if self.cartArr[indexPath.row].value != nil {
				if self.cartArr[indexPath.row].value == ""{
					cellOrder.heightTopName.constant = 0
					cellOrder.widthLbSize.constant = 0
					cellOrder.viewBot.isHidden = true
					cellOrder.lbCustomName.text = ""
					cellOrder.heightLbSize.constant = 0
				}else{
					cellOrder.lbCustomName.text =  self.cartArr[indexPath.row].value!
				}
			}
			
			if self.cartArr[indexPath.row].fileImage != nil {
				cellOrder.imgProduct.sd_setImage(with: URL(string:self.cartArr[indexPath.row].fileImage!), placeholderImage: UIImage(named: "imgDefault"))
			}
			
			cellOrder.onSubTapped = {
				print("remove")
				self.deleteCart(cartID: self.cartArr[indexPath.row].itemID!)
			}
		}else{
			cellOrder.lbName.text = self.cartArr[indexPath.row].guestData?.name
			
			if self.cartArr[indexPath.row].guestData?.price != nil {
				cellOrder.lbPrice.text = String(format: "AED %.2f", (self.cartArr[indexPath.row].guestData?.price)!)
			}
			
			if self.cartArr[indexPath.row].guestData?.image != nil {
				cellOrder.imgProduct.sd_setImage(with: URL(string:(self.cartArr[indexPath.row].guestData?.image)!), placeholderImage: UIImage(named: "imgDefault"))
			}
			
			if self.cartArr[indexPath.row].guestData?.option_id != nil {
				if self.cartArr[indexPath.row].guestData?.option_id == ""{
					cellOrder.heightTopName.constant = 0
					cellOrder.widthLbSize.constant = 0
					cellOrder.viewBot.isHidden = true
					cellOrder.lbCustomName.text = ""
					cellOrder.heightLbSize.constant = 0
				}else{
					cellOrder.lbCustomName.text =  self.cartArr[indexPath.row].guestData?.option_id!
					cellOrder.lbSizeValue.text =  self.cartArr[indexPath.row].guestData?.option_value!
				}
			}
			
			
			if self.cartArr[indexPath.row].guestData?.qty != nil {
				cellOrder.lbQty.text = String((self.cartArr[indexPath.row].guestData?.qty)!)
			}
			
			cellOrder.onSubTapped = {
				print("remove")
				
				
				
//				self.deleteCart(cartID: self.cartArr[indexPath.row].itemID!)
			}
		}
		
		
		
		return cellOrder
	}
	
	func deleteCart(cartID:Int){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PCartRemove + String(cartID)
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.deleteCall(urlString: encodedUrl!, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				self.getCartProduct()
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	
	func getCartDetail(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PCart
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCall(urlString: encodedUrl!, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				self.cartArr = []
				var totalPrice:Float = 0.0
				for dictionary in success{
					let prod:Cart = Cart(dictionary: dictionary as! NSDictionary)
					totalPrice += prod.price! * prod.quantity!
					self.getImages(sku: prod.sku!,index: self.cartArr.count)
					self.cartArr.append(prod)
					
				}
				self.finalPrice = totalPrice
				self.lbSubTotal.text = "AED " + String(totalPrice)
				self.cartTableView.reloadData()
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func getCartProduct() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			//			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PGetCartProducts
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			
			let cartItems:[String:AnyObject] = ["cus_token":customerToken as AnyObject, "admin_token":adminToken as AnyObject]
			
			let param:[String:AnyObject] = [
				"data" : cartItems as AnyObject
			]
			
//			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			
			AlamofireCalls.postCallAnyWithHeaderDict(urlString: urlString, parameters: param, headers: headers, completion: {
				(token) -> Void in
				print("from Shipping")
				print(token)
				self.cartArr = []
				let arrProductDetail = token["product_detail"] as! NSArray
				
				if arrProductDetail.count > 0 {
					
					var totalPrice:Float = 0.0
					for dictionary in arrProductDetail{
						let prod:Cart = Cart(dictionary: dictionary as! NSDictionary)
						totalPrice += prod.price! * prod.quantity!
//						self.getImages(sku: prod.sku!,index: self.cartArr.count)
						self.cartArr.append(prod)
						
					}
					self.viewFooter.isHidden = false
					self.btnNoData.isHidden = true
					self.cartTableView.isHidden = false
					
					
					self.finalPrice = totalPrice
					self.lbSubTotal.text = "AED " + String(totalPrice)
					self.cartTableView.reloadData()
				}else{
					UserDefaults.standard.removeObject(forKey: "badgeCount")
					self.cartTableView.reloadData()
					self.viewFooter.isHidden = true
					self.btnNoData.isHidden = false
					self.cartTableView.isHidden = true
				}
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	
	func getImages(sku:String,index:Int) {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			let urlString =  PBaseUrl + "products/" + sku + "/media"
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			let parameters:[String:String] = [:]
			AlamofireCalls.getCall(urlString: urlString, parameters: parameters, headers: headers, completion: {
				(token) -> Void in
				print("from Cart Images")
				print(token)
				for imagesDict in token{
					let dic = imagesDict as! NSDictionary
					if let typeArr = dic["types"] as? NSArray{
						if typeArr.count > 0{
							let fileName = dic["file"] as! String
							let imageUrl = "http://www.thepetstore.ae/pub/media/catalog/product" + fileName
							self.cartArr[index].image = imageUrl
							self.cartTableView.reloadData()
						}
					}
					
				}
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	
	
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func btnCheckoutAction(_ sender: Any) {
		//reviewOrderID
		let customerToken = UserDefaults.standard.string(forKey: "customerToken")
		if customerToken != nil  {
			//|| cartArr.count < 1
			let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "reviewID") as! ReviewOrderViewController
			nextViewController.total = self.finalPrice
			self.navigationController?.pushViewController(nextViewController, animated: true)
		}else {
			UserDefaults.standard.set("yes", forKey: "checkout")
			_ = self.tabBarController?.selectedIndex = 3
			
		}
	}
	
	func getCartID() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PCartId
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			if customerToken == nil {
				return
			}
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.postCallAnyWithOnlyHeader(urlString: urlString, headers: headers, completion: {
				(token) -> Void in
				print("from Product View")
				print(token)
//				self.setCartItem(quoteID: token)
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	/*
	func setCartItem(quoteID:Int) {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			//			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PCart
			
			let extensionAttributes:[String:AnyObject] = [:]
			
			var cartItems:[String:AnyObject] = [:]
			
			if productType == "configurable" {
				
				var dictionaries = [[String: AnyObject]]()
				if self.attributeID == "" || self.finalWeight == "" {
					SVProgressHUD.dismiss()
					let alert = UIAlertController(title: "Incomplete Selection", message: "No Weight/Size Selected", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					self.present(alert, animated: true, completion: nil)
					return
				}
				let dictionary1: [String: AnyObject] = ["option_id": self.attributeID as AnyObject, "option_value": Int(self.finalWeight) as AnyObject ]
				dictionaries.append(dictionary1)
				
				let extAttribute:[String:AnyObject] = ["configurable_item_options":dictionaries as AnyObject]
				
				let productOption:[String:AnyObject] = ["extension_attributes": extAttribute as AnyObject]
				
				cartItems = ["sku":self.productDetail?.sku as AnyObject, "qty": (quantitySelected + 1) as AnyObject, "quote_id" : quoteID as AnyObject, "product_option" : productOption as AnyObject, "extension_attributes" : extensionAttributes as AnyObject]
			}else {
				cartItems = ["sku":self.productDetail?.sku as AnyObject, "qty":1 as AnyObject, "quote_id" : quoteID as AnyObject, "extension_attributes" : extensionAttributes as AnyObject]
			}
			
			let param:[String:AnyObject] = [
				"cartItem" : cartItems as AnyObject
			]
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			
			AlamofireCalls.postCallAnyWithHeaderDict(urlString: urlString, parameters: param, headers: headers, completion: {
				(token) -> Void in
				print("from Shipping")
				print(token)
				
				self.getCartDetail()
				
				let alert = UIAlertController(title: "Product Added to Cart", message: "Happy Shopping", preferredStyle: UIAlertController.Style.alert)
				let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
				alert.addAction(defaultAction)
				self.present(alert, animated: true, completion: nil)
				
				
				
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	*/
	
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIViewController{
	func isKeyPresentInUserDefaults(key: String) -> Bool {
		return UserDefaults.standard.object(forKey: key) != nil
	}
}
