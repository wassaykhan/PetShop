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
import MessageUI



class MyAccountViewController: UIViewController, MFMailComposeViewControllerDelegate,UITabBarControllerDelegate {

	@IBOutlet weak var lbName: UILabel!
	
	@IBOutlet weak var lbEmail: UILabel!
	
	var userName = ""
	var emailAddress = ""
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.setStatusBarColor()
		if let name = UserDefaults.standard.string(forKey: "firstName"){
			userName = name
			self.lbName.text = userName
		}
		if let name = UserDefaults.standard.string(forKey: "email"){
			emailAddress = name
			self.lbEmail.text = emailAddress
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.lbName.text = userName
		self.lbEmail.text = emailAddress
		tabBarController?.delegate = self
//		self.getAccountDetail()
		
		// Do any additional setup after loading the view.
	}
	
//	override func viewWillAppear(_ animated: Bool) {
//		super.viewWillAppear(true)
//	}
	
	/*- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	return viewController != tabBarController.selectedViewController;
	}*/
	
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		return viewController != tabBarController.selectedViewController
	}
	
	
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func lbLogoutAction(_ sender: Any) {
		UserDefaults.standard.removeObject(forKey: "customerToken")
		UserDefaults.standard.removeObject(forKey: "badgeCount")
//		UserDefaults.standard.removeObject(forKey: "items")
		self.navigationController?.popViewController(animated: true)
	}
	
	
	@IBAction func btnCallAction(_ sender: Any) {
		let phoneNumber = "+971502829999"
		if let url = NSURL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url as URL) {
			UIApplication.shared.openURL(url as URL)
		}
	}
	
	@IBAction func btnEmailAction(_ sender: Any) {
		if MFMailComposeViewController.canSendMail() {
			let mail = MFMailComposeViewController()
			mail.mailComposeDelegate = self
			mail.setToRecipients(["info@thepetstore.ae"])
			mail.setMessageBody("<p>The Pet Store</p>", isHTML: true)
			
			self.navigationController!.present(mail, animated: true, completion: nil)
		}
	}
	
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true)
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
