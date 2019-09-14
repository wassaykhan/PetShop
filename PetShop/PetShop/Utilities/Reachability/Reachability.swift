//
//  Reachability.swift
//  PetShop
//
//  Created by Wassay Khan on 12/09/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire

class Reachability {
	class func isConnectedToInternet() ->Bool {
		return NetworkReachabilityManager()!.isReachable
	}
}
