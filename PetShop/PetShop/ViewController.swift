//
//  ViewController.swift
//  ExpandableHeaders
//
//  Created by Mac Os on 28/11/18.
//  Copyright © 2018 Mac Os. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import YNExpandableCell
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	

    let kHeaderSectionTag: Int = 6900;

    @IBOutlet weak var tableView: UITableView!
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionItems: Array<Any> = []
    var sectionNames: Array<Any> = []
	var filterVar: Array<String> = []
	var value: Array<Any> = []
	var rowSelected:Array<Int> = []
	var sectionSelected:Array<Int> = []
	var categoryId = "709"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFilters()
		filterVar = []
		value = [ [],
				  [],
				  [],[],[]
		]
        sectionNames = [];
        sectionItems = [ [],
                         [],
                         [],[],[]
                       ];
        self.tableView!.tableFooterView = UIView()
    }
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setStatusBarColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Tableview Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            tableView.backgroundView = nil
            return sectionNames.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 20.0)!
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            let arrayOfItems = self.sectionItems[section] as! NSArray
            return arrayOfItems.count;
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.sectionNames.count != 0) {
            return self.sectionNames[section] as? String
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.white//colorWithHexString(hexStr: "#0075d4")
        header.textLabel?.textColor = UIColor.black
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
        theImageView.image = UIImage(named: "plus-sign")
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
		
		let borderBottom = UIView(frame: CGRect(x:12, y:40, width: tableView.bounds.size.width - 24, height: 1.0))
		borderBottom.backgroundColor = UIColor.lightGray
		header.addSubview(borderBottom)
		
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(ViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! filterCVC
        let section = self.sectionItems[indexPath.section] as! NSArray
		cell.backgroundColor = UIColor.white
		cell.lbFilter.textColor = UIColor.black
        cell.lbFilter.text = section[indexPath.row] as? String
		//RadioSelected //radioUnselected
		cell.imgSelected.image = UIImage.init(named: "radioUnselected")
		if sectionSelected.count > 0{
			for row in 1...sectionSelected.count{
				if sectionSelected[row-1] == indexPath.section{
					if rowSelected[row-1] == indexPath.row{
						cell.imgSelected.image = UIImage.init(named: "RadioSelected")
					}
				}else{
//					cell.imgSelected.image = UIImage.init(named: "radioUnselected")
				}
			}
		}
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath.row)
		print(indexPath.section)
		if sectionSelected.count < 1 {
			sectionSelected.append(indexPath.section)
			rowSelected.append(indexPath.row)
			self.tableView.reloadData()
			return
		}
		
		var removeCondition = false
		for row in 1...sectionSelected.count{
			if sectionSelected.count >= row{
				if sectionSelected[row-1] == indexPath.section{
					sectionSelected.remove(at: row-1)
					rowSelected.remove(at: row-1)
					removeCondition = false
				}
			}
		}
		if removeCondition{
			print(sectionSelected)
		}else{
			sectionSelected.append(indexPath.section)
			rowSelected.append(indexPath.row)
		}
		
		print("Data")
		print(sectionSelected)
		print(rowSelected)
		self.tableView.reloadData()
	}
    
    // MARK: - Expand / Collapse Methods
    
	@objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionItems[section] as! NSArray
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
				imageView.image = UIImage(named: "plus-sign")
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
			self.tableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionItems[section] as! NSArray
        
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
				imageView.image = UIImage(named: "minus")
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableView!.beginUpdates()
			self.tableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
	
	//MARK: API
	func getFilters(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
			//			self.searchProduct = []
			let urlString =  PBaseUrl + PFilterLayer + categoryId + "&id=" + "22"
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCallDictionary(urlString: encodedUrl!	, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				self.sectionNames = []
				self.sectionItems = []
				self.value = []
				let arrFilter = success["availablefilter"] as! NSArray
				for item in arrFilter{
					let dictItem = item as? NSDictionary
					let name = dictItem!["name"] as! String
					let filter_var = dictItem!["filter_var"] as! String
					let arrData = dictItem!["data"] as! NSArray
					var array:Array<String> = []
					var arrValue:Array<String> = []
					for arrItem in arrData{
						let data = arrItem as! NSDictionary
						array.append(data["display"] as! String)
						arrValue.append(data["value"] as! String)
					}
					self.value.append(arrValue)
					self.filterVar.append(filter_var)
					self.sectionNames.append(name)
					self.sectionItems.append(array)
				}
				self.tableView.reloadData()
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
	
	
	func extractPriceData(str:String,ind:Int) -> String{
		let wordToFind:Character = "-"
		let index = str.index(of: wordToFind)
		var finalFilterData = ""
		if (index == 0) {
			let newString = str.replacingOccurrences(of: " ", with: "+")
			finalFilterData = "searchCriteria[filterGroups][" + String(ind) + "][filters][0][field]=price" +
				"&searchCriteria[filterGroups][" + String(ind) + "][filters][0][value]=0" +
				"&searchCriteria[filterGroups][" + String(ind) + "][filters][0][condition_type]=gteq" +
				"&searchCriteria[filterGroups][" + String(ind+1) + "][filters][0][field]=price" +
				"&searchCriteria[filterGroups][" + String(ind+1) + "][filters][0][value]=" + newString + "&"
		}else if (index == (str.count - 1)) {
			let newString = str.replacingOccurrences(of: " ", with: "+")
			finalFilterData += "searchCriteria[filterGroups][" + String(ind) + "][filters][0][field]=price" +
				"&searchCriteria[filterGroups][" + String(ind) + "][filters][0][value]=" + newString +
			"&searchCriteria[filterGroups][" + String(ind) + "][filters][0][condition_type]=gteq"+"&"
		}else {
			let arrPrice : [String] = str.components(separatedBy: "-")
			let firstprice : String = arrPrice[0]
			let lastprice : String = arrPrice[1]
			finalFilterData += "searchCriteria[filterGroups][" + String(ind) + "][filters][0][field]=price" +
				"&searchCriteria[filterGroups][" + String(ind) + "][filters][0][value]=" + firstprice +
			"&searchCriteria[filterGroups][" + String(ind) + "][filters][0][condition_type]=gteq" +
				"&searchCriteria[filterGroups][" + String(ind+1) + "][filters][0][field]=price" +
				"&searchCriteria[filterGroups][" + String(ind+1) + "][filters][0][value]=" + lastprice + "&"
		}
		
		return finalFilterData

	}
	
	
	
	
	@IBAction func btnDoneAction(_ sender: Any) {
		if sectionSelected.count > 0{
			var finalFilterData = ""
//			var j = 0
			for i in 1...sectionSelected.count{
				let j = i-1
				let filterV = filterVar[sectionSelected[j]]
				let section = self.value[sectionSelected[j]] as! NSArray
				let valueV = section[rowSelected[j]] as! String
				if filterV == "price"{
					finalFilterData += extractPriceData(str: valueV, ind: j+3)
//					let wordToFind:Character = "-"
//					let index = valueV.index(of: wordToFind)
//					if (index == 0){
//
//					}else if (index == (valueV.count - 1)){
//
//					}else{
//
//					}
				}else{
					finalFilterData += "searchCriteria[filterGroups][" + String(j+3) + "][filters][0][field]=" + filterV + "&searchCriteria[filterGroups][" + String(j+3) + "][filters][0][value]=" + valueV + "&"
				}
				
				
				
			}
			
			
			
			
			
			print(finalFilterData)
			if let a = self.navigationController?.viewControllers[0] as? NewArrivalsViewController{
				a.strAppend = finalFilterData
				self.navigationController?.popViewController(animated: true)
				return
			}
			if let ab = self.navigationController?.viewControllers[3] as? ProductListViewController{
				ab.strAppend = finalFilterData
				self.navigationController?.popViewController(animated: true)
				return
			}
			if let abc = self.navigationController?.viewControllers[2] as? ProductListViewController{
				abc.strAppend = finalFilterData
				self.navigationController?.popViewController(animated: true)
				return
			}
		}else{
			self.navigationController?.popViewController(animated: true)
		}
	}
	
}

class filterCVC:UITableViewCell{
	@IBOutlet weak var imgSelected: UIImageView!
	@IBOutlet weak var lbFilter: UILabel!
	
}

extension String {
	public func index(of char: Character) -> Int? {
		if let idx = characters.index(of: char) {
			return characters.distance(from: startIndex, to: idx)
		}
		return nil
	}
}
