//
//  AttributeViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 27/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class AttributeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
	@IBOutlet weak var AttributeTableView: UITableView!
	@IBOutlet weak var lbSelect: UILabel!
	
	var price = ""
	var weight = ""
	var select = ""
	var selectedText = ""
	var tag:Int?
	var attributeData:Array<Attributes> = []
	var attributeCustomData:Array<ProductAttributes> = []
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
//		self.AttributeTableView.reloadData()
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		self.lbSelect.text = "Select " + select
		self.AttributeTableView.reloadData()
	}
	
	var onRadioTapped : (() -> Void)? = nil
	
	@IBAction func btnCancelAction(_ sender: Any) {
		
//		nc.postNotificationName("printValue", object: nil, userInfo: ["value" : "Pass Me this string"])
		
		dismiss(animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let nc = NotificationCenter.default
		nc.post(name: NSNotification.Name(rawValue: "desiredEventHappend"), object: nil, userInfo: ["tag":String(indexPath.row),"label":self.attributeCustomData[indexPath.row].weight_custom!,"value":self.attributeCustomData[indexPath.row].child_sku!,"price":String(self.attributeCustomData[indexPath.row].price!)])
		dismiss(animated: true, completion: nil)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return attributeCustomData.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 70
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellCategory:AttributeTableViewCell = self.AttributeTableView.dequeueReusableCell(withIdentifier: "attributeCellID", for: indexPath) as! AttributeTableViewCell
		cellCategory.lbPrice.text = "AED " + String(self.attributeCustomData[indexPath.row].price!)
		cellCategory.lbWeight.text = self.attributeCustomData[indexPath.row].weight_custom!
		if self.selectedText == self.attributeCustomData[indexPath.row].weight_custom! {
			cellCategory.btnRadio.setImage(UIImage(named: "RadioSelected"), for: .normal)
		}else{
			cellCategory.btnRadio.setImage(UIImage(named: "radioUnselected"), for: .normal)
		}
		return cellCategory
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
