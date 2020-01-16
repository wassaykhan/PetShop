//
//  OrderDetailViewController.swift
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

class OrderDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var orderTableView: UITableView!
	@IBOutlet weak var lbOrderID: UILabel!
	@IBOutlet weak var lbOrderStatus: UILabel!
	@IBOutlet weak var lbOrderItemSubTotal: UILabel!
	@IBOutlet weak var lbOrderShippingRate: UILabel!
	@IBOutlet weak var lbOrderTotal: UILabel!
	@IBOutlet weak var lbVAT: UILabel!
	@IBOutlet weak var lbTotalVAT: UILabel!
	
	var orderItemArray:Array<OrderItems> = []
	var orderCompleteData:OrderDetail?
	var cartArr:Array<Cart> = []
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.getCartProduct()
		self.lbOrderID.text = orderCompleteData?.incrementID
		self.lbOrderTotal.text = String(format: "AED %.2f", (self.orderCompleteData?.grandTotal)!)
		let tax = (self.orderCompleteData?.grandTotal)! * 0.05
		self.lbVAT.text = String(format: "AED %.2f", tax)
		let totaltax = (self.orderCompleteData?.grandTotal)! - tax
		self.lbTotalVAT.text = String(format: "AED %.2f", totaltax)
		self.lbOrderStatus.text = orderCompleteData?.status
		self.lbOrderItemSubTotal.text = String(format: "AED %.2f", (self.orderCompleteData?.grandTotal)!)
		
//		for item in orderItemArray{
//			self.getImages(sku: item.sku, index: <#T##Int#>)
//		}
		for (index, element) in orderItemArray.enumerated() {
			print("Item \(index): \(element)")
			self.getImages(sku: element.sku!, index: index)
		}
		
//		self.getImages(sku: prod.sku!,index: self.orderItemArray.count)
        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cartArr.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 215
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellOrder:OrderDetailPTableViewCell = tableView.dequeueReusableCell(withIdentifier: "orderDetailCellIdentifier", for: indexPath) as! OrderDetailPTableViewCell
		cellOrder.lbName.text = self.cartArr[indexPath.row].name
//		if self.orderItemArray[indexPath.row].weight != nil {
//			cellOrder.lbSize.titleLabel?.text = String(format: "%.2f", self.orderItemArray[indexPath.row].weight!)
//		}
		if self.cartArr[indexPath.row].weight != nil {
			if self.cartArr[indexPath.row].weight == ""{
				cellOrder.lbSize.text =  self.cartArr[indexPath.row].weight!
			}else{
				cellOrder.lbSize.text =  self.cartArr[indexPath.row].weight!
			}
			
		}
		
//		if self.orderItemArray[indexPath.row].image != nil {
//			cellOrder.imgProd.sd_setImage(with: URL(string:self.orderItemArray[indexPath.row].image!), placeholderImage: UIImage(named: "imgDefault"))
//		}
		
		if self.cartArr[indexPath.row].value != nil {
			if self.cartArr[indexPath.row].value == ""{
				cellOrder.heightTop.constant = 0
				cellOrder.viewSecond.isHidden = true
				cellOrder.lbSize.isHidden = true
				cellOrder.lbSizeHeading.isHidden = true
			}else{
				cellOrder.lbSizeHeading.text =  self.cartArr[indexPath.row].value!
			}
		}
		
		if self.cartArr[indexPath.row].fileImage != nil {
			cellOrder.imgProd.sd_setImage(with: URL(string:self.cartArr[indexPath.row].fileImage!), placeholderImage: UIImage(named: "imgDefault"))
		}
		if self.cartArr[indexPath.row].price != nil {
			cellOrder.lbPrice.text = String(format: "AED %.2f", self.cartArr[indexPath.row].price!)
		}
		if self.cartArr[indexPath.row].quantity != nil {
			cellOrder.lbQuantity.text = String(format: "%.0f", self.cartArr[indexPath.row].quantity!)
		}
//		cellOrder.lbPrice.text = String(format: "AED %.2f", self.orderItemArray[indexPath.row].price!)
//		cellOrder.lbQuantity.titleLabel?.text = String(format: "%.2f", self.orderItemArray[indexPath.row].quantity!)
		
		return cellOrder
	}
	
	func getCartProduct() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PGetOrderReview
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			
			let cartItems:[String:AnyObject] = ["admin_token":adminToken as AnyObject, "order_num":orderItemArray[0].orderID as AnyObject]
			
			let param:[String:AnyObject] = [
				"code" : cartItems as AnyObject
			]
			
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			
			AlamofireCalls.postCallAnyWithHeaderDict(urlString: urlString, parameters: param, headers: headers, completion: {
				(token) -> Void in
				print("from Order Detail")
				self.cartArr = []
				let order_detail = token["order_detail"] as! NSArray
				for dictionary in order_detail{
					let prod:Cart = Cart(dictionary: dictionary as! NSDictionary)
//					totalPrice += prod.price! * prod.quantity!
					self.getImages(sku: prod.sku!,index: self.cartArr.count)
					self.cartArr.append(prod)
					
				}
				print(self.cartArr)
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
							self.orderItemArray[index].image = imageUrl
							self.orderTableView.reloadData()
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
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
