//
//  ShopCategoryTwoViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 19/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class ShopCategoryTwoViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

	@IBOutlet weak var shopCategoryCollectionView: UICollectionView!
	override func viewDidLoad() {
		super.viewDidLoad()
//		self.shopCategoryCollectionView.delegate = self
//		self.shopCategoryCollectionView.dataSource = self
		// Do any additional setup after loading the view.
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 6
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellCategory:ShopCategoryCollectionViewCell = shopCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellIdentifier", for: indexPath) as! ShopCategoryCollectionViewCell
		if indexPath.row == 0 {
			cellCategory.lbProd.text = "Healthcare"
			cellCategory.imgProd.image = UIImage(named: "vitamins-supplyment")
		}else if indexPath.row == 1 {
			cellCategory.lbProd.text = "Dental Care"
			cellCategory.imgProd.image = UIImage(named: "dental-care")
		}else if indexPath.row == 2 {
			cellCategory.lbProd.text = "Vitamins and Supplements"
			cellCategory.imgProd.image = UIImage(named: "vitamins-and-supplyments")
		}else if indexPath.row == 3 {
			cellCategory.lbProd.text = "Cleaning Potty"
			cellCategory.imgProd.image = UIImage(named: "clean-potty")
		}else if indexPath.row == 4 {
			cellCategory.lbProd.text = "Vitamins and Supplements"
			cellCategory.imgProd.image = UIImage(named: "vitamins-supplyment")
		}else if indexPath.row == 5 {
			cellCategory.lbProd.text = "Cleaning Potty"
			cellCategory.imgProd.image = UIImage(named: "clean-potty")
		}
		return cellCategory
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		//iphone X XS
		if UIScreen.main.nativeBounds.height == 2436 {
			return CGSize(width: UIScreen.main.bounds.width/2 - 20, height: UIScreen.main.bounds.height/4 - 40)
		}//2688 iphone XS_Max
		if UIScreen.main.nativeBounds.height == 2688 {
			return CGSize(width: UIScreen.main.bounds.width/2 - 20, height: UIScreen.main.bounds.height/4 - 40)
		}//1792 iphone XR
		if UIScreen.main.nativeBounds.height == 1792 {
			return CGSize(width: UIScreen.main.bounds.width/2 - 20, height: UIScreen.main.bounds.height/4 - 40)
		}
		return CGSize(width: UIScreen.main.bounds.width/2 - 20, height: UIScreen.main.bounds.height/3 - 40)
	}
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/

}
