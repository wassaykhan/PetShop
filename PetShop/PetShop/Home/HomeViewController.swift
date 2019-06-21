//
//  HomeViewController.swift
//  PetShop
//
//  Created by Wassay Khan on 15/06/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import ImageSlideshow

class HomeViewController: UIViewController {

	@IBOutlet weak var slideshow: ImageSlideshow!
	@IBOutlet weak var viewSearch: UIView!
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
//		self.slideshow.delegate = self
		
//		let localSource = [UIImage(named: "Group 25 copy")]
//		let localSource = [BundleImageSource(imageString: "kingfisher"), BundleImageSource(imageString: "624848-PNY8BB-710"), BundleImageSource(imageString: "goldfish")]
		// can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
		slideshow.setImageInputs([ImageSource(image: UIImage(named: "petImg")!),
								  ImageSource(image: UIImage(named: "petImg1")!)])
		
		let recognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.didTap))
		slideshow.addGestureRecognizer(recognizer)
        // Do any additional setup after loading the view.
    }
	
	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
    
	@objc func didTap() {
		let fullScreenController = slideshow.presentFullScreenController(from: self)
		// set the activity indicator for full screen controller (skipping the line will show no activity indicator)
		fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
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
