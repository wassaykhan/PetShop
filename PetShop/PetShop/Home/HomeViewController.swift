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
import SDWebImage

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

	@IBOutlet weak var latestProdCollectionView: UICollectionView!
	@IBOutlet weak var categoryCollectionView: UICollectionView!
	@IBOutlet weak var txtSearch: UITextField!
	
	@IBOutlet weak var slideshow: ImageSlideshow!
	@IBOutlet weak var viewSearch: UIView!
	
	var sliderArr:Array<Slider> = []
	var petCategories:Array<PetCategories> = []
	var latestProduct:Array<LatestProduct> = []
	
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
//		let ea = [SDWebImageSource(url: URL(string: "http://mutfakustam.com/resimler/tarifler/et-tavuk-yemekleri/biberli-et-kavurmasi-136-1.jpg")!)]
		slideshow.setImageInputs([ImageSource(image: UIImage(named: "imgDefault")!)])//,
//								  ImageSource(image: UIImage(named: "petImg")!)])
		
		
//		let recognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.didTap))
//		slideshow.addGestureRecognizer(recognizer)
		
		//Looks for single or multiple taps.
//		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
		
		//Uncomment the line below if you want the tap not not interfere and cancel other interactions.
		//tap.cancelsTouchesInView = false
		
		let tapOnScreen: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
		tapOnScreen.cancelsTouchesInView = false
		view.addGestureRecognizer(tapOnScreen)
		
//		view.addGestureRecognizer(tap)
		
		self.getToken()
//		self.getSlider()
//		self.getCategory()
		
		// Do any additional setup after loading the view.
    }
	
	@objc func dismissKeyboard() {
		//Causes the view (or one of its embedded text fields) to resign the first responder status.
		view.endEditing(true)
	}
	
	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == self.categoryCollectionView {
			return self.petCategories.count
		}
		return self.latestProduct.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if collectionView == self.categoryCollectionView  {
			let cellCategory:ShopCategoryCollectionViewCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellIdentifier", for: indexPath) as! ShopCategoryCollectionViewCell
			cellCategory.imgProd.sd_setImage(with: URL(string:self.petCategories[indexPath.row].image!), placeholderImage: UIImage(named: ""))
			return cellCategory
			//categoryCellIdentifier
		}
		
		let cellCategory:LatestProductCollectionViewCell = latestProdCollectionView.dequeueReusableCell(withReuseIdentifier: "latestProdCellIdentifier", for: indexPath) as! LatestProductCollectionViewCell
//		let imageUrl =
		cellCategory.imgProd.sd_setImage(with: URL(string: PBaseSUrl + "/pub/media/catalog/product" + self.latestProduct[indexPath.row].file!), placeholderImage: UIImage(named: ""))
		cellCategory.lbProdName.text = self.latestProduct[indexPath.row].name
		cellCategory.lbProdPrice.text = String(format: "AED %.2f", self.latestProduct[indexPath.row].price!)
		return cellCategory
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 170, height: 170)
	}
	
	
	//admin token
	func getToken() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PToken
			
			let parameters:[String:String] = ["username":"tarun","password":"admin1234"]
			AlamofireCalls.postCall(urlString: urlString, parameters: parameters, completion: {
				(token) -> Void in
				print("from Login")
				print(token)
				if token != "" {
					UserDefaults.standard.set(token, forKey: "adminToken")
					let customerToken = UserDefaults.standard.string(forKey: "customerToken")
					if customerToken != nil {
						let email = UserDefaults.standard.string(forKey: "emailAddress")
						let password = UserDefaults.standard.string(forKey: "password")
						self.getCustomerToken(userName: email!, password: password!)
					}else {
						self.getSlider()
					}
					
				}
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func getCustomerToken(userName:String,password:String) {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PCustomerToken
			let parameters:[String:String] = ["username":userName,"password":password]
			AlamofireCalls.postCall(urlString: urlString, parameters: parameters, completion: {
				(token) -> Void in
				print("Main")
				print(token)
				if token != "" {
					UserDefaults.standard.set(token, forKey: "customerToken")
				}
				self.getSlider()
			})
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
			self.sliderArr = []
			let urlString =  PBaseUrl + PSlider
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCall(urlString: urlString, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
//				print(success)
				for dictionary in success{
					let slider:Slider = Slider(dictionary: dictionary as! NSDictionary)
					self.sliderArr.append(slider)
				}
				
				var imageSource: [SDWebImageSource] = []
				for image in self.sliderArr {
					let img = image.link
					imageSource.append(SDWebImageSource(url: URL(string:img!)!))
				}
				self.slideshow.setImageInputs(imageSource)
				
//				self.slideshow.setImageInputs([SDWebImageSource(url: URL(string:self.sliderArr[0].link!)!),SDWebImageSource(url: URL(string:self.sliderArr[1].link!)!),SDWebImageSource(url: URL(string:self.sliderArr[2].link!)!)])
//				self.slideshow.ap
				self.getCategory()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func getCategory(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PCategories + "693"
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCall(urlString: urlString, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				self.petCategories = []
				for dictionary in success{
					
					let JSON = dictionary as! NSDictionary
					if JSON["children"] != nil {
						let arr = JSON["children"] as! NSArray
						for dictChild in arr{
							let categoryData:PetCategories = PetCategories(dictionary: dictChild as! NSDictionary)
							self.petCategories.append(categoryData)
						}
					}
					
				}
				self.categoryCollectionView.reloadData()
				self.getLatestProduct()

			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func getLatestProduct(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show(withStatus: "Loading Request")
			self.latestProduct = []
			let urlString =  PBaseUrl + "products?searchCriteria[filterGroups][0][filters][0][field]=category_id& searchCriteria[filterGroups][0][filters][0][value]=709& searchCriteria[sortOrders][0][direction]=DESC& searchCriteria[pageSize]=10& searchCriteria[currentPage]=1"
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCallDictionary(urlString: encodedUrl!	, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
//				print(success)
				let items = success["items"] as! NSArray
				for dictionary in items{
					let latestProd:LatestProduct = LatestProduct(dictionary: dictionary as! NSDictionary)
					self.latestProduct.append(latestProd)
				}
				self.latestProdCollectionView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		self.performSegue(withIdentifier: "categoryOneID", sender: indexPath)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if (segue.identifier == "categoryOneID") {
			let vc = segue.destination as! ShopCategoryOneViewController
			let indexPaths = self.categoryCollectionView.indexPathsForSelectedItems
			let indexPath = indexPaths![0] as NSIndexPath
			vc.categoryID = self.petCategories[indexPath.row].id!
			
			//			vc.params = self.params
		}
		if (segue.identifier == "latestProdID") {
			let vc = segue.destination as! ProductViewController
			let indexPaths = self.latestProdCollectionView.indexPathsForSelectedItems
			let indexPath = indexPaths![0] as NSIndexPath
			vc.productName = self.latestProduct[indexPath.row].sku!
			
			//			vc.params = self.params
		}
		if (segue.identifier == "searchID") {
			let vc = segue.destination as! SearchProductViewController
			vc.searchText = self.txtSearch.text ?? ""
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
