//
//  MainTabBarController.swift
//  PetShop
//
//  Created by Wassay Khan on 19/09/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
		UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(red: 2/255, green: 166/255, blue: 178/255, alpha: 1)], for: UIControl.State.selected)
			UITabBar.appearance().tintColor = UIColor.init(red: 2/255, green: 166/255, blue: 178/255, alpha: 1)
        // Do any additional setup after loading the view.
    }

	

	
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//		if tabBar.selectedItem == 3 {
//			print("kuch")
//			let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginID") as! LoginViewController
//			//			self.viewControllers![nextViewController]
//			self.navigationController?.present(nextViewController, animated: true, completion: nil)
//		}

	}

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
