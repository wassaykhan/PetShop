//
//  CustomNavVC.swift
//  EjarCar
//
//  Created by Wassay Khan on 19/11/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class CustomNavVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        // Do any additional setup after loading the view.
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
