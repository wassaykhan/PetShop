//
//  AlamofireCalls.swift
//  PetShop
//
//  Created by Wassay Khan on 12/09/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class AlamofireCalls: NSObject {
	
	class func postCall(urlString:String,parameters:[String:String],completion: @escaping (String) -> Void){
		Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
			.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
				print("Progress: \(progress.fractionCompleted)")
			}
			.validate { request, response, data in
				// Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
				return .success
			}
			.responseJSON { response in
				debugPrint(response)
				SVProgressHUD.dismiss()
				if	response.result.value == nil {
					
					let alert = UIAlertController(title: "ALert", message: "Response time out", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
//					self.present(alert, animated: true, completion: nil)
					return
				}
				
				if response.response!.statusCode == 200 {
					
					print("Success")
					
					let token = response.result.value
					print(token!)
					completion(token as! String)
					
					
				}else if response.response!.statusCode == 401{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PInvalidKey, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
//					self.present(alert, animated: true, completion: nil)
					
				}else if response.response!.statusCode == 404{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PNoResourceFound, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
//					self.present(alert, animated: true, completion: nil)
					
				}else{
					
					//print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PUnknown, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
//					self.present(alert, animated: true, completion: nil)
					
				}
				
		}
	}
	
	class func postCallAny(urlString:String,parameters:[String:AnyObject],completion: @escaping (NSDictionary) -> Void){
		
		Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
			.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
				print("Progress: \(progress.fractionCompleted)")
			}
			.validate { request, response, data in
				// Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
				return .success
			}
			.responseJSON { response in
				debugPrint(response)
				SVProgressHUD.dismiss()
				if	response.result.value == nil {
					
					let alert = UIAlertController(title: "ALert", message: "Response time out", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					return
				}
				
				if response.response!.statusCode == 200 {
					
					print("Success")
					
					let token = response.result.value
					print(token!)
					completion(token as! NSDictionary)
					
					
				}else if response.response!.statusCode == 401{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PInvalidKey, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else if response.response!.statusCode == 404{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PNoResourceFound, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else{
					
					//print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PUnknown, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}
				
		}
	}
	
	class func postCallAnyWithHeader(urlString:String,parameters:[String:AnyObject],headers:[String:String],completion: @escaping (NSArray) -> Void){
		
		Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:headers)
			.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
				print("Progress: \(progress.fractionCompleted)")
			}
			.validate { request, response, data in
				// Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
				return .success
			}
			.responseJSON { response in
				debugPrint(response)
				SVProgressHUD.dismiss()
				if	response.result.value == nil {
					
					let alert = UIAlertController(title: "ALert", message: "Response time out", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					return
				}
				
				if response.response!.statusCode == 200 {
					
					print("Success")
					
					let token = response.result.value
					print(token!)
					completion(token as! NSArray)
					
					
				}else if response.response!.statusCode == 401{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PInvalidKey, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else if response.response!.statusCode == 404{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PNoResourceFound, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else{
					
					//print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PUnknown, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}
				
		}
	}
	
	class func postCallAnyWithOnlyHeader(urlString:String,headers:[String:String],completion: @escaping (Int) -> Void){
		
		Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers:headers)
			.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
				print("Progress: \(progress.fractionCompleted)")
			}
			.validate { request, response, data in
				// Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
				return .success
			}
			.responseJSON { response in
				debugPrint(response)
				SVProgressHUD.dismiss()
				if	response.result.value == nil {
					
					let alert = UIAlertController(title: "ALert", message: "Response time out", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					return
				}
				
				if response.response!.statusCode == 200 {
					
					print("Success")
					
					let token = response.result.value
					print(token!)
					completion(token as! Int)
					
					
				}else if response.response!.statusCode == 401{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PInvalidKey, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else if response.response!.statusCode == 404{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PNoResourceFound, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else{
					
					//print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PUnknown, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}
				
		}
	}
	
	class func postCallAnyWithHeaderDict(urlString:String,parameters:[String:AnyObject],headers:[String:String],completion: @escaping (NSDictionary) -> Void){
		
		Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:headers)
			.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
				print("Progress: \(progress.fractionCompleted)")
			}
			.validate { request, response, data in
				// Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
				return .success
			}
			.responseJSON { response in
				debugPrint(response)
				SVProgressHUD.dismiss()
				if	response.result.value == nil {
					
					let alert = UIAlertController(title: "ALert", message: "Response time out", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					return
				}
				
				if response.response!.statusCode == 200 {
					
					print("Success")
					
					let token = response.result.value
					print(token!)
					completion(token as! NSDictionary)
					
					
				}else if response.response!.statusCode == 401{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PInvalidKey, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else if response.response!.statusCode == 404{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PNoResourceFound, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else{
					
					//print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PUnknown, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}
				
		}
	}
	
	class func postCallAnyWithHeaderDictString(urlString:String,parameters:[String:AnyObject],headers:[String:String],completion: @escaping (String) -> Void){
		
		Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers:headers)
			.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
				print("Progress: \(progress.fractionCompleted)")
			}
			.validate { request, response, data in
				// Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
				return .success
			}
			.responseJSON { response in
				debugPrint(response)
				SVProgressHUD.dismiss()
				if	response.result.value == nil {
					
					let alert = UIAlertController(title: "ALert", message: "Response time out", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					return
				}
				
				if response.response!.statusCode == 200 {
					
					print("Success")
					
					let token = response.result.value
					print(token!)
					completion(token as! String)
					
					
				}else if response.response!.statusCode == 401{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PInvalidKey, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else if response.response!.statusCode == 404{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PNoResourceFound, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else{
					
					//print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PUnknown, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}
				
		}
	}
	
	class func getCall(urlString:String,parameters:[String:String],headers:[String:String],completion: @escaping (NSArray) -> Void){
		
		
		Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:headers)
			.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
				print("Progress: \(progress.fractionCompleted)")
			}
			.validate { request, response, data in
				// Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
				return .success
			}
			.responseJSON { response in
				debugPrint(response)
				SVProgressHUD.dismiss()
				if	response.result.value == nil {
					
					let alert = UIAlertController(title: "ALert", message: "Response time out", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					return
				}
				
				if response.response!.statusCode == 200 {
					
					print("Success")
					
					let token = response.result.value
					print(token!)
					completion(token as! NSArray)
					
				}else if response.response!.statusCode == 401{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PInvalidKey, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else if response.response!.statusCode == 404{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PNoResourceFound, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else{
					
					//print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PUnknown, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}
				
		}
	}
	
	class func getCallDictionary(urlString:String,parameters:[String:String],headers:[String:String],completion: @escaping (NSDictionary) -> Void){
		
		
		Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:headers)
			.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
				print("Progress: \(progress.fractionCompleted)")
			}
			.validate { request, response, data in
				// Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
				return .success
			}
			.responseJSON { response in
				debugPrint(response)
				SVProgressHUD.dismiss()
				if	response.result.value == nil {
					
					let alert = UIAlertController(title: "ALert", message: "Response time out", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					return
				}
				
				if response.response!.statusCode == 200 {
					
					print("Success")
					
					let token = response.result.value
					print(token!)
					completion(token as! NSDictionary)
					
				}else if response.response!.statusCode == 401{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PInvalidKey, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else if response.response!.statusCode == 404{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PNoResourceFound, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else{
					
					//print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PUnknown, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}
				
		}
	}
	
	
	class func deleteCall(urlString:String,parameters:[String:String],headers:[String:String],completion: @escaping (Bool) -> Void){
		Alamofire.request(urlString, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers:headers)
			.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
				print("Progress: \(progress.fractionCompleted)")
			}
			.validate { request, response, data in
				// Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
				return .success
			}
			.responseJSON { response in
				debugPrint(response)
				SVProgressHUD.dismiss()
				if	response.result.value == nil {
					
					let alert = UIAlertController(title: "ALert", message: "Response time out", preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					return
				}
				
				if response.response!.statusCode == 200 {
					
					print("Success")
					
					let token = response.result.value
					print(token as Any)
					completion(token as! Bool)
					
				}else if response.response!.statusCode == 401{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PInvalidKey, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else if response.response!.statusCode == 404{
					
					print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PNoResourceFound, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}else{
					
					//print("Server Error")
					let alert = UIAlertController(title: "ALert", message: PUnknown, preferredStyle: UIAlertController.Style.alert)
					let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
					alert.addAction(defaultAction)
					//					self.present(alert, animated: true, completion: nil)
					
				}
				
		}
	}
	

}
