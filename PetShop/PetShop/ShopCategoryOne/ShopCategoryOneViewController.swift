//
//  ShopCategoryOneViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 19/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class ShopCategoryOneViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

	@IBOutlet weak var shopCategoryCollectionView: UICollectionView!
	override func viewDidLoad() {
        super.viewDidLoad()
		self.shopCategoryCollectionView.delegate = self
		self.shopCategoryCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if indexPath.row == 0 {
			let cellCategory:ShopCategoryCollectionViewCell = shopCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryLongCellIdentifier", for: indexPath) as! ShopCategoryCollectionViewCell
			return cellCategory
		}
		
		
		if indexPath.row == 1 {
			let cellCategory:ShopCategoryCollectionViewCell = shopCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryAZCellIdentifier", for: indexPath) as! ShopCategoryCollectionViewCell
			return cellCategory
		}
		
		let cellCategory:ShopCategoryCollectionViewCell = shopCategoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellIdentifier", for: indexPath) as! ShopCategoryCollectionViewCell
		if indexPath.row == 2 {
			cellCategory.lbProd.text = "Food"
			cellCategory.imgProd.image = UIImage(named: "food")
		}else if indexPath.row == 3 {
			cellCategory.lbProd.text = "Treats"
			cellCategory.imgProd.image = UIImage(named: "treats")
		}else if indexPath.row == 4 {
			cellCategory.lbProd.text = "Toys"
			cellCategory.imgProd.image = UIImage(named: "toys")
		}
		return cellCategory
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		if indexPath.row == 0 {
			return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4 - 40)
		}
		
		//iphone X XS
		if UIScreen.main.nativeBounds.height == 2436 {
			return CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/4 - 40)
		}//2688 iphone XS_Max
		if UIScreen.main.nativeBounds.height == 2688 {
			return CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/4 - 40)
		}//1792 iphone XR
		if UIScreen.main.nativeBounds.height == 1792 {
			return CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/4 - 40)
		}
		return CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/3 - 40)
	}
	
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		if indexPath.row == 0 {
//			
//		}
//	}
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
