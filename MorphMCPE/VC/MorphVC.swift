//
//  MorphVC.swift
//  MorphMCPE
//
//  Created by son on 6/9/22.
//

import UIKit
import SwiftyGif
import StoreKit
import GoogleMobileAds
class MorphVC: ViewController {
    
    @IBOutlet weak var nativeAdHolderView: UIView!
    var nativeAdView: GADNativeAdView!
    @IBOutlet weak var nativeAdHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tutorialBtn: UIButton!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var freePackImageView: UIImageView!
    @IBOutlet weak var freeView: UIView!
    
    @IBOutlet weak var premiumImageView: UIImageView!
    @IBOutlet weak var premiumView: UIView!
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    @IBOutlet weak var packViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MORPH MOD"
        freeView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        premiumView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        headerImageView.layer.borderColor = UIColor.white.cgColor
        headerImageView.layer.borderWidth = 2
        
        do {
            let gif = try UIImage(gifName: "morphMod.gif")
            self.headerImageView.setGifImage(gif, loopCount: -1) // Will loop forever
        } catch {
            print(error)
        }
        
        do {
            let gif2 = try UIImage(gifName: "free-mods.gif")
            self.freePackImageView.setGifImage(gif2, loopCount: -1) // Will loop forever
        } catch {
            print(error)
        }
        
        do {
            let gif3 = try UIImage(gifName: "premium-mods.gif")
            self.premiumImageView.setGifImage(gif3, loopCount: -1) // Will loop forever
        } catch {
            print(error)
        }

        let nibObjects = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil)!
        let adView = nibObjects.first as! GADNativeAdView
        
        self.setAdView(adView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
            self.packViewHeightConstraint.constant = 120
            case .pad:
            self.packViewHeightConstraint.constant = 200
                // It's an iPad (or macOS Catalyst)
             default:
                break
        }
        

        if ViewController.nativeAd == nil || AppStore.shared.isUnlockPremium(){
            nativeAdHolderView.isHidden = true
            nativeAdHeightConstraint.constant = 0
        }else{
            nativeAdHolderView.isHidden = false
            let device = UIScreen.main.traitCollection.userInterfaceIdiom
            if device == .pad{
                nativeAdHeightConstraint.constant = 400
            }else{
                nativeAdHeightConstraint.constant = 300
            }
            self.updateNativeAdView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollViewHeight.constant = nativeAdHolderView.frame.origin.y + nativeAdHolderView.frame.height + ViewController.bannerView.frame.height + 100
        
    }

    @IBAction func tutorialAction(_ sender: Any) {
        let vc = MorphModTutorialVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    @IBAction func showFreeModDetail(_ sender: Any) {
        let vc = MorphDetailVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func showPremiumModDetail(_ sender: Any) {
        let vc = MorphDetailVC()
        vc.isVIP = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    

    func setAdView(_ view: GADNativeAdView) {
      nativeAdView = view
      nativeAdHolderView.addSubview(view)
      nativeAdView.translatesAutoresizingMaskIntoConstraints = false

      // Layout constraints for positioning the native ad view to stretch the entire width and height
      // of the nativeAdPlaceholder.
      let viewDictionary = ["_nativeAdView": nativeAdView!]
      self.view.addConstraints(
        NSLayoutConstraint.constraints(
          withVisualFormat: "H:|[_nativeAdView]|",
          options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
      )
      self.view.addConstraints(
        NSLayoutConstraint.constraints(
          withVisualFormat: "V:|[_nativeAdView]|",
          options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
      )
    }
    
    func updateNativeAdView(){
        (nativeAdView.headlineView as? UILabel)?.text = ViewController.nativeAd.headline
        nativeAdView.mediaView?.mediaContent = ViewController.nativeAd.mediaContent
        nativeAdView.callToActionView?.isHidden = ViewController.nativeAd.callToAction == nil
        nativeAdView.nativeAd = ViewController.nativeAd
    }
    
    override func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        super.adLoader(adLoader, didReceive: nativeAd)
        
        let device = UIScreen.main.traitCollection.userInterfaceIdiom
        if device == .pad{
            self.nativeAdHeightConstraint.constant = 400
        }else{
            self.nativeAdHeightConstraint.constant = 300
        }
        
        nativeAdHolderView.isHidden = false
        
        self.updateNativeAdView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.scrollViewHeight.constant = self.nativeAdHolderView.frame.origin.y + self.nativeAdHolderView.frame.height + ViewController.bannerView.frame.height + 100
        }
    }
}
