//
//  SortViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 21/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class SortViewController: UIViewController {

	@IBOutlet weak var btnRelevance: UIButton!
	@IBOutlet weak var btnNewest: UIButton!
	@IBOutlet weak var btnBestSelling: UIButton!
	@IBOutlet weak var btnPriceHighLow: UIButton!
	@IBOutlet weak var btnPriceLowHigh: UIButton!
	@IBOutlet weak var btnCustomerReview: UIButton!
	@IBOutlet weak var btnMostReview: UIButton!
	
	var isRelevance = false
	var isNewest = false
	var isBestSelling = false
	var isPriceHighLow = false
	var isPriceLowHigh = false
	var isCustomerReview = false
	var isMostReview = false
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
    }
    
	@IBAction func btnDoneAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func btnRelevanceAction(_ sender: Any) {
		if isRelevance {
			self.btnRelevance.setBackgroundImage(UIImage(named: "un"), for: UIControl.State.normal)
			self.isRelevance = false
		}else{
			self.btnRelevance.setBackgroundImage(UIImage(named: "checked"), for: UIControl.State.normal)
			self.isRelevance = true
		}
	}
	
	@IBAction func btnNewestAction(_ sender: Any) {
		if isNewest {
			self.btnNewest.setBackgroundImage(UIImage(named: "un"), for: UIControl.State.normal)
			self.isNewest = false
		}else{
			self.btnNewest.setBackgroundImage(UIImage(named: "checked"), for: UIControl.State.normal)
			self.isNewest = true
		}
	}
	
	@IBAction func btnBestSellingAction(_ sender: Any) {
		if isBestSelling {
			self.btnBestSelling.setBackgroundImage(UIImage(named: "un"), for: UIControl.State.normal)
			self.isBestSelling = false
		}else{
			self.btnBestSelling.setBackgroundImage(UIImage(named: "checked"), for: UIControl.State.normal)
			self.isBestSelling = true
		}
	}
	
	@IBAction func btnPriceHighLowAction(_ sender: Any) {
		if isPriceHighLow {
			self.btnPriceHighLow.setBackgroundImage(UIImage(named: "un"), for: UIControl.State.normal)
			self.isPriceHighLow = false
		}else{
			self.btnPriceHighLow.setBackgroundImage(UIImage(named: "checked"), for: UIControl.State.normal)
			self.isPriceHighLow = true
		}
	}
	
	@IBAction func btnPriceLowHighAction(_ sender: Any) {
		if isPriceLowHigh {
			self.btnPriceLowHigh.setBackgroundImage(UIImage(named: "un"), for: UIControl.State.normal)
			self.isPriceLowHigh = false
		}else{
			self.btnPriceLowHigh.setBackgroundImage(UIImage(named: "checked"), for: UIControl.State.normal)
			self.isPriceLowHigh = true
		}
	}
	
	@IBAction func btnCustomerReviewAction(_ sender: Any) {
		if isCustomerReview {
			self.btnCustomerReview.setBackgroundImage(UIImage(named: "un"), for: UIControl.State.normal)
			self.isCustomerReview = false
		}else{
			self.btnCustomerReview.setBackgroundImage(UIImage(named: "checked"), for: UIControl.State.normal)
			self.isCustomerReview = true
		}
	}
	
	@IBAction func btnMostReviewAction(_ sender: Any) {
		if isMostReview {
			self.btnMostReview.setBackgroundImage(UIImage(named: "un"), for: UIControl.State.normal)
			self.isMostReview = false
		}else{
			self.btnMostReview.setBackgroundImage(UIImage(named: "checked"), for: UIControl.State.normal)
			self.isMostReview = true
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
