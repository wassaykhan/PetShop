//
//  ProductViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 19/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,UIPickerViewDataSource {

	@IBOutlet weak var sizePickerView: UIPickerView!
	@IBOutlet weak var lbSize: UILabel!
	
	var size = ["24 Lb Bag", "26 Lb Bag", "28 Lb Bag", "30 Lb Bag"]
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	@IBOutlet weak var categoryView: UIView!
	@IBOutlet weak var productCollectionView: UICollectionView!
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 7
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellCategory:LatestProductCollectionViewCell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "latestProdCellIdentifier", for: indexPath) as! LatestProductCollectionViewCell
		return cellCategory
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 175, height: 195)
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		
		return 4
//		if pickerView.tag == 1 {
//			return arrCities.count
//		}else{
//			return arrArea.count
//		}
		
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return size[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
		self.lbSize.text = size[row]
		sizePickerView.isHidden = true
	}
	
	@IBAction func btnHighlightsAction(_ sender: Any) {
		self.categoryView.isHidden = true
	}
	@IBAction func btnIngredientAction(_ sender: Any) {
		self.categoryView.isHidden = false
	}
	@IBAction func btnSizeChartAction(_ sender: Any) {
		self.categoryView.isHidden = false
	}
	@IBAction func btnFeeding(_ sender: Any) {
		self.categoryView.isHidden = false
	}
	@IBAction func btnSelectSizeAction(_ sender: Any) {
		sizePickerView.isHidden = false
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
