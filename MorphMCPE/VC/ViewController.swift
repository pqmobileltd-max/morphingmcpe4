//
//  ViewController.swift
//  MorphMCPE
//
//  Created by son on 6/13/22.
//

import Foundation
import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport
import MBProgressHUD
#if DEBUG
    let Interstitial_Ads  = "ca-app-pub-3940256099942544/4411468910"
    let Banner_Ads  = "ca-app-pub-3940256099942544/2934735716"
    let Open_App_Ads  = "ca-app-pub-3940256099942544/5662855259"
    let Rewarded_Ads = "ca-app-pub-3940256099942544/1712485313"
    let Native_Ads = "ca-app-pub-3940256099942544/3986624511"
#else
    let Interstitial_Ads  = "ca-app-pub-9905481665860575/1474771104"
    let Banner_Ads  = "ca-app-pub-9905481665860575/6973938973"
    let Open_App_Ads  = "ca-app-pub-9905481665860575/5221873605"
    let Rewarded_Ads = "ca-app-pub-9905481665860575/5130945080"
    let Native_Ads = "ca-app-pub-9905481665860575/7845660025"
#endif



class ViewController : UIViewController{
    
    static var counter = 0
    
    static var interstitialAd: GADInterstitialAd?
    
    static var bannerView: GADBannerView!
    
    static var rewardedAd : GADRewardedAd!
    
    static var adLoader : GADAdLoader!
    
    static var nativeAd : GADNativeAd!
    
    static var isAskIDFA = false
    
    override func viewDidLoad() {
                
        let device = UIScreen.main.traitCollection.userInterfaceIdiom
        
        if ViewController.bannerView == nil{
            if device == .pad{
                ViewController.bannerView = GADBannerView(adSize: GADAdSizeLeaderboard)
            }else{
                ViewController.bannerView = GADBannerView(adSize: GADAdSizeBanner)
            }
            
            ViewController.bannerView.adUnitID = Banner_Ads
            
            ViewController.bannerView.load(GADRequest())
            
        }
        ViewController.bannerView.rootViewController = self
        ViewController.bannerView.delegate = self

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ViewController.bannerView.isHidden = AppStore.shared.isUnlockPremium()
        
        if AppStore.shared.isUnlockPremium(){
            return
        }
        
//        if ViewController.interstitialAd == nil{
//            self.loadInterstitialAd()
//        }
        
//        if ViewController.rewardedAd == nil{
//            loadRewardAd()
//        }
        
        if ViewController.nativeAd == nil{
            loadNativeAd()
        }
        
        showInterstitialAds()
        
        addBannerAds(ViewController.bannerView)
        
        
    }
    
    func loadNativeAd(){
        
        if AppViewModel.shared.app_ctrl == false{
            return
        }
        
        if AppStore.shared.isUnlockPremium(){
            return
        }
        
        let multipleAdOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdOptions.numberOfAds = 1;
        ViewController.adLoader = GADAdLoader(adUnitID: Native_Ads,
            rootViewController: self,
            adTypes: [ .native ],
            options: [ multipleAdOptions ])
        
        ViewController.adLoader.delegate = self
        ViewController.adLoader.load(GADRequest())
    }
    
    static func requestIDFA() {
        
        if ViewController.isAskIDFA{
            return
        }
        
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                // Tracking authorization completed. Start loading ads here.
                // loadAd()
                ViewController.isAskIDFA = true
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func addBannerAds(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    
    func loadRewardAd(completion : @escaping () -> ()){
        GADRewardedAd.load(withAdUnitID: Rewarded_Ads, request: GADRequest()) { (ad, err) in
            if err == nil{
                ViewController.rewardedAd =  ad
                ViewController.rewardedAd.fullScreenContentDelegate = self
            }
            
            completion()
        }
    }

    func loadInterstitialAd(completion : @escaping () -> ()){
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID:Interstitial_Ads ,request: request,completionHandler: { [self] ad, error in
            
            if error != nil {
                completion()
                return
            }
            
            ViewController.interstitialAd = ad
            ViewController.interstitialAd?.fullScreenContentDelegate = self
            completion()
          }
        )
    }
    
    func showRewardedAd(completion : @escaping () -> ()){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        loadRewardAd {
            MBProgressHUD.hide(for: self.view, animated: true)
            if ViewController.rewardedAd != nil{
                
                ViewController.counter = 1
                
                ViewController.rewardedAd.present(fromRootViewController: self) {
                    completion()
                }
            }else{
                completion()
            }
        }
        
        
    }
    
    func showInterstitialAds(){
        
        if AppStore.shared.isUnlockPremium(){
            return
        }

        if AppViewModel.shared.isMoreThanOneHour == false{
            return
        }
        
        ViewController.counter = ViewController.counter + 1
        
        if ViewController.counter == 8{
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.loadInterstitialAd {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if ViewController.interstitialAd != nil {
                    ViewController.interstitialAd!.present(fromRootViewController: self)
                    ViewController.counter = 0
                  } else {
                    ViewController.counter = 4
                  }
            }
            
            
            
        }
    }
    
    func showInterstitialAds2(){
        
        if AppStore.shared.isUnlockPremium(){
            return
        }
        
        if ViewController.interstitialAd != nil {
            ViewController.interstitialAd!.present(fromRootViewController: self)
        }
    }
    
    func rateApp(){
        let alert = AlertController(title: "Enjoying App?", message: "Tap to rate this app on App Store.", preferredStyle: .alert)
        
        alert.setTitleImage(UIImage(named: "review"))
        
        let rate = UIAlertAction(title: "Rate App", style: .cancel) { _ in
            let url = URL(string: "https://apps.apple.com/US/app/id1631462659?action=write-review")
            UIApplication.shared.open(url!)
            UserDefaults.isRateApp = true
        }
        
        let cancel = UIAlertAction(title: "Not Now", style: .default, handler: nil)
        
        alert.addAction(rate)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }

    
    
}
extension ViewController : GADNativeAdLoaderDelegate, GADNativeAdDelegate{
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        
    }
    
    
    func adLoader(_ adLoader: GADAdLoader,didReceive nativeAd: GADNativeAd) {
        print("didReceive nativeAd==========")
        ViewController.nativeAd = nativeAd
        ViewController.nativeAd.delegate = self
    }

    func adLoaderDidFinishLoading(_ adLoader: GADAdLoader) {
        // The adLoader has finished loading ads, and a new request can be sent.
    }
}

extension ViewController : GADFullScreenContentDelegate{
    
      func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        
      }
      
      func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        
      }
    
}

extension ViewController : GADBannerViewDelegate{

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        ViewController.bannerView.load(GADRequest())
    }
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        self.loadNativeAd()
    }
}


