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
import Presentr
import BadgeSwift


class ProductViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,UIPickerViewDataSource,UITabBarControllerDelegate {

	@IBOutlet weak var sizePickerView: UIPickerView!
	@IBOutlet weak var lbSize: UILabel!
	@IBOutlet weak var lbProductHeading: UILabel!
	@IBOutlet weak var imgProduct: UIImageView!
	@IBOutlet weak var lbTitle: UILabel!
	@IBOutlet weak var lbPrice: UILabel!
	@IBOutlet weak var lbDiscription: UILabel!
	@IBOutlet weak var lbKeyBenefits: UILabel!
	@IBOutlet weak var productScrollView: UIScrollView!
	@IBOutlet weak var btnSize: UIButton!
	@IBOutlet weak var lbWeight: UILabel!
	@IBOutlet weak var imgSlider: ImageSlideshow!
	@IBOutlet weak var QuantityCollectionView: UICollectionView!
	@IBOutlet weak var categoryOne: UIButton!
	@IBOutlet weak var categoryTwo: UIButton!
	@IBOutlet weak var btnDetail: UIButton!
	@IBOutlet weak var viewCategoryTwo: UIView!
	@IBOutlet weak var viewDetail: UIView!
	@IBOutlet weak var viewCategoryOne: UIView!
	@IBOutlet weak var btnBrand: UIButton!
	@IBOutlet weak var lbBrandName: UILabel!
	@IBOutlet weak var btnWishList: UIButton!
	@IBOutlet weak var btnShare: UIButton!
	@IBOutlet weak var lbBy: UILabel!
	@IBOutlet weak var attributeView: UIView!
	@IBOutlet weak var attributeHeight: NSLayoutConstraint!
	@IBOutlet weak var lbCategory: UILabel!
	@IBOutlet weak var imgChart: UIImageView!
	@IBOutlet weak var categoryTwoCenterAlign: NSLayoutConstraint!
	@IBOutlet weak var categoryOneWidth: NSLayoutConstraint!
	@IBOutlet weak var categoryOneLeft: NSLayoutConstraint!
	@IBOutlet weak var lbBadgeCount: BadgeSwift!
	@IBOutlet weak var headerView: UIView!
	
	
	var brandProduct:Array<Product> = []
	var productName = ""
	var productDetail:Product?
	var productType = ""
	var wishlistSelected = 0
	var productAttributes:Array<Attributes> = []
	var productAttributesData:Array<ProductAttributes> = []
	var guestCart:Array<GuestCart> = []
//	var attributeData:Dictionary?
	var productUrl = ""
	var radioSelected = 0
	var ingredients = ""
	var sizeChart = ""
	var quantitySelected = 0
	//get all weights
	var weights:NSArray = []
	var attributeID = ""
	var finalWeight = ""
	//get manufacturer
	var manufacture = ""
	var select = ""
	//Attribute Height
	var attHeight = 70
	var cartArr:Array<Cart> = []
	var presenter:Presentr? = nil
	var imgUrl = ""
	var isFirstTime = true
	var attName = ""
	var tagAtt = 0
	var childSku = ""
	var optionLabel = ""
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
		let badgeCount = UserDefaults.standard.string(forKey: "badgeCount")
		if badgeCount != nil {
			self.lbBadgeCount.isHidden = false
			self.lbBadgeCount.text = badgeCount
		}else {
			self.lbBadgeCount.isHidden = true
		}
	}
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		self.navigationController?.popToRootViewController(animated: false)
	}
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		tabBarController?.delegate = self
		
		
		print("Check Tabbar active tab")
		print(productName)
		self.lbProductHeading.text = ""
		self.productScrollView.isHidden = true
		imgSlider.slideshowInterval = 5.0
		imgSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
		imgSlider.contentScaleMode = UIView.ContentMode.scaleAspectFit
		
		let pageControl = UIPageControl()
		pageControl.currentPageIndicatorTintColor = UIColor.lightGray
		pageControl.pageIndicatorTintColor = UIColor.black
		imgSlider.pageIndicator = pageControl
		imgSlider.activityIndicator = DefaultActivityIndicator()
		imgSlider.setImageInputs([ImageSource(image: UIImage(named: "imgDefault")!)])
		NotificationCenter.default.addObserver(self, selector: #selector(self.myFunction), name: NSNotification.Name(rawValue: "desiredEventHappend"), object: nil)
		self.getProductDetail()
        // Do any additional setup after loading the view.
    }
	
