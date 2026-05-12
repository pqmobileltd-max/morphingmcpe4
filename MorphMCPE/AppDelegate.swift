//
//  AppDelegate.swift
//  MorphMCPE
//
//  Created by son on 6/1/22.
//

import UIKit
import SwiftyStoreKit
import GoogleMobileAds
import UnityAds
import Firebase
import FirebaseAppCheck

class AppAttestProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        return AppAttestProvider(app: app)
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupNavigationBarAppearance()
#if DEBUG
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
#else
        let providerFactory = AppAttestProviderFactory()//AppCheckDebugProviderFactory()//AppAttestProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
#endif
        
        
        FirebaseApp.configure()
        
        let ads = GADMobileAds.sharedInstance()
            ads.start { status in
              // Optional: Log each adapter's initialization latency.
              let adapterStatuses = status.adapterStatusesByClassName
              for adapter in adapterStatuses {
                let adapterStatus = adapter.value
                NSLog("Adapter Name: %@, Description: %@, Latency: %f", adapter.key,
                adapterStatus.description, adapterStatus.latency)
              }

              // Start loading ads here...
                let gdprMetaData = UADSMetaData()
                gdprMetaData.set("gdpr.consent", value: true)
                gdprMetaData.commit()
                
                let ccpaMetaData = UADSMetaData()
                ccpaMetaData.set("privacy.consent", value: true)
                ccpaMetaData.commit()
            }
        
        
        initStore()
        return true
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        ViewController.requestIDFA()
    }

    func initStore(){
        
        func check(){
            let vm = AppStore()
            DispatchQueue.global().async {
                vm.checkHoaDon(LIFETIME) {_ in }
            }
            
            DispatchQueue.global().async {
                vm.checkSubscription(MONTHLY, forceRefresh: true) { _ in}
            }
        }
        
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    check()
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                default:
                    break
                }
            }
        }
        
    }
    
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBar.appearance()
        
        appearance.tintColor = .white // Bar button items
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Title color
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Large title color
        
        // Optional: Set background color or make it translucent
        appearance.barTintColor = .clear // Example background
        appearance.isTranslucent = true
    }

}

