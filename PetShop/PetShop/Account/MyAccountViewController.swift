//
//  MyAccountViewController.swift
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


class MyAccountViewController: UIViewController {

	@IBOutlet weak var lbName: UILabel!
	
	@IBOutlet weak var lbEmail: UILabel!
	
	var userName = ""
	var emailAddress = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.lbName.text = userName
		self.lbEmail.text = emailAddress
//		self.getAccountDetail()
		
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
	}
    
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func lbLogoutAction(_ sender: Any) {
		UserDefaults.standard.removeObject(forKey: "customerToken")
		self.navigationController?.popViewController(animated: true)
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
