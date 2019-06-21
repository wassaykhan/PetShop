//
//  BrandViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 20/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class BrandViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	@IBOutlet weak var brandTableView: UITableView!
	
	var brandDictionary = [String: [String]]()
	var brandSectionTitles = [String]()
	var brands = [String]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		brands = ["A Pet Hub", "ABO Gear", "Adams", "BMW", "Bugatti", "Bentley","Chevrolet", "Cadillac","Dodge","Ferrari", "Ford","Honda","Jaguar","Lamborghini","Mercedes", "Mazda","Nissan","Porsche","Rolls Royce","Toyota","Volkswagen"]
		
		for brand in brands {
			let brandKey = String(brand.prefix(1))
			if var brandValues = brandDictionary[brandKey] {
				brandValues.append(brand)
				brandDictionary[brandKey] = brandValues
			} else {
				brandDictionary[brandKey] = [brand]
			}
		}
		
		// 2
		brandSectionTitles = [String](brandDictionary.keys)
		brandSectionTitles = brandSectionTitles.sorted(by: { $0 < $1 })
		
        // Do any additional setup after loading the view.
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		// 1
		return brandSectionTitles.count
	}
    
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let brandKey = brandSectionTitles[section]
		if let brandValues = brandDictionary[brandKey] {
			return brandValues.count
		}
		
		return 10
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellOrder:BrandTableViewCell = tableView.dequeueReusableCell(withIdentifier: "brandCellIdentifier", for: indexPath) as! BrandTableViewCell
		let brandKey = brandSectionTitles[indexPath.section]
		if let brandValues = brandDictionary[brandKey] {
			cellOrder.lbBrand.text = brandValues[indexPath.row]
		}
		
		
		return cellOrder
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return brandSectionTitles[section]
	}
	
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return brandSectionTitles
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
