//
//  AppStore.swift
//  MorphMCPE
//
//  Created by son on 6/13/22.
//

import Foundation
import SwiftyStoreKit
import StoreKit

let LIFETIME = "com.jalistudio2020.MorphingMCPE.lifetime"
let MONTHLY = "com.jalistudio2020.MorphingMCPE.monthly"
//let WEEKLY = "com.jalistudio2020.MorphingMCPE.weekly"
let WEEKLY = "com.jalistudio2020.MorphingMCPE.weeklySubscription"

class AppStore{
    
    let SHARE_KEY = "d4da7cb9201d45beb7b99fc4d82a4c53"
    
    static let shared = AppStore()
    
    func getStorePrices(ids : Set<String>,completion : @escaping (Set<SKProduct>) -> ()){
        
        SwiftyStoreKit.retrieveProductsInfo(ids) { result in
            
            if result.error != nil{
                completion([])
            }else{
                let products = result.retrievedProducts
                completion(products)
            }

        }
    }
    func purchase(_ id : String,complete : @escaping (PurchaseResult) -> ()){
        SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { result in
            complete(result)
        }
    }
    
    func subscribe(_ id : String,complete : @escaping (PurchaseResult) -> ()){
        SwiftyStoreKit.purchaseProduct(id, quantity: 1, atomically: true) { purchaseResult in
            switch purchaseResult {
            
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                
                self.checkSubscription(id, forceRefresh: false) { (result) in
                    complete(purchaseResult)
                }
            
            case .error(let error):
                complete(purchaseResult)
            }
        }
    }
    
    func checkHoaDon(_ id : String,complete : @escaping (VerifyReceiptResult) -> ()){
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: SHARE_KEY)
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: true) { result in
            switch result {
            
            case .success(let receipt):
                let productId = id
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
               
                case .purchased(let receiptItem):
                    
                    UserDefaults.setNonConsumablePurchaseStatus(forKey: id, value: true)
                    
                case .notPurchased:
                    break
                    
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
                
            }
            complete(result)
        }
    }
    
    func checkSubscription(_ id : String,forceRefresh : Bool,complete : @escaping (VerifyReceiptResult) -> ()){
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: SHARE_KEY)
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: forceRefresh)  { result in
            
            switch result {
            case .success(let receipt):
                let productId = id
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable, // or .nonRenewing (see below)
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                
                case .purchased(let expiryDate, let items):
                    print("\(productId) is valid until \(expiryDate)\n\(items)\n")
                
                    UserDefaults.setExpiredSubscriptionDate(forKey: id, value: expiryDate)
                
                case .expired(let expiryDate, let items):
                    print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }

            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
            complete(result)
        }
    }
    
    func restorePurchases(){
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
            }
            else {
                print("Nothing to Restore")
            }
        }
    }
    
    func isUnlockPremium() -> Bool{
        
//        return true

        if UserDefaults.isLifeTime{
            return true
        }
        
        let monthlyExpiredDate = UserDefaults.standard.double(forKey: MONTHLY)
//        let weeklyExpiredDate = UserDefaults.standard.double(forKey: WEEKLY)
        
        let currentDate = Date().timeIntervalSince1970
        
        if monthlyExpiredDate >= currentDate{
            return true
        }
        
//        if weeklyExpiredDate >= currentDate{
//            return true
//        }
        
        return false
    }

}

extension UserDefaults{
    
    static var isRateApp: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: "isRateApp")
        }
        set {
            
            UserDefaults.standard.set(newValue, forKey: "isRateApp")
            UserDefaults.standard.synchronize()
        }
    }

    static var isLifeTime: Bool! {
        get {
            return UserDefaults.standard.bool(forKey: LIFETIME)
        }
        set {
            
            UserDefaults.standard.set(newValue, forKey: LIFETIME)
            UserDefaults.standard.synchronize()
        }
    }
    
    static func setNonConsumablePurchaseStatus(forKey : String,value : Bool){
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    static func setExpiredSubscriptionDate(forKey : String,value : Date){
        UserDefaults.standard.set(value.timeIntervalSince1970, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
}

