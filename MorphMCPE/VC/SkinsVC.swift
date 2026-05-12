//
//  SkinsVC.swift
//  MorphMCPE
//
//  Created by son on 6/8/22.
//
import Photos
import UIKit
import MBProgressHUD
import WebKit
import SDWebImage
import StoreKit
import GoogleMobileAds

class SkinsVC: ViewController,WKNavigationDelegate {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let viewModel = SkinVM(url: "https://namemc.com/minecraft-skins/new")

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var webView: WKWebView!
    
    static var skinImage : UIImage! = UIImage(named: "steve")!
    
    var skin : Skin?
    
    var isInit3DView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SKINS"
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.navigationDelegate = self
        
        collectionView.register(UINib(nibName: "SkinCell", bundle: nil), forCellWithReuseIdentifier: "SkinCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchSkinData()
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SKStoreReviewController.requestReview()
        
        if AppStore.shared.isUnlockPremium(){
            bottomConstraint.constant = 0
        }else{
            bottomConstraint.constant = ViewController.bannerView.frame.height
        }
        
        
        if isInit3DView == false{
            isInit3DView = true
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.init3DViewer()
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

    func fetchSkinData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.fetchSkins {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                self.collectionView.reloadData()
                
            }
        }
    }
    
    func init3DViewer(){
        let url = Bundle.main.url(forResource: "/3D/index", withExtension: "html")
        let req = URLRequest(url: url!)
        self.webView.load(req)
        
    }
    
    func viewSkinIn3D(){
        if let skin = self.skin?.skin{
            SkinsVC.skinImage = skin
            if let data = skin.pngData(){
                let base64 = data.base64EncodedString(options: .endLineWithLineFeed)
                webView.evaluateJavaScript("loadSkin('data:image/png;base64,\(base64)')", completionHandler: nil)
            }
        }
    }
    @IBAction func downloadSkin(_ sender: Any) {
        
        if checkPermission() == false{
            return
        }
        
        if let skin = self.skin?.skin{
            UIImageWriteToSavedPhotosAlbum(skin, self, #selector(finishSavingSkin), nil)
        }
    }
    
    func checkPermission() -> Bool {
      
        let photos = PHPhotoLibrary.authorizationStatus()
        
        switch photos {
        case .notDetermined:

            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                
                }else {
                    
                }
            })
            return false
            
        case .denied:
            self.openSettingAlert()
            return false
        case .authorized:
            return true
        case .restricted,.limited:
            return true
        default:
            return false
        }
    }
    
    func openSettingAlert(){
        let alert = UIAlertController(title: "Grant Permission", message: "To save this skin, please open Settings and grant permission for this app to access to your Photo Library!", preferredStyle: .alert)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .cancel) { _ in
            self.gotoAppPrivacySettings()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(openAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func gotoAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url) else {
                assertionFailure("Not able to open App privacy settings")
                return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func saveSkinAlert(){
        let alert = UIAlertController(title: "DONE!", message: "This skin was saved to your Photo Library successfully!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel){ _ in
            SKStoreReviewController.requestReview()
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func finishSavingSkin(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        saveSkinAlert()
    }
}
extension SkinsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.skinArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkinCell", for: indexPath) as! SkinCell
        let skin = viewModel.skinArr[indexPath.row]
        
        cell.skinImageView.sd_setImage(with: URL(string: skin.iconSkinURL), completed: nil)
        
        if indexPath.row % 6 == 1{
            cell.watchAdView.isHidden = false
        }else{
            cell.watchAdView.isHidden = true
        }
        
        if AppStore.shared.isUnlockPremium(){
            cell.watchAdView.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if UserDefaults.isRateApp == false, AppViewModel.shared.app_ctrl == true{
            let r = Int.random(in: 1...4)
            if r == 2{
                self.rateApp()
                return
            }
        }
        
        func viewSkin(){
            self.skin = viewModel.skinArr[indexPath.row]

            if let _ = self.skin?.skin{
                viewSkinIn3D()
            }else{
                MBProgressHUD.showAdded(to: self.view, animated: true)
                self.skin?.downloadSkin(self.skin!.skinURL, completion: { image in
                    DispatchQueue.main.async {
                        self.viewSkinIn3D()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }

                })
            }
        }
        
        if AppStore.shared.isUnlockPremium(){
            viewSkin()
            return
        }
        
        if indexPath.row % 6 == 1{
            self.showRewardedAd {
                viewSkin()
            }
        }else{
            showInterstitialAds()
            viewSkin()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            showInterstitialAds()
            fetchSkinData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var w = (collectionView.frame.size.width - 50)/3
        
        switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                w = (collectionView.frame.size.width - 50)/3
            case .pad:
                w = (collectionView.frame.size.width - 60)/4
            default:
                w = (collectionView.frame.size.width - 50)/3
        }
        
        let h = 576/378*w
        return CGSize(width: w, height: h)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
