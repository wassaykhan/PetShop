//
//  FilterViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 13/10/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import YNExpandableCell

class FilterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, YNTableViewDelegate {

	@IBOutlet weak var filterTableView: YNTableView!
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		let cells = ["YNExpandableCellEx","YNSliderCell","YNSegmentCell"]
		self.filterTableView.registerCellsWith(nibNames: cells, and: cells)
		self.filterTableView.registerCellsWith(cells: [UITableViewCell.self as AnyClass], and: ["YNNonExpandableCell"])
		
		self.filterTableView.ynDelegate = self
		self.filterTableView.ynTableViewRowAnimation = .top
		self.getFilters()
        // Do any additional setup after loading the view.
    }
    /*
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cellCategory:FilterTableViewCell = tableView.dequeueReusableCell(withIdentifier: "filterID", for: indexPath) as! FilterTableViewCell
		return cellCategory
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 3
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Sections"
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 90
	}
	*/
	func tableView(_ tableView: YNTableView, expandCellWithHeightAt indexPath: IndexPath) -> YNTableViewCell? {
		/*
		let ynSliderCell = YNTableViewCell()
		ynSliderCell.cell = tableView.dequeueReusableCell(withIdentifier: YNSliderCell.ID) as! YNSliderCell
		ynSliderCell.height = 142
		*/
		let ynSegmentCell = YNTableViewCell()
		ynSegmentCell.cell = tableView.dequeueReusableCell(withIdentifier: YNSegmentCell.ID) as! YNSegmentCell
		ynSegmentCell.height = 50
		return ynSegmentCell
/*
if indexPath.section == 0 && indexPath.row == 1 {
			return ynSliderCell
		} else if indexPath.section == 0 && indexPath.row == 2 {
			return ynSegmentCell
		} else if indexPath.section == 0 && indexPath.row == 4 {
			return ynSegmentCell
		} else if indexPath.section == 1 && indexPath.row == 0 {
			return ynSegmentCell
		} else if indexPath.section == 1 && indexPath.row == 1 {
			return ynSliderCell
		} else if indexPath.section == 2 && indexPath.row == 2 {
			return ynSliderCell
		} else if indexPath.section == 2 && indexPath.row == 4 {
			return ynSliderCell
		}
		return nil
*/
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let expandableCell = tableView.dequeueReusableCell(withIdentifier: YNExpandableCellEx.ID) as! YNExpandableCellEx
		return expandableCell
		/*
		if indexPath.section == 0 && indexPath.row == 1 {
			expandableCell.titleLabel.text = "YNSlider Cell"
		} else if indexPath.section == 0 && indexPath.row == 2 {
			expandableCell.titleLabel.text = "YNSegment Cell"
		} else if indexPath.section == 0 && indexPath.row == 4 {
			expandableCell.titleLabel.text = "YNSegment Cell"
		} else if indexPath.section == 1 && indexPath.row == 0 {
			expandableCell.titleLabel.text = "YNSegment Cell"
		} else if indexPath.section == 1 && indexPath.row == 1 {
			expandableCell.titleLabel.text = "YNSlider Cell"
		} else if indexPath.section == 2 && indexPath.row == 2 {
			expandableCell.titleLabel.text = "YNSlider Cell"
		} else if indexPath.section == 2 && indexPath.row == 4 {
			expandableCell.titleLabel.text = "YNSlider Cell"
		} else {
			let nonExpandablecell = tableView.dequeueReusableCell(withIdentifier: "YNNonExpandableCell")
			nonExpandablecell?.textLabel?.text = "YNNonExpandable Cell"
			nonExpandablecell?.selectionStyle = .none
			return nonExpandablecell!
		}
		return expandableCell
		*/
	}
	
	func tableView(_ tableView: YNTableView, didSelectRowAt indexPath: IndexPath, isExpandableCell: Bool, isExpandedCell: Bool) {
		print("Selected Section: \(indexPath.section) Row: \(indexPath.row) isExpandableCell: \(isExpandableCell) isExpandedCell: \(isExpandedCell)")
	}
	
	func tableView(_ tableView: YNTableView, didDeselectRowAt indexPath: IndexPath, isExpandableCell: Bool, isExpandedCell: Bool) {
		print("Deselected Section: \(indexPath.section) Row: \(indexPath.row) isExpandableCell: \(isExpandableCell) isExpandedCell: \(isExpandedCell)")
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 5
		} else if section == 1 {
			return 5
		} else if section == 2 {
			return 5
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 30
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		if section == 0 {
//			return "Section 0"
//		} else if section == 1 {
//			return "Section 1"
//		} else if section == 2 {
//			return "Section 2"
//		}
		return ""
	}
	
	func getFilters(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
//			self.searchProduct = []
			let urlString =  PBaseUrl + PFilterLayer + "695" + "&id=" + "22"
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCallDictionary(urlString: encodedUrl!	, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				
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
