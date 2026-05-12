//
//  StoreVC.swift
//  MorphMCPE
//
//  Created by son on 6/12/22.
//

import UIKit
import SwiftyStoreKit
import StoreKit
import MBProgressHUD
class StoreVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var monthlyPriceHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var purchaseBtn: UIButton!
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var lifeTimeBtn: UIButton!
    @IBOutlet weak var monthlyBtn: UIButton!
    
    var isSelectMonthly = true
    
    var viewModel = AppStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStoreInfo()
        
        headerImageView.layer.borderColor = UIColor.white.cgColor
        headerImageView.layer.borderWidth = 2
        
        do {
            let gif = try UIImage(gifName: "morphMod.gif")
            self.headerImageView.setGifImage(gif, loopCount: -1) // Will loop forever
        } catch {
            print(error)
        }
        
        
        setNormalLifeTimeBtn()
        monthlyBtn.layer.cornerRadius = 10
//        setSelectedMonthlyBtn()
        
        lifeTimeBtn.addTarget(self, action: #selector(lifeTimeBtnPressed), for: .touchUpInside)
        monthlyBtn.addTarget(self, action: #selector(monthlyBtnPressed), for: .touchUpInside)
//        purchaseBtn.addTarget(self, action: #selector(purchaseBtnPressed), for: .touchUpInside)
    }
    
    func getStoreInfo(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.getStorePrices(ids: [LIFETIME,WEEKLY]) { (products) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            for product  in products{
                switch product.productIdentifier{
                case LIFETIME:
                    self.lifeTimeBtn.setTitle("Lifetime for \(product.localizedPrice!)", for: .normal)
                case MONTHLY:
                    self.monthlyPriceLabel.text = "START 3 DAYS FREE TRIAL\nTHEN SUBSCRIBE FOR \(product.localizedPrice!)/MONTH"
                case WEEKLY:
                    self.monthlyPriceLabel.text = "START 3 DAYS FREE TRIAL\nTHEN SUBSCRIBE FOR \(product.localizedPrice!)/WEEK"
                    
                default:
                    break
                }
            }
        }
    }
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollViewHeight.constant = textView.frame.origin.y + textView.frame.height + 100
        
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
            monthlyPriceHeightConstraint.constant = 70
            case .pad:
            monthlyPriceHeightConstraint.constant = 100
            default:
            monthlyPriceHeightConstraint.constant = 70
        }
//        self.scrollView.scrollToView(view: self.premiumLabel, animated: false)
//        DispatchQueue.main.async {
//            self.scrollView.scrollRectToVisible(CGRect(x:0, y: 500,width: 1,height: self.purchaseBtn.frame.height), animated: animated)
//        }
        
    }
    
    func setNormalLifeTimeBtn(){
        lifeTimeBtn.setTitleColor(UIColor.white, for: .normal)
        lifeTimeBtn.layer.cornerRadius = 10
        lifeTimeBtn.layer.borderColor = UIColor.white.cgColor
        lifeTimeBtn.layer.borderWidth = 1
        lifeTimeBtn.backgroundColor = .clear

    }
    
//    func setSelectedLifeTimeBtn(){
//        lifeTimeBtn.setTitleColor(UIColor.black, for: .normal)
//        lifeTimeBtn.layer.cornerRadius = 10
//        lifeTimeBtn.layer.borderColor = UIColor.yellow.cgColor
//        lifeTimeBtn.layer.borderWidth = 1
//        lifeTimeBtn.backgroundColor = .yellow
//
//    }
    
 
    
//    func setSelectedMonthlyBtn(){
//        monthlyBtn.setTitleColor(UIColor.black, for: .normal)
//        monthlyBtn.layer.cornerRadius = 10
//        monthlyBtn.layer.borderColor = UIColor.yellow.cgColor
//        monthlyBtn.layer.borderWidth = 1
//        monthlyBtn.backgroundColor = .yellow
//        monthlyCheckmark.isHidden = false
//    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func lifeTimeBtnPressed(){
        self.lifeTimeBtn.backgroundColor = .white
        self.lifeTimeBtn.setTitleColor(UIColor.black, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.lifeTimeBtn.backgroundColor = .clear
            self.lifeTimeBtn.setTitleColor(UIColor.white, for: .normal)
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.purchase(LIFETIME) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            switch result {
            case .success:
                UserDefaults.isLifeTime = true
            case .error(let error):
                print("error\(error.localizedDescription)")
            }
        }
    }
    
    @objc func monthlyBtnPressed(){
        let currentColor = self.monthlyBtn.backgroundColor
        self.monthlyBtn.backgroundColor = .white
//        self.monthlyBtn.setTitleColor(UIColor.black, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.monthlyBtn.backgroundColor = currentColor
//            self.monthlyBtn.setTitleColor(UIColor.white, for: .normal)
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.subscribe(WEEKLY) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @objc func purchaseBtnPressed(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        if isSelectMonthly{
            
            viewModel.subscribe(WEEKLY) { (result) in
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }else{
            viewModel.purchase(LIFETIME) { (result) in
                MBProgressHUD.hide(for: self.view, animated: true)
                
                switch result {
                case .success:
                    UserDefaults.isLifeTime = true
                case .error(let error):
                    print("error\(error.localizedDescription)")
                }
            }
        }
    }
    @IBAction func restore(_ sender: Any) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        self.viewModel.checkHoaDon(LIFETIME) { _ in
            self.viewModel.checkSubscription(WEEKLY, forceRefresh: true) { _ in
                MBProgressHUD.hide(for: self.view, animated: true)
                
                let isUnlock = self.viewModel.isUnlockPremium()
                self.restoreResultAlert(isUnlock)
            }
        }
    }
    
    func restoreResultAlert(_ result : Bool){
        var messsage = "Restore purchases sucessfully! Unlock All Content and Remove all Ads"
        
        if result == false{
            messsage = "Nothing to restore or your subscription is expired!"
        }
        
        let alert = UIAlertController(title: "Finish Restore Purchases", message: messsage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func showTerms(_ sender: Any) {
        let vc = WebVC()
        vc.title = "Terms of use"
        vc.link = "https://sites.google.com/view/jalistudio/terms-of-use"
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    @IBAction func showPolicy(_ sender: Any) {
        let vc = WebVC()
        vc.title = "Privacy Policy"
        vc.link = "https://sites.google.com/view/jalistudio/privacy-policy"
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
}
extension UIScrollView {

    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y: childStartPoint.y - 100,width: 1,height: self.frame.height), animated: animated)
        }
    }

    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
