//
//  StoreVC2.swift
//  MorphMCPE
//
//  Created by son on 02/01/2024.
//
import UIKit
import SwiftyStoreKit
import StoreKit
import MBProgressHUD

class StoreVC2: UIViewController {
    
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    @IBOutlet weak var btnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var btnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var lifeTimeBtn: UIButton!
    
    @IBOutlet weak var closeBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var startTrialBtn: UIButton!
    var viewModel = AppStore.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getStoreInfo()
        
        

        do {
            let gif = try UIImage(gifName: "morphMod.gif")
            self.headerImageView.setGifImage(gif, loopCount: -1) // Will loop forever
        } catch {
            print(error)
        }
        
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
            break
            case .pad:
            self.closeBtnHeightConstraint.constant = 35
            self.btnHeightConstraint.constant = 85.0
            self.btnWidthConstraint.constant = 500
            default:
            break
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
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
                    self.monthlyPriceLabel.text = "3 DAYS FREE TRIAL THEN \(product.localizedPrice!)/MON"
                case WEEKLY:
                    self.monthlyPriceLabel.text = "3 DAYS FREE TRIAL THEN \(product.localizedPrice!)/WEEK"
                    
                default:
                    break
                }
            }
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startTrialBtn.shake()
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
            break
            case .pad:
            self.btnHeightConstraint.constant = 85.0
            self.btnWidthConstraint.constant = 500
            default:
            break
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

    @IBAction func startTrial(_ sender: Any) {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.subscribe(WEEKLY) { (result) in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @IBAction func startLifetime(_ sender: Any) {
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
}
extension UIView {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.25
        animation.repeatCount = 100
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
