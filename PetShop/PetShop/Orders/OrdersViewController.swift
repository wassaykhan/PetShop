//
//  OrdersViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 27/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
//ordersCellIdentifier
	@IBOutlet weak var ordersTableView: UITableView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 8
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellOrder:OrdersTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ordersCellIdentifier", for: indexPath) as! OrdersTableViewCell
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
