//
//  RestAPIConstant.swift
//  PetShop
//
//  Created by Wassay Khan on 12/09/2019.
//  Copyright © 2019 Wassay Khan. All rights reserved.
//

import Foundation

// Base Url
let PBaseUrl:String = "http://www.thepetstore.ae/rest/V1/"
//"http://devpetshop.onlinetestingserver.com/petshop/rest/V1/"

// Base Url Short
let PBaseSUrl:String = "http://www.thepetstore.ae/"
//"http://devpetshop.onlinetestingserver.com/petshop/"

//Token Admin
let PToken:String = "integration/admin/token"

//Token Customer
let PCustomerToken:String = "integration/customer/token"

//Slider
let PSlider:String = "slider/list"

//Categories
let PCategories:String = "getchildcategories/"

//Product
let PProduct:String = "products/"

//WishList
let PWishList:String = "wishlist"

//A-Z Brand
let PAtoZ:String =  "products/attributes/manufacturer/options"

//Account
let PCustomerAccount:String = "customers/me"

//Cart
let PCart:String = "carts/mine/items"

//Create User
let PCreateCustomer:String = "customers/?"

//Estimate Shipping
let PEstimateShipping:String = "carts/mine/estimate-shipping-methods?"

//Set Shipping Information
let PShippingInformation:String = "carts/mine/shipping-information?"

//Place Order
let PPlaceOrder:String = "carts/mine/payment-information?"

//Filter
let PFilter:String = "products/?searchCriteria[filterGroups][0][filters][0][field]=category_id&"

let PFilterLayer:String = "layernaivgation/list/?categoryId="

//Attributes
let PAttributes:String = "products/attributes/"

// Cart ID
let PCartId:String = "carts/mine?"

// Remove Cart
let PCartRemove:String = "carts/mine/items/"

