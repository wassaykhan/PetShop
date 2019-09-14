//
//  HomeViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 15/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SVProgressHUD


class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

	@IBOutlet weak var latestProdCollectionView: UICollectionView!
	@IBOutlet weak var categoryCollectionView: UICollectionView!
	
	@IBOutlet weak var slideshow: ImageSlideshow!
	@IBOutlet weak var viewSearch: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()
		
		slideshow.slideshowInterval = 5.0
		slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
		slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFill
		
		let pageControl = UIPageControl()
		pageControl.currentPageIndicatorTintColor = UIColor.lightGray
		pageControl.pageIndicatorTintColor = UIColor.black
		slideshow.pageIndicator = pageControl
		
		// optional way to show activity indicator during image load (skipping the line will show no activity indicator)
		slideshow.activityIndicator = DefaultActivityIndicator()
		
		slideshow.setImageInputs([ImageSource(image: UIImage(named: "petImg")!),
								  ImageSource(image: UIImage(named: "petImg1")!)])
		
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.didTap))
		slideshow.addGestureRecognizer(recognizer)
		
//		self.getToken()
		self.getSlider()
		
		// Do any additional setup after loading the view.
    }
	
	
	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
    
	@objc func didTap() {
		let fullScreenController = slideshow.presentFullScreenController(from: self)
		// set the activity indicator for full screen controller (skipping the line will show no activity indicator)
		fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.categoryCollectionView {
			return 6
		}
		return 7
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if collectionView == self.categoryCollectionView  {
			let cellCategory:ShopCategoryCollectionViewCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellIdentifier", for: indexPath) as! ShopCategoryCollectionViewCell
			return cellCategory
			//categoryCellIdentifier
		}
		
		let cellCategory:LatestProductCollectionViewCell = latestProdCollectionView.dequeueReusableCell(withReuseIdentifier: "latestProdCellIdentifier", for: indexPath) as! LatestProductCollectionViewCell
		return cellCategory
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 170, height: 195)
	}
	
	func getToken() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PToken
			
			let parameters:[String:String] = ["username":"tarun","password":"admin1234"]
			AlamofireCalls.postCall(urlString: urlString, parameters: parameters)
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func getSlider(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PSlider
			let parameters:[String:String] = [:]
			let headers:[String:String] = ["Authorization": "Bearer v8alp9psbs80f9ibthhy0idxx0dcpr18",
										   "Content-Type": "application/json"]
			AlamofireCalls.getCall(urlString: urlString, parameters: parameters, headers: headers, completion: {
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
	

}

extension UIView {
	@IBInspectable
	var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
		}
	}
	@IBInspectable var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	
	@IBInspectable var borderColor: UIColor? {
		get {
			return UIColor(cgColor: layer.borderColor!)
		}
		set {
			layer.borderColor = newValue?.cgColor
		}
	}
}

//extension ViewController: ImageSlid {
//	func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
//		print("current page:", page)
//	}
//}
