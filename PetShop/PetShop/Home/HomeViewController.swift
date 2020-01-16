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
import ScalingCarousel
import BadgeSwift

class Cell: ScalingCarouselCell {}

class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITabBarControllerDelegate,UIScrollViewDelegate {

	@IBOutlet weak var latestProdCollectionView: UICollectionView!
	@IBOutlet weak var categoryCollectionView: UICollectionView!
	@IBOutlet weak var txtSearch: UITextField!
	@IBOutlet weak var crousel: ScalingCarouselView!
	
	@IBOutlet weak var slideshow: ImageSlideshow!
	@IBOutlet weak var viewSearch: UIView!
	
	@IBOutlet weak var tableViewHeight: NSLayoutConstraint!
	@IBOutlet weak var viewAccount: UIView!
	@IBOutlet weak var lbBadgeCount: BadgeSwift!
	
	
	var sliderArr:Array<Slider> = []
	var petCategories:Array<PetCategories> = []
	var latestProduct:Array<LatestProduct> = []
	var cartArr:Array<Cart> = []
	
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
		self.lbBadgeCount.isHidden = true
		self.getToken()
		let customerToken = UserDefaults.standard.string(forKey: "customerToken")
		if customerToken != nil {
			self.viewAccount.isHidden = true
		}else{
			self.viewAccount.isHidden = false
		}
		
//		self.getCartProduct()
//		let badgeCount = UserDefaults.standard.string(forKey: "badgeCount")
//		if badgeCount != nil {
//			self.lbBadgeCount.isHidden = false
//			self.lbBadgeCount.text = badgeCount
//		}else {
//			self.lbBadgeCount.isHidden = true
//		}
		
	}
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		self.viewAccount.fadeOut()
	}
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		self.viewAccount.fadeIn()
	}
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		print("Selected view controller")
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			if customerToken != nil {
			self.viewAccount.isHidden = true
//			self.getCartDetail()
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
//		self.lbBadgeCount.text = "5"
//		self.lbBadgeCount.isHidden = true
		self.tabBarController?.delegate = self
//		navigationController?.navigationBar.barStyle = .black
		if UIScreen.main.nativeBounds.height == 2688 {
			self.tableViewHeight.constant = self.tableViewHeight.constant + 60
		}
		
		crousel.translatesAutoresizingMaskIntoConstraints = false
		crousel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
		crousel.heightAnchor.constraint(equalToConstant: 300).isActive = true
		crousel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		
		
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
		slideshow.setImageInputs([ImageSource(image: UIImage(named: "imgDefault")!)])
		let tapOnScreen: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
		tapOnScreen.cancelsTouchesInView = false
		view.addGestureRecognizer(tapOnScreen)
		
//		view.addGestureRecognizer(tap)
		
		
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
		return self.sliderArr.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if collectionView == self.categoryCollectionView  {
			let cellCategory:ShopCategoryCollectionViewCell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCellIdentifier", for: indexPath) as! ShopCategoryCollectionViewCell
			cellCategory.imgProd.sd_setImage(with: URL(string:self.petCategories[indexPath.row].image!), placeholderImage: UIImage(named: "imgDefault"))
			return cellCategory
			//categoryCellIdentifier
		}
		
		let cellCategory = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
		cellCategory.setNeedsLayout()
		cellCategory.layoutIfNeeded()
		let imageView = UIImageView()
		//		cellCategory.mainView.frame.width = self.crousel.bounds.width - 93
		imageView.sd_setImage(with: URL(string:self.sliderArr[indexPath.row].link!), placeholderImage: UIImage(named: "imgDefaultBanner"))
		imageView.frame = CGRect(x: 0, y: 0, width: self.crousel.bounds.width - 80, height: 180)
		cellCategory.mainView.addSubview(imageView)
		cellCategory.mainView.clipsToBounds = true
		//		if let scalingCell = cellCategory as? ScalingCarouselCell {
		////			scalingCell.mainView.backgroundColor = .red
		//		}
		return cellCategory
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		if collectionView == self.categoryCollectionView  {
			return 10
		}
		return -15
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		if collectionView == self.categoryCollectionView  {
			return 10
		}
		return 0
	}
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		if collectionView == self.categoryCollectionView  {
			//iphone X XS
			if UIScreen.main.nativeBounds.height == 2436 {
				return CGSize(width: UIScreen.main.bounds.width/2 - 17, height: UIScreen.main.bounds.height/4 - 33)
			}//2688 iphone XS_Max
			if UIScreen.main.nativeBounds.height == 2688 {
				return CGSize(width: UIScreen.main.bounds.width/2 - 17, height: UIScreen.main.bounds.height/4 - 33)
			}//1792 iphone XR
			if UIScreen.main.nativeBounds.height == 1792 {
				return CGSize(width: UIScreen.main.bounds.width/2 - 17, height: UIScreen.main.bounds.height/4 - 33)
			}
			return CGSize(width: UIScreen.main.bounds.width/2 - 17, height: 170)
		}else{
			return CGSize(width: self.crousel.bounds.width - 80, height: 180)
		}
		
	}
	
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//		if collectionView == self.categoryCollectionView  {
//			return CGSize(width: 170, height: 170)
//		}else {
//			return CGSize(width: self.crousel.bounds.width - 80, height: 180)
//		}
//
//	}
	
	
	//admin token
	func getToken() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PToken
			
			let parameters:[String:String] = ["username":"rest","password":"Admin123456!"]
			AlamofireCalls.postCall(urlString: urlString, parameters: parameters, completion: {
				(token,statusCode) -> Void in
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
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PCustomerToken
			let parameters:[String:String] = ["username":userName,"password":password]
			AlamofireCalls.postCall(urlString: urlString, parameters: parameters, completion: {
				(token,statusCode) -> Void in
				print("Main")
				print(token)
				if token != "" {
					UserDefaults.standard.set(token, forKey: "customerToken")
					self.getCartProduct()

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
			SVProgressHUD.show()
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
				self.crousel.reloadData()
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
			
			SVProgressHUD.show()
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
				let customerToken = UserDefaults.standard.string(forKey: "customerToken")
				if customerToken != nil {
//					self.getCartDetail()
				}
				
				

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
			
			SVProgressHUD.show()
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

	
	@IBAction func btnSignInAction(_ sender: Any) {
		UserDefaults.standard.set("yes", forKey: "signIn")
		_ = self.tabBarController?.selectedIndex = 3
		
		
		
	}
	
	
	
	@IBAction func btnCreateAccountAction(_ sender: Any) {
		UserDefaults.standard.set("yes", forKey: "createAccount")
		_ = self.tabBarController?.selectedIndex = 3
		
	}
	/*
	func getCartProduct() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			//			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PGetCartProducts
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			
			let cartItems:[String:AnyObject] = ["cus_token":customerToken as AnyObject, "admin_token":adminToken as AnyObject]
			
			let param:[String:AnyObject] = [
				"data" : cartItems as AnyObject
			]
			
			//			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			
			AlamofireCalls.postCallAnyWithHeaderDict(urlString: urlString, parameters: param, headers: headers, completion: {
				(token) -> Void in
				print("from Shipping")
				print(token)
				
				let arrProductDetail = token["product_detail"] as! NSArray
				
				if arrProductDetail.count > 0 {
					self.cartArr = []
					for dictionary in arrProductDetail{
						let prod:Cart = Cart(dictionary: dictionary as! NSDictionary)
						self.cartArr.append(prod)
					}
					if self.cartArr.count > 0 {
						UserDefaults.standard.set(String(self.cartArr.count), forKey: "badgeCount")
						self.lbBadgeCount.text = String(self.cartArr.count)
						self.lbBadgeCount.isHidden = false
					}else {
						UserDefaults.standard.removeObject(forKey: "badgeCount")
						self.lbBadgeCount.isHidden = true
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
	*/
	func getCartProduct() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PGetCuont
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			
			
			let param:[String:AnyObject] = [
				"customer_token" : customerToken as AnyObject
			]
			let headers:[String:String] = [
										   "Content-Type": "application/json"]
			
			AlamofireCalls.postCallAnyWithHeaderDict(urlString: urlString, parameters: param, headers: headers, completion: {
				(token) -> Void in
				print("from Count")
				print(token)
				
				var count = 0
				
				count = token["count"] as! Int
				
				if count > 0 {
					UserDefaults.standard.set(String(count), forKey: "badgeCount")
					self.lbBadgeCount.text = String(count)
					self.lbBadgeCount.isHidden = false
				}else {
					UserDefaults.standard.removeObject(forKey: "badgeCount")
					self.lbBadgeCount.isHidden = true
				}
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
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
		
		if (segue.identifier == "BrandID"){
			let vc = segue.destination as! BrandViewController
			vc.brandID = 2
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



extension UIViewController{
	func setStatusBarColor() {
		let statusBarBGView = UIView(frame: UIApplication.shared.statusBarFrame)
		statusBarBGView.backgroundColor = UIColor(red: 2/255, green: 166/255, blue: 178/255, alpha: 1)
		view.addSubview(statusBarBGView)
		navigationController?.navigationBar.barStyle = .black
		navigationController?.navigationBar.tintColor = .red
	}
}

public extension UIView {
	/// Fade in a view with a duration
	///
	/// Parameter duration: custom animation duration
	func fadeIn(withDuration duration: TimeInterval = 1.0) {
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 1.0
		})
	}
	
	/// Fade out a view with a duration
	///
	/// - Parameter duration: custom animation duration
	func fadeOut(withDuration duration: TimeInterval = 1.0) {
		UIView.animate(withDuration: duration, animations: {
			self.alpha = 0.0
		})
	}
}
