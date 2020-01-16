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

//Add Wish List
let PAddWishList:String = "wishlist/add"

//A-Z Brand
let PAtoZ:String =  "products/attributes/manufacturer/options"

//Brand
let PBrand:String = "layernaivgation/list/?categoryId="

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

//Forgot Password
let PForgotPassword:String = "customers/password"

//Edit Profile
let PEditProfile:String = "customers/"

//delete Wishlist
let PWishListDelete:String = "deleteWishlistForCustomer/"

//getproductconfigvalue
let PProductConfigValue:String = "getproductconfigvalue/"

//check wishlist
let PCheckWishlist:String = "getwhishlistcustomersku/"

//getCartItem
let PGetCartProducts:String = "getcartproducts/"

//add address
let PCustomers:String = "customers/"

//Code
let PCode:String = "carts/mine/coupons/"

//getorderreview/
let PGetOrderReview = "getorderreview/"

//getobjectcartcount
let PGetCuont = "getobjectcartcount"
