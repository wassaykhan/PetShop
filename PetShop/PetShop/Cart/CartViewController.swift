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

class CartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var cartTableView: UITableView!
	@IBOutlet weak var lbSubTotal: UILabel!
	var cartArr:Array<Cart> = []
	var finalPrice:Float = 0.0
	override func viewDidLoad() {
        super.viewDidLoad()
		self.lbSubTotal.text = ""
		let customerToken = UserDefaults.standard.string(forKey: "customerToken")
		if customerToken != nil {
			self.getCartDetail()
		}
		
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
		cellOrder.lbName.text = self.cartArr[indexPath.row].name
		if self.cartArr[indexPath.row].quantity != nil {
			cellOrder.lbQuantity.titleLabel!.text = String(format: "AED %.2f", self.cartArr[indexPath.row].quantity!)
		}
		if self.cartArr[indexPath.row].price != nil {
			cellOrder.lbPrice.text = String(format: "AED %.2f", self.cartArr[indexPath.row].price!)
		}
		
		cellOrder.onSubTapped = {
			print("remove")
			self.deleteCart(cartID: self.cartArr[indexPath.row].itemID!)
		}
		
		return cellOrder
	}
	
	func deleteCart(cartID:Int){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PCartRemove + String(cartID)
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.deleteCall(urlString: encodedUrl!, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				self.getCartDetail()
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
			
			SVProgressHUD.show(withStatus: "Loading Request")
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
					totalPrice += prod.price!
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
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func btnCheckoutAction(_ sender: Any) {
		//reviewOrderID
		let customerToken = UserDefaults.standard.string(forKey: "customerToken")
		if customerToken != nil || cartArr.count < 1 {
			let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "reviewID") as! ReviewOrderViewController
			nextViewController.total = self.finalPrice
			self.navigationController?.pushViewController(nextViewController, animated: true)
		}else {
			let alert = UIAlertController(title: "Empty", message: "Please add products to your cart", preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
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
