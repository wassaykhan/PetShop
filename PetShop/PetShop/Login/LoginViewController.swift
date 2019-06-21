//
//  LoginViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 09/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

	@IBOutlet weak var viewSignIn: UIView!
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
	@IBAction func btnBackAction(_ sender: Any) {
		self.navigationController?.popViewController(animated: true)
	}
	
	@IBAction func btnSignInAction(_ sender: Any) {
		self.viewSignIn.isHidden = false
	}
	@IBAction func btnCreateAccountAction(_ sender: Any) {
		self.viewSignIn.isHidden = true
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
