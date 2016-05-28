//
//  IAPManager.swift
//  Simple Addition
//
//  Created by Ian Dorosh on 4/15/16.
//  Copyright © 2016 Ian Dorosh. All rights reserved.
//

import UIKit
import StoreKit

protocol IAPManagerDelegate {
    func managerDidRestorePurchases()
    func noPurchases()
    func failed()
    func notPublishedYet()
}

protocol RemoveAdsDelegate {
    func didMakePurchase()
}

class IAPManager : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate {
    
    static let sharedInstance = IAPManager()
    
    var request : SKProductsRequest!!
    var products : NSArray!
    
    var delegate: IAPManagerDelegate?
    var adDelegate: RemoveAdsDelegate?
    
    func setupInAppPurchases(){
        self.validateProductIdentifiers(self.getProductIdentifiersFromMainBundle())
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    func getProductIdentifiersFromMainBundle() -> NSArray
    {
        var Identifiers = NSArray()
        if let url =
            NSBundle.mainBundle().URLForResource("iap_product_ids", withExtension: "plist"){
            Identifiers = NSArray(contentsOfURL : url)!
        }
        
        return Identifiers
    }
    
    func validateProductIdentifiers(identifiers:NSArray){
        let productIdentifiers = NSSet(array: identifiers as [AnyObject])
        let productRequest = SKProductsRequest(productIdentifiers : productIdentifiers as! Set<String>)
        self.request = productRequest
        productRequest.delegate = self
        productRequest.start()
    }
    
    func createPaymentRequestForProduct(product: SKProduct){
        let payment = SKMutablePayment(product: product)
        
        payment.quantity = 1
        
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func verifyReceipt(transaction:SKPaymentTransaction?){
        let receiptURL = NSBundle.mainBundle().appStoreReceiptURL!
        if let receipt = NSData(contentsOfURL : receiptURL){
            //Reciept Exists
            let requestContents = ["receipt-data" : receipt.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))]
            
            //Perform request
            
            do {
                let requestData = try
                    NSJSONSerialization.dataWithJSONObject(requestContents, options: NSJSONWritingOptions(rawValue:0))
                
                let storeURL = NSURL(string: "https://buy.itunes.apple.com/verifyReceipt")
                //https://buy.itunes.apple.com/verifyReceipt
                let request = NSMutableURLRequest(URL : storeURL!)
                request.HTTPMethod = "Post"
                request.HTTPBody = requestData
                
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request, completionHandler: { (responseData:NSData?, response: NSURLResponse?, error:NSError?) -> Void in
                    //
                    
                    do{
                        let json = try NSJSONSerialization.JSONObjectWithData(responseData!, options: .MutableLeaves) as! NSDictionary
                        
                        if (json.objectForKey("status") as! NSNumber) == 0{
                            let receipt_dict = json["receipt"] as! NSDictionary
                            if let purchases = receipt_dict["in_app"] as? NSArray{
                                self.validatePurchaseArray(purchases)
                            }
                            
                            if transaction != nil {
                                SKPaymentQueue.defaultQueue().finishTransaction(transaction!)
                            }
                            
                            var purchased : Bool = false
                            var hasAds : Bool = true
                            let userDefaults = NSUserDefaults.standardUserDefaults()
                            userDefaults.synchronize()
                            
                            if let iad = userDefaults.valueForKey("iad"){
                                purchased = Bool(iad as! Bool)
                            }
                            
                            if let has = userDefaults.valueForKey("hasAds"){
                                hasAds = Bool(has as! Bool)
                            }
                            
                            if (hasAds){
                            if (purchased){
                                NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasAds")
                                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                        self.delegate?.managerDidRestorePurchases()
                                    })
                                } else {
                                }
                            }
                            
                        } else {
                            print (error)
                            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                self.delegate?.notPublishedYet()
                                SKPaymentQueue.defaultQueue().finishTransaction(transaction!)
                            })
                        }
                        
                    } catch {
                        SKPaymentQueue.defaultQueue().finishTransaction(transaction!)
                    }
                })
                
                task.resume()
                
            } catch {
               SKPaymentQueue.defaultQueue().finishTransaction(transaction!)
            }
            
        } else {
            //No Reciept
           
        }
    }
    
    func validatePurchaseArray(purchases:NSArray){
        for purchase in purchases as! [NSDictionary]{
            unlockPurchasedFuntionalityForProductIdentifier(purchase["product_id"] as! String)
        }
    }
    
    func unlockPurchasedFuntionalityForProductIdentifier(productIdentifier : String){
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "iad")
        
        NSUserDefaults.standardUserDefaults().synchronize()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        self.products = response.products
    }
    
    //MARK: SKPayment Transaction Protocol
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions as [SKPaymentTransaction]{
            switch transaction.transactionState{
            case .Purchasing :
                print("Purchasing")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            case .Deferred :
                print("Deferred")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            case .Failed :
                print("Failed")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                print(transaction.error?.localizedDescription)
                
                    self.delegate?.failed()
                
            case .Purchased :
                self.verifyReceipt(transaction)
                
                
                        self.adDelegate?.didMakePurchase()
   
                print("Purchased")
            case .Restored :
                print("Restored")
            }
        }
    }
    
    var restoring : Bool = false
    
    func restorePurchases(){
        restoring = true
        let request = SKReceiptRefreshRequest()
        request.delegate = self
        request.start()
    }
    
    func requestDidFinish(request: SKRequest) {
       
        self.verifyReceipt(nil)
        
       
    }
    
    
}
