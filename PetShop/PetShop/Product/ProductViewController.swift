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
	@IBOutlet weak var btnSize: UIButton!
	@IBOutlet weak var lbWeight: UILabel!
	@IBOutlet weak var imgSlider: ImageSlideshow!
	
	var productName = ""
	var productDetail:Product?
	var productType = ""
	
	var productAttributes:Array<Attributes> = []
	
	//get all weights
	var weights:NSArray = []
	var attributeID = ""
	var finalWeight = ""
	
	
//	var size = ["24 Lb Bag"]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		print("Check Tabbar active tab")
		print(productName)
		self.lbProductHeading.text = ""
		self.productScrollView.isHidden = true
		imgSlider.slideshowInterval = 5.0
//		imgSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
		imgSlider.contentScaleMode = UIView.ContentMode.scaleAspectFit
		
		let pageControl = UIPageControl()
		pageControl.currentPageIndicatorTintColor = UIColor.lightGray
		pageControl.pageIndicatorTintColor = UIColor.black
//		slideshow.pageIndicator = pageControl
		imgSlider.activityIndicator = DefaultActivityIndicator()
		imgSlider.setImageInputs([ImageSource(image: UIImage(named: "imgDefault")!)])
		
		self.getProductDetail()
        // Do any additional setup after loading the view.
    }
	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
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
	}
	@IBAction func btnIngredientAction(_ sender: Any) {
		self.categoryView.isHidden = false
	}
	@IBAction func bnSizeChartAction(_ sender: Any) {
		self.categoryView.isHidden = false
	}
	@IBAction func btnFeeding(_ sender: Any) {
		self.categoryView.isHidden = false
	}
	@IBAction func btnSelectSizeAction(_ sender: Any) {
		if self.productAttributes.count > 0 {
			self.sizePickerView.reloadAllComponents()
			sizePickerView.isHidden = false
		}
		
	}
	
	@IBAction func btnAddToCartAction(_ sender: Any) {
		if weights.count > 0 {
			if lbSize.text == nil || lbSize.text == ""{
				let alert = UIAlertController(title: "Alert", message: "No weights selected", preferredStyle: UIAlertController.Style.alert)
				let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
				alert.addAction(defaultAction)
				self.present(alert, animated: true, completion: nil)
				return
			}
		}
		self.getCartID()
	}
	
	func getCartID() {
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			SVProgressHUD.show(withStatus: "Loading Request")
			let urlString =  PBaseUrl + PCartId
			let customerToken = UserDefaults.standard.string(forKey: "customerToken")
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
			SVProgressHUD.show(withStatus: "Loading Request")
//			let customerID = UserDefaults.standard.integer(forKey: "id")
			let urlString =  PBaseUrl + PCart
			
			let extensionAttributes:[String:AnyObject] = [:]
			
			var cartItems:[String:AnyObject] = [:]
			
			if productType == "configurable" {
				
				var dictionaries = [[String: AnyObject]]()
				let dictionary1: [String: AnyObject] = ["option_id": self.attributeID as AnyObject, "option_value": Int(self.finalWeight) as AnyObject ]
				dictionaries.append(dictionary1)
				
				let extAttribute:[String:AnyObject] = ["configurable_item_options":dictionaries as AnyObject]
				
				let productOption:[String:AnyObject] = ["extension_attributes": extAttribute as AnyObject]
				
				cartItems = ["sku":self.productDetail?.sku as AnyObject, "qty":1 as AnyObject, "quote_id" : quoteID as AnyObject, "product_option" : productOption as AnyObject, "extension_attributes" : extensionAttributes as AnyObject]
			}else {
				cartItems = ["sku":self.productDetail?.sku as AnyObject, "qty":1 as AnyObject, "quote_id" : quoteID as AnyObject, "extension_attributes" : extensionAttributes as AnyObject]
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
				
				if self.tabBarController!.selectedIndex == 0 {
					let alert = UIAlertController(title: "Cart Updated", message: "Visit Cart to view your product", preferredStyle: UIAlertController.Style.alert)
					alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
						let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
						self.navigationController?.pushViewController(nextViewController, animated: true)
						
					}))
					self.present(alert, animated: true, completion: nil)
				}else {
					let alert = UIAlertController(title: "Cart Updated", message: "Visit Cart to view your product", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					self.present(alert, animated: true, completion: nil)
				}
				
//				self.purchaseOrder()
				
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
				
				let media = success["media_gallery_entries"] as! NSArray
				var arrImgString:Array<String> = []
				if media.count > 0 {
					let image = media[0] as! NSDictionary
					let finalImage = image["file"] as! String
					var urlImageString = PBaseSUrl + "pub/media/catalog/product" + finalImage
					self.imgProduct.sd_setImage(with: URL(string:urlImageString), placeholderImage: UIImage(named: ""))
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
					let prodDict = success["extension_attributes"] as! NSDictionary
					let productOption = prodDict["configurable_product_options"] as! NSArray
					if productOption.count > 0 {
						for items in productOption {
							let itemDict = items as! NSDictionary
							if (itemDict["label"] as! String) == "Weight" {
								let value = itemDict["values"] as! NSArray
								self.weights = value
								self.attributeID = itemDict ["attribute_id"] as! String
								self.getAttributes(attributeID: self.attributeID)
							}
						}
					}
				}else {
					self.lbWeight.isHidden = true
					self.btnSize.isHidden = true
					self.lbSize.isHidden = true
				}

				
			})
		}else{
			let alert = UIAlertController(title: "Network", message: PNoNetwork, preferredStyle: UIAlertController.Style.alert)
			let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(defaultAction)
			self.present(alert, animated: true, completion: nil)
		}
	}
	
	
	
	func getAttributes(attributeID:String){
		var optionArray:NSArray = []
		if Reachability.isConnectedToInternet() {
			print("Yes! internet is available.")
			
			SVProgressHUD.show(withStatus: "Loading Request")
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
