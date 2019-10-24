//
//  OrdersViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 27/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class OrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
//ordersCellIdentifier
	@IBOutlet weak var ordersTableView: UITableView!
	var orderArr:Array<OrderDetail> = []
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.getOrders()
        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.orderArr.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellOrder:OrdersTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ordersCellIdentifier", for: indexPath) as! OrdersTableViewCell
		cellOrder.lbStatus.text = self.orderArr[indexPath.row].status
		cellOrder.lbOrderID.text = self.orderArr[indexPath.row].incrementID
		return cellOrder
	}

	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func getOrders(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show(withStatus: "Loading Request")
			self.orderArr = []
			let customerID = String(UserDefaults.standard.integer(forKey: "id"))
			let urlString =  PBaseUrl + "orders?searchCriteria[filterGroups][0][filters][0][field]=customer_id&searchCriteria[filterGroups][0][filters][0][value]=" + customerID + "&searchCriteria[filterGroups][0][filters][0][conditionType]=eq"
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
					let order:OrderDetail = OrderDetail(dictionary: dictionary as! NSDictionary)
					self.orderArr.append(order)
				}
				self.ordersTableView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	//orderDetailID
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		if (segue.identifier == "orderDetailID") {
			let vc = segue.destination as! OrderDetailViewController
			let indexPaths = self.ordersTableView.indexPathForSelectedRow
			let indexPath = indexPaths! as NSIndexPath
			vc.orderItemArray = self.orderArr[indexPath.row].orderItems
			vc.orderCompleteData = self.orderArr[indexPath.row]
		}
    }
	

}
