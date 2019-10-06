//
//  ProductViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 19/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SVProgressHUD
import SDWebImage

class ProductViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,UIPickerViewDataSource {

	@IBOutlet weak var sizePickerView: UIPickerView!
	@IBOutlet weak var lbSize: UILabel!
	@IBOutlet weak var lbProductHeading: UILabel!
	@IBOutlet weak var imgProduct: UIImageView!
	@IBOutlet weak var lbTitle: UILabel!
	@IBOutlet weak var lbPrice: UILabel!
	@IBOutlet weak var lbDiscription: UILabel!
	@IBOutlet weak var lbKeyBenefits: UILabel!
	@IBOutlet weak var productScrollView: UIScrollView!
	
	var productName = ""
	var productDetail:Product?
	
	var size = ["24 Lb Bag", "26 Lb Bag", "28 Lb Bag", "30 Lb Bag"]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print(productName)
		self.lbProductHeading.text = ""
		self.productScrollView.isHidden = true
		self.getProductDetail()
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
	
	func getProductDetail(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PProduct + self.productName
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCallDictionary(urlString: encodedUrl!, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				self.productScrollView.isHidden = false
//				self.productDetail = []
				
				self.productDetail = Product(dictionary: success)
				
				self.lbProductHeading.text = self.productDetail?.name
				self.lbTitle.text = self.productDetail?.name
				
				if self.productDetail!.price != nil {
					self.lbPrice.text = "AED " + String(format: "AED %.2f", self.productDetail!.price!)
				}
				
				
//				for dictionary in success{
//					let prod:Product = Product(dictionary: dictionary as! NSDictionary)
//					self.productDetail.append(prod)
//				}
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
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