//	override func viewWillAppear(_ animated: Bool) {
//		super.viewWillAppear(true)
////		print("hoja plz")
//	}
	
	@objc func myFunction(notification: NSNotification) {
		//do anything
		print("one way")
		let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
		let item = userInfo["tag"]! as String
		let itemText = userInfo["label"]! as String
		let itemValue = userInfo["value"]! as String
		let itemPrice = userInfo["price"]! as String
		self.finalWeight = itemValue
		self.tagAtt = Int(item)!
		print("masla")
		print(itemText)
		self.lbPrice.text = "AED " + itemPrice
		self.optionLabel = itemText
		self.childSku = itemValue
		print(self.childSku)
//		self.mInstructionView = self.view.viewWithTag(1)
		for view in self.attributeView.subviews {
			if let label = view as? UILabel {
				if label.tag == 0 {
					label.text = itemText
				}
			}
		}
	}
	
	
	lazy var popupViewController: AttributeViewController = {
		let popupViewController = self.storyboard?.instantiateViewController(withIdentifier: "attributeID")
		return popupViewController as! AttributeViewController
	}()
	
	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
    
	@IBOutlet weak var categoryView: UIView!
	@IBOutlet weak var productCollectionView: UICollectionView!
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 12
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cellCategory:QuantityCollectionViewCell = QuantityCollectionView.dequeueReusableCell(withReuseIdentifier: "quantityCellIdentifier", for: indexPath) as! QuantityCollectionViewCell
		let int:Int = indexPath.row + 1
		cellCategory.btnQuantity.titleLabel?.text = String(int)
		cellCategory.lbQuantity.text = String(int)
		if quantitySelected == indexPath.row {
			cellCategory.btnQuantity.backgroundColor = UIColor(red: 241/255, green: 242/255, blue: 249/255, alpha: 1)
			cellCategory.borderWidth = 1
			cellCategory.borderColor = UIColor.white
			cellCategory.cornerRadius = 10
		}else {
			cellCategory.btnQuantity.backgroundColor = UIColor.white
			cellCategory.borderWidth = 1
			cellCategory.borderColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
			cellCategory.cornerRadius = 10
		}
		return cellCategory
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 62, height: 30)
	}
	
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print(indexPath.row)
		quantitySelected = indexPath.row
		QuantityCollectionView.reloadData()
		QuantityCollectionView.selectItem(at: NSIndexPath(item: indexPath.row, section: 0) as IndexPath, animated: true, scrollPosition: .centeredHorizontally)
	}
	

	@IBAction func btnBrandAction(_ sender: Any) {
		if self.manufacture != ""{
			let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "productListID") as! ProductListViewController
			//		nextViewController.productList = self.brandProduct
			nextViewController.isFromBrand = true
			nextViewController.productTitle = self.lbBrandName.text!
			nextViewController.valueFromBrand = self.manufacture
			self.navigationController?.pushViewController(nextViewController, animated: true)
//			self.getBrandProduct(value: self.manufacture, title: self.lbBrandName.text!)
		}
		
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		
		return self.productAttributes.count
		
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return self.productAttributes[row].label
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
		self.lbSize.text = self.productAttributes[row].label
		self.finalWeight = self.productAttributes[row].value!
		sizePickerView.isHidden = true
		
	}
	
	@IBAction func btnHighlightsAction(_ sender: Any) {
		self.categoryView.isHidden = true
		self.categoryOne.setTitleColor(UIColor(red: 82/255, green: 185/225, blue: 195/225, alpha: 1), for: .normal)
		self.categoryTwo.setTitleColor(UIColor(red: 82/255, green: 185/225, blue: 195/225, alpha: 1), for: .normal)
		self.btnDetail.setTitleColor(.white, for: .normal)
		self.viewDetail.isHidden = false
		self.productScrollView.isHidden = false
		self.viewCategoryOne.isHidden  = true
		self.viewCategoryTwo.isHidden  = true
	}
	@IBAction func btnIngredientAction(_ sender: Any) {
		self.categoryOne.setTitleColor(.white, for: .normal)
		self.btnDetail.setTitleColor(UIColor(red: 82/255, green: 185/225, blue: 195/225, alpha: 1), for: .normal)
		self.categoryTwo.setTitleColor(UIColor(red: 82/255, green: 185/225, blue: 195/225, alpha: 1), for: .normal)
		self.lbCategory.attributedText = NSAttributedString(html: self.ingredients)
		self.categoryView.isHidden = false
		self.lbCategory.isHidden = false
		self.productScrollView.isHidden = true
		self.viewCategoryOne.isHidden = false
		self.viewCategoryTwo.isHidden = true
		self.viewDetail.isHidden = true
		self.imgChart.isHidden = true
	}
	@IBAction func bnSizeChartAction(_ sender: Any) {
		self.categoryTwo.setTitleColor(.white, for: .normal)
		self.btnDetail.setTitleColor(UIColor(red: 82/255, green: 185/225, blue: 195/225, alpha: 1), for: .normal)
		self.categoryOne.setTitleColor(UIColor(red: 82/255, green: 185/225, blue: 195/225, alpha: 1), for: .normal)
		self.lbCategory.isHidden = true
		let urlImageString = PBaseSUrl + "pub/media/catalog/product" + self.sizeChart
		self.imgChart.sd_setImage(with: URL(string:urlImageString), placeholderImage: UIImage(named: ""))
		self.imgChart.isHidden = false
		self.categoryView.isHidden = false
		self.productScrollView.isHidden = true
		self.viewCategoryTwo.isHidden = false
		self.viewCategoryOne.isHidden = true
		self.viewDetail.isHidden = true
	}
	@IBAction func btnFeeding(_ sender: Any) {
		self.categoryView.isHidden = false
	}
	@IBAction func btnSelectSizeAction(_ sender: UIButton) {
		
		if isFirstTime{
//			let prodAttribute:ProductAttributes = self.productAttributesData[0]
//			self.weights = prodAttribute.weights!
//			self.select = prodAttribute.label!
//			self.getAttributes(attributeID: prodAttribute.value!,senderTag: 0, isfirstTime: isFirstTime)
			self.getProductConfig(senderTag: 0, isfirstTime: isFirstTime)
		}else{
//			let prodAttribute:ProductAttributes = self.productAttributesData[sender.tag]
//			self.weights = prodAttribute.weights!
//			self.select = prodAttribute.label!
//			self.getAttributes(attributeID: prodAttribute.value!,senderTag: sender.tag, isfirstTime: isFirstTime)
			self.getProductConfig(senderTag: sender.tag, isfirstTime: isFirstTime)
		}
		
		
//		if self.productAttributes.count > 0 {
//			if self.productAttributes[0].label != nil {
//				let viewController = popupViewController
//
//				viewController.weight = self.productAttributes[0].label!
//				viewController.price = String(self.productDetail!.price!)
//				viewController.attributeData = self.productAttributes
//				viewController.radioSelected = self.radioSelected
//
//				viewController.onRadioTapped = {
//					print("remove")
//				}
//
//				let navigationViewController = UINavigationController(rootViewController: viewController)
//				navigationViewController.setNavigationBarHidden(true, animated: true)
//
//				customPresentViewController(presenter!, viewController: navigationViewController, animated: true)
//			}
//
//		}
		
		
//		if self.productAttributes.count > 0 {
//			self.sizePickerView.reloadAllComponents()
//			sizePickerView.isHidden = false
//		}
		
	}
	
	@IBAction func btnAddToCartAction(_ sender: Any) {
		
		let customerToken = UserDefaults.standard.string(forKey: "customerToken")
		if customerToken == nil {
			_ = self.tabBarController?.selectedIndex = 3
			return
			let extensionAttributes:[String:AnyObject] = [:]
			
			var cartItems:[String:AnyObject] = [:]
			var guestCartItem:GuestCart?
			
			
			if productType == "configurable" {
				
				var dictionaries = [[String: AnyObject]]()
				let dictionary1: [String: AnyObject] = ["option_id": self.attributeID as AnyObject, "option_value": Int(self.finalWeight) as AnyObject ]
				dictionaries.append(dictionary1)
				
				let extAttribute:[String:AnyObject] = ["configurable_item_options":dictionaries as AnyObject]
				
				let productOption:[String:AnyObject] = ["extension_attributes": extAttribute as AnyObject]
				
				cartItems = ["sku":self.productDetail?.sku as AnyObject, "qty": (quantitySelected + 1) as AnyObject, "quote_id" : "" as AnyObject, "product_option" : productOption as AnyObject, "extension_attributes" : extensionAttributes as AnyObject]
				let param:[String:AnyObject] = [
					"cartItem" : cartItems as AnyObject
				]
				guestCartItem = GuestCart(itemArr: param, image: self.imgUrl, price: self.productDetail!.price!, name: (self.productDetail?.name)!, productType: "normal", option_id: self.attName, option_value: self.optionLabel, sku: (self.productDetail?.sku)!, qty: (quantitySelected + 1), quote_id: 0, type:"configurable")
			}else {
				
				
				cartItems = ["sku":self.productDetail?.sku as AnyObject, "qty":(quantitySelected + 1) as AnyObject, "quote_id" : "" as AnyObject, "extension_attributes" : extensionAttributes as AnyObject]
				
				let param:[String:AnyObject] = [
					"cartItem" : cartItems as AnyObject
				]
				
				guestCartItem = GuestCart(itemArr: param, image: self.imgUrl, price: self.productDetail!.price!, name: (self.productDetail?.name)!, productType: "normal", option_id: "", option_value: "", sku: (self.productDetail?.sku)!, qty: (quantitySelected + 1), quote_id: 0, type:"normal")
			}
			
			self.guestCart = []
			if isKeyPresentInUserDefaults(key: "items"){
				let decodedArray = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.object(forKey: "items") as! Data) as! [GuestCart]
				for items in decodedArray{
					//				let cart = Cart(guestData: items)
					self.guestCart.append(items)
				}
			}
			
			
			
			self.guestCart.append(guestCartItem!)
			
			
			
			
			let encodedData = NSKeyedArchiver.archivedData(withRootObject: self.guestCart)
			UserDefaults.standard.set(encodedData, forKey: "items")
			
			
			
		}else{
			self.getCartID()
		}
		
		
	}
	
	func getCartID() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PCartId
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			if customerToken == nil {
				return
			}
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.postCallAnyWithOnlyHeader(urlString: urlString, headers: headers, completion: {
				(token) -> Void in
				print("from Product View")
				print(token)
				self.setCartItem(quoteID: token)
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func setCartItem(quoteID:Int) {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show()
//			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PCart
			
			let extensionAttributes:[String:AnyObject] = [:]
			
			var cartItems:[String:AnyObject] = [:]
			
			if productType == "configurable" {
				
				cartItems = ["sku":self.childSku as AnyObject, "qty": (quantitySelected + 1) as AnyObject, "quote_id" : quoteID as AnyObject]
			}else {
				cartItems = ["sku":self.productDetail?.sku as AnyObject, "qty":(quantitySelected + 1) as AnyObject, "quote_id" : quoteID as AnyObject, "extension_attributes" : extensionAttributes as AnyObject]
			}
			
			let param:[String:AnyObject] = [
				"cartItem" : cartItems as AnyObject
			]
			
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			
			AlamofireCalls.postCallAnyWithHeaderDict(urlString: urlString, parameters: param, headers: headers, completion: {
				(token) -> Void in
				print("from Shipping")
				print(token)
				
//				self.getCartDetail()
				self.getCartProduct()
				let alert = UIAlertController(title: "Product Added to Cart", message: "Happy Shopping", preferredStyle: UIAlertController.Style.alert)
				let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
				alert.addAction(defaultAction)
				self.present(alert, animated: true, completion: nil)
	
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	func getCartDetail(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PCart
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCall(urlString: encodedUrl!, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				self.cartArr = []
				for dictionary in success{
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
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
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
	
	
	func getProductDetail(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PProduct + self.productName
//			let urlString =  PBaseUrl + PProduct + "Sku-123-XYZ"
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
				
				let media = success["media_gallery_entries"] as! NSArray
				var arrImgString:Array<String> = []
				if media.count > 0 {
					let image = media[0] as! NSDictionary
					let finalImage = image["file"] as! String
					var urlImageString = PBaseSUrl + "pub/media/catalog/product" + finalImage
//					self.imgProduct.sd_setImage(with: URL(string:urlImageString), placeholderImage: UIImage(named: ""))
					self.imgUrl = urlImageString
					for data in media {
						let imgDict = data as! NSDictionary
						urlImageString = PBaseSUrl + "pub/media/catalog/product" + (imgDict["file"] as! String)
						arrImgString.append(urlImageString)
					}
				}
				
				if arrImgString.count > 0 {
					var imageSource: [SDWebImageSource] = []
					for image in arrImgString {
						let img = image
						imageSource.append(SDWebImageSource(url: URL(string:img)!))
					}
					self.imgSlider.setImageInputs(imageSource)
					
				}
				
				
				if self.productDetail!.price != nil {
					self.lbPrice.text = String(format: "AED %.2f", self.productDetail!.price!)
				}
				
				
				self.productType = success["type_id"] as! String
				if self.productType == "configurable" {
					
					let button = UIButton()
					self.btnSelectSizeAction(button)
					/*
					let prodDict = success["extension_attributes"] as! NSDictionary
					let productOption = prodDict["configurable_product_options"] as! NSArray
					if productOption.count > 0 {
					
					for items in productOption {
					let itemDict = items as! NSDictionary
					//							if (itemDict["label"] as! String) == "Weight" {
					//							if (itemDict["label"] as! String) == "Size" {
					let label = itemDict["label"] as! String
					let value = itemDict["values"] as! NSArray
					//								self.weights = value
					self.attributeID = itemDict ["attribute_id"] as! String
					//								self.getAttributes(attributeID: self.attributeID)
					let productAtt = ProductAttributes(value: self.attributeID, label: label, weights: value)
					self.productAttributesData.append(productAtt)
					
					//							}
					//							}
					}
					}
					*/
				}else{
					//oye
					self.attributeHeight.constant = 0
				}
				
				let customAttributes = success["custom_attributes"] as! NSArray
				
				for itemCustomAttribute in customAttributes{
					let itemCustom = itemCustomAttribute as! NSDictionary
					let attributeCode = itemCustom["attribute_code"] as! String
					if attributeCode == "description"{
						self.lbDiscription.attributedText = NSAttributedString(html: itemCustom["value"] as! String)
					}
					if attributeCode == "short_description"{
//						self.lbKeyBenefits.attributedText = NSAttributedString(html: itemCustom["value"] as! String)
					}
					
					if attributeCode == "ingredients"{
						self.ingredients = itemCustom["value"] as! String
						if self.ingredients != "no_selection"{
							self.categoryOne.isHidden = false
						}
					}
					
					if attributeCode == "size_chart"{
						self.sizeChart = itemCustom["value"] as! String
						if self.sizeChart != "no_selection"{
							self.categoryTwo.isHidden = false
						}
					}
					
					
					if attributeCode == "manufacturer"{
						self.manufacture = itemCustom["value"] as! String
						self.getBrand()
					}
					if attributeCode == "url_key"{
						self.productUrl = "https://www.thepetstore.ae/" + (itemCustom["value"] as! String) + ".html"
					}
					
				}
				
				if self.categoryOne.isHidden {
//					NSLayoutConstraint.setMultiplier(0.85, of: &self.categoryTwoCenterAlign)
					self.headerView.translatesAutoresizingMaskIntoConstraints = false
					self.categoryOneWidth.constant = 0
					self.categoryOneLeft.constant = 0
					self.headerView.layoutIfNeeded()
				
				}
				
				
				let customerToken = UserDefaults.standard.string(forKey: "customerToken")
				if customerToken != nil {
					self.getWishList()
				}
				
				/*
				//Attributes exist
				if self.productAttributesData.count > 0 {
					for index in 0...self.productAttributesData.count-1{
						let prodAttribute:ProductAttributes = self.productAttributesData[index]
						self.createAttributeViews(tag: index, top:((index*70) + 30),att:prodAttribute)
//						self.getAttributes(attributeID: prodAttribute.value!)
					}
					let button = UIButton()
					self.btnSelectSizeAction(button)
					
					
				}
				*/

				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	func createAttributeViews(tag:Int,top:Int,att:ProductAttributes){
		self.attributeHeight.constant = self.attributeHeight.constant * CGFloat(tag + 1)
		let label = UILabel(frame: CGRect.init(x: 0, y: tag * 68, width: 300, height: 30))
		label.text = self.attName//att.label
		label.tag = 50
		label.font = UIFont(name: label.font.fontName, size: 12)
		label.textColor = .lightGray//UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
		let labelBtn = UILabel(frame: CGRect.init(x: 20, y: top, width: 300, height: 35))
		labelBtn.text = "Select " + self.attName//att.label!
		labelBtn.textColor = UIColor(red: 2/255, green: 166/255, blue: 178/255, alpha: 1)
		labelBtn.font = UIFont(name: label.font.fontName, size: 12)
		labelBtn.tag = tag
		let screenSize: CGRect = UIScreen.main.bounds
		let button: UIButton = UIButton(frame: CGRect(x: 0, y: top, width: Int(screenSize.width - 35), height: 35))
//		button.setTitleColor(UIColor.gray, for: .normal)
		button.backgroundColor = UIColor(red: 241/255, green: 242/255, blue: 249/255, alpha: 1)
//		button.setTitle("M", for: .normal)
		button.tag = tag
		button.addTarget(self, action: #selector(self.btnSelectSizeAction), for: .touchUpInside)
		button.layer.cornerRadius = 8
		let dropDown: UIImageView = UIImageView(frame: CGRect(x: Int(screenSize.width - 80), y: top+9, width: 20 , height: 15))
		dropDown.image = UIImage.init(named: "Arrow-down")
		dropDown.contentMode = .scaleAspectFit
		self.attributeView.addSubview(label)
		self.attributeView.addSubview(button)
		self.attributeView.addSubview(labelBtn)
		self.attributeView.addSubview(dropDown)
		
		self.attributeView.layoutIfNeeded()
	}
	
	
	
	func getBrand(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PAtoZ
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			AlamofireCalls.getCall(urlString: urlString, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				for dict in success {
					let dictionary = dict as! NSDictionary
					if ((dictionary["value"] as! String) == self.manufacture){
						self.lbBrandName.text = dictionary["label"] as? String
						self.lbBrandName.isHidden = false
						self.lbBy.isHidden = false
						self.btnBrand.isHidden = false
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
	
	func addWishList(){
		if wishlistSelected == 0 {
			if Reachability.isConnectedToInternet() {
				print("Yes! internet is available.")
				
				SVProgressHUD.show()
				let urlString =  PBaseUrl + PAddWishList
				let parameters:[String:String] = ["sku":productName]
				let customerToken = UserDefaults.standard.string(forKey: "customerToken")
				let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
											   "Content-Type": "application/json"]
				AlamofireCalls.postCallAnyWithHeaderDict(urlString: urlString,parameters: parameters as [String : AnyObject], headers: headers, completion: {
					(token) -> Void in
					print("WishList added")
					self.btnWishList.setImage(UIImage(named: "heartSelected"), for: .normal)
					self.wishlistSelected = 1
					print(token)
					//				self.setCartItem(quoteID: token)
				})
				
			}else{
				let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
				let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
				alert.addAction(defaultAction)
				self.present(alert, animated: true, completion: nil)
			}
		}
		
	}
	
	
	func getAttributes(attributeID:String,senderTag:Int,isfirstTime:Bool){
		var optionArray:NSArray = []
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PAttributes + attributeID
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let parameters:[String:String] = [:]
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			
			AlamofireCalls.getCallDictionary(urlString: encodedUrl!, parameters: parameters, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				optionArray = success["options"] as! NSArray
				self.productAttributes = []
				if self.weights.count != 0 {
					for items in self.weights {
						let itemDict = items as! NSDictionary
						for optionItems in optionArray{
							let optionDict = optionItems as! NSDictionary
							if String(itemDict["value_index"] as! Int) == optionDict["value"] as! String{
								//Model of option value and label
								let attributeModel = Attributes(dictionary: optionDict)
								self.productAttributes.append(attributeModel)
							}
						}
					}
					
					if self.productAttributes.count > 0 {
//						if self.productAttributes[0].label != nil {
//							self.lbSize.text = self.productAttributes[0].label
//						}
						self.presenter = nil
						let width = ModalSize.sideMargin(value: 20)
						let height = ModalSize.custom(size: Float(190 + self.attHeight * self.productAttributes.count))
						let center = ModalCenterPosition.center
						let customType = PresentationType.custom(width: width, height: height, center: center)
						self.presenter = Presentr(presentationType: customType)
//						self.presenter!.transitionType = nil//.coverHorizontalFromLeft
						self.presenter!.transitionType = nil
						
						let viewController = self.popupViewController
								
						viewController.weight = self.productAttributes[0].label!
						viewController.price = String(self.productDetail!.price!)
						viewController.attributeData = self.productAttributes
						viewController.tag = senderTag
						if self.isFirstTime{
							viewController.tag = senderTag + 1
						}
						viewController.tag = senderTag
						for view in self.attributeView.subviews {
							if let label = view as? UILabel {
								if label.tag == senderTag {
									viewController.selectedText = label.text!
								}
							}
						}
						viewController.select = self.select
						viewController.onRadioTapped = {
							print("remove")
						}
						
						if self.isFirstTime{
							
							
							
						}else{
							let navigationViewController = UINavigationController(rootViewController: viewController)
							navigationViewController.setNavigationBarHidden(true, animated: true)
							
							self.customPresentViewController(self.presenter!, viewController: navigationViewController, animated: true)
						}
//						let nc = NotificationCenter.default
//						nc.post(name: NSNotification.Name(rawValue: "desiredEventHappend"), object: nil, userInfo: ["tag":String(senderTag),"label":self.productAttributes[0].label!,"value":self.productAttributes[senderTag].value!],"price":self.productAttributes[senderTag].value)
						self.isFirstTime = false
						
						
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
	
	
	
	func getProductConfig(senderTag:Int,isfirstTime:Bool){
//		var optionArray:NSArray = []
		self.productAttributesData = []
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PProductConfigValue
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let adminToken = UserDefaults.standard.string(forKey: "adminToken")
			let headers:[String:String] = ["Authorization": "Bearer " + adminToken!,
										   "Content-Type": "application/json"]
			
			let auth:[String:AnyObject] = ["token":adminToken as AnyObject, "sku":self.productName as AnyObject]
			
			let param:[String:AnyObject] = [
				"sku" : auth as AnyObject
			]
			
			
			AlamofireCalls.postCallAnyWithHeaderDict(urlString: encodedUrl!, parameters: param, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				
				let productDetail = success["product_detail"] as! NSDictionary
				
				if let name = productDetail["attName"] {
					self.attName = name as! String
				}
				
				if let config = productDetail["configurable_product_options"] as? NSArray{
					
					for item in config{
						let dict = item as! NSDictionary
						let sku = dict["child_sku"] as! String
						let price = dict["price"] as! Float
						let att = dict["attributes"] as? NSArray
						let weightD = att![0] as! NSDictionary
						let weight = weightD["weight_custom"] as! String
						let p = ProductAttributes(sku: sku, weight: weight, price: price)
						self.productAttributesData.append(p)
						
					}
					
					if self.isFirstTime{
						let prodAttribute:ProductAttributes = self.productAttributesData[0]
						self.createAttributeViews(tag: 0, top:30,att:prodAttribute)
					}
					
					
					/*
					//Attributes exist
					if self.productAttributesData.count > 0 {
						for index in 0...self.productAttributesData.count-1{
							let prodAttribute:ProductAttributes = self.productAttributesData[index]
							self.createAttributeViews(tag: index, top:((index*70) + 30),att:prodAttribute)
							//						self.getAttributes(attributeID: prodAttribute.value!)
						}
//						let button = UIButton()
//						self.btnSelectSizeAction(button)
						
						
					}*/
					
					if self.productAttributesData.count > 0 {
						self.presenter = nil
						let width = ModalSize.sideMargin(value: 20)
						let height = ModalSize.custom(size: Float(190 + self.attHeight * self.productAttributesData.count))
						let center = ModalCenterPosition.center
						let customType = PresentationType.custom(width: width, height: height, center: center)
						self.presenter = Presentr(presentationType: customType)
						//						self.presenter!.transitionType = nil//.coverHorizontalFromLeft
						self.presenter!.transitionType = nil
						
						let viewController = self.popupViewController
						
//						viewController.weight = self.productAttributesData[0].weight_custom!
//						viewController.price = String(self.productAttributesData!.price!)
						viewController.attributeCustomData = self.productAttributesData
						viewController.tag = senderTag
						if self.isFirstTime{
							viewController.tag = senderTag + 1
						}
						viewController.tag = senderTag
						for view in self.attributeView.subviews {
							if let label = view as? UILabel {
								if label.tag == senderTag {
//									viewController.selectedText = label.text!
									viewController.selectedText = self.productAttributesData[self.tagAtt].weight_custom!
								}
							}
						}
						viewController.select = self.attName
						viewController.onRadioTapped = {
							print("remove")
						}
						
						if self.isFirstTime{
							
							let nc = NotificationCenter.default
							nc.post(name: NSNotification.Name(rawValue: "desiredEventHappend"), object: nil, userInfo: ["tag":String(senderTag),"label":self.productAttributesData[0].weight_custom!,"value":self.productAttributesData[senderTag].child_sku!,"price":String(self.productAttributesData[0].price!)])
							
						}else{
							let navigationViewController = UINavigationController(rootViewController: viewController)
							navigationViewController.setNavigationBarHidden(true, animated: true)
							
							self.customPresentViewController(self.presenter!, viewController: navigationViewController, animated: true)
						}
						
						self.isFirstTime = false
					}
					
					
					
//					let p = ProductAttributes(sku: <#T##String#>, weight: <#T##String#>, price: <#T##Float#>)
				}
				
				
				
				
				
				
				/*
				optionArray = success["options"] as! NSArray
				self.productAttributes = []
				if self.weights.count != 0 {
					for items in self.weights {
						let itemDict = items as! NSDictionary
						for optionItems in optionArray{
							let optionDict = optionItems as! NSDictionary
							if String(itemDict["value_index"] as! Int) == optionDict["value"] as! String{
								//Model of option value and label
								let attributeModel = Attributes(dictionary: optionDict)
								self.productAttributes.append(attributeModel)
							}
						}
					}
					
					if self.productAttributes.count > 0 {
						//						if self.productAttributes[0].label != nil {
						//							self.lbSize.text = self.productAttributes[0].label
						//						}
						self.presenter = nil
						let width = ModalSize.sideMargin(value: 20)
						let height = ModalSize.custom(size: Float(190 + self.attHeight * self.productAttributes.count))
						let center = ModalCenterPosition.center
						let customType = PresentationType.custom(width: width, height: height, center: center)
						self.presenter = Presentr(presentationType: customType)
						//						self.presenter!.transitionType = nil//.coverHorizontalFromLeft
						self.presenter!.transitionType = nil
						
						let viewController = self.popupViewController
						
						viewController.weight = self.productAttributes[0].label!
						viewController.price = String(self.productDetail!.price!)
						viewController.attributeData = self.productAttributes
						viewController.tag = senderTag
						if self.isFirstTime{
							viewController.tag = senderTag + 1
						}
						viewController.tag = senderTag
						for view in self.attributeView.subviews {
							if let label = view as? UILabel {
								if label.tag == senderTag {
									viewController.selectedText = label.text!
								}
							}
						}
						viewController.select = self.select
						viewController.onRadioTapped = {
							print("remove")
						}
						
						if self.isFirstTime{
							
							
							
						}else{
							let navigationViewController = UINavigationController(rootViewController: viewController)
							navigationViewController.setNavigationBarHidden(true, animated: true)
							
							self.customPresentViewController(self.presenter!, viewController: navigationViewController, animated: true)
						}
						let nc = NotificationCenter.default
						nc.post(name: NSNotification.Name(rawValue: "desiredEventHappend"), object: nil, userInfo: ["tag":String(senderTag),"label":self.productAttributes[0].label!,"value":self.productAttributes[senderTag].value!])
						self.isFirstTime = false
						
						
					}
				}
				*/
			})
			
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	func getWishList(){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			
			SVProgressHUD.show()
			let urlString =  PBaseUrl + PCheckWishlist
			let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
			let headers:[String:String] = ["Authorization": "Bearer " + customerToken!,
										   "Content-Type": "application/json"]
			
			let auth:[String:AnyObject] = ["cus_token":customerToken as AnyObject, "sku":self.productName as AnyObject]
			
			let param:[String:AnyObject] = [
				"data" : auth as AnyObject
			]
			
			
			AlamofireCalls.postCallAnyWithHeaderDict(urlString: encodedUrl!, parameters: param, headers: headers, completion: {
				(success) -> Void in
				
				print(success)
				if let checkWishlist = success["data"] as? Bool{
					if checkWishlist {
						self.btnWishList.setImage(UIImage(named: "heartSelected"), for: .normal)
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
	
	func getBrandProduct(value:String, title:String){
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show()
			self.brandProduct = []
			let urlString =  PBaseUrl + "products?searchCriteria[filterGroups][0][filters][0][field]=manufacturer& searchCriteria[filterGroups][0][filters][0][value]=" + value + "& searchCriteria[sortOrders][0][direction]=DESC& searchCriteria[pageSize]=10& searchCriteria[currentPage]=1&searchCriteria[filterGroups][1][filters][0][field]=status&searchCriteria[filterGroups][2][filters][0][field]=visibility& searchCriteria[filterGroups][2][filters][0][value]=1& searchCriteria[filterGroups][1][filters][0][value]=1& searchCriteria[filterGroups][2][filters][0][condition_type]=neq"
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
					let prod:Product = Product(dictionary: dictionary as! NSDictionary)
					if prod.name == "" {}
					self.brandProduct.append(prod)
				}
				
				let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "productListID") as! ProductListViewController
				nextViewController.productList = self.brandProduct
				nextViewController.isFromBrand = true
				nextViewController.productTitle = title
				self.navigationController?.pushViewController(nextViewController, animated: true)
				
				//				self.brandTableView.reloadData()
				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	@IBAction func btnWishListAction(_ sender: Any) {
		let customerToken = UserDefaults.standard.string(forKey: "customerToken")
		if customerToken != nil {
			self.addWishList()
		}else{
			_ = self.tabBarController?.selectedIndex = 3
		}
		
	}
	@IBAction func btnShareAction(_ sender: Any) {
		//Set the default sharing message.
		let message = "The Pet Store"
		//Set the link to share.
		if let link = NSURL(string: self.productUrl)
		{
			let objectsToShare = [message,link] as [Any]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
			activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
			self.present(activityVC, animated: true, completion: nil)
		}
	}
	
	

}

extension NSAttributedString {
	convenience init?(html: String) {
		guard let data = html.data(using: String.Encoding.unicode, allowLossyConversion: false) else {
			return nil
		}
		guard let attributedString = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
			return nil
		}
		self.init(attributedString: attributedString)
	}
}


extension NSLayoutConstraint {
	
	static func setMultiplier(_ multiplier: CGFloat, of constraint: inout NSLayoutConstraint) {
		NSLayoutConstraint.deactivate([constraint])
		
		let newConstraint = NSLayoutConstraint(item: constraint.firstItem, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: multiplier, constant: constraint.constant)
		
		newConstraint.priority = constraint.priority
		newConstraint.shouldBeArchived = constraint.shouldBeArchived
		newConstraint.identifier = constraint.identifier
		
		NSLayoutConstraint.activate([newConstraint])
		constraint = newConstraint
	}
	
}
