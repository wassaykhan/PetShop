//
//  OrderDetailViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 20/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var orderTableView: UITableView!
	@IBOutlet weak var lbOrderID: UILabel!
	@IBOutlet weak var lbOrderStatus: UILabel!
	@IBOutlet weak var lbOrderItemSubTotal: UILabel!
	@IBOutlet weak var lbOrderShippingRate: UILabel!
	@IBOutlet weak var lbOrderTotal: UILabel!
	
	var orderItemArray:Array<OrderItems> = []
	var orderCompleteData:OrderDetail?
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.lbOrderID.text = orderCompleteData?.incrementID
		self.lbOrderTotal.text = String(format: "AED %.2f", (self.orderCompleteData?.grandTotal)!)
		self.lbOrderStatus.text = orderCompleteData?.status
		self.lbOrderItemSubTotal.text = String(format: "AED %.2f", (self.orderCompleteData?.grandTotal)!)
        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return orderItemArray.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 215
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellOrder:OrderDetailPTableViewCell = tableView.dequeueReusableCell(withIdentifier: "orderDetailCellIdentifier", for: indexPath) as! OrderDetailPTableViewCell
		cellOrder.lbName.text = self.orderItemArray[indexPath.row].name
		if self.orderItemArray[indexPath.row].weight != nil {
			cellOrder.lbSize.titleLabel?.text = String(format: "%.2f", self.orderItemArray[indexPath.row].weight!)
		}
		
		cellOrder.lbPrice.text = String(format: "AED %.2f", self.orderItemArray[indexPath.row].price!)
		cellOrder.lbQuantity.titleLabel?.text = String(format: "%.2f", self.orderItemArray[indexPath.row].quantity!)
		return cellOrder
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
