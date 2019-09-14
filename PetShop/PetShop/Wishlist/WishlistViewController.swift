//
//  WishlistViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 27/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
//arrivalsCellIdentifier
class WishlistViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 8
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 142
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellOrder:WishlistTableViewCell = tableView.dequeueReusableCell(withIdentifier: "wishlistCellIdentifier", for: indexPath) as! WishlistTableViewCell
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
