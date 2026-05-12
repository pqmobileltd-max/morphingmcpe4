//
//  MorphDetailVC.swift
//  MorphMCPE
//
//  Created by son on 6/13/22.
//
import GoogleMobileAds
import MBProgressHUD
import UIKit
import Alamofire
class MorphDetailVC: ViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var nativeAdHolderView: UIView!
    var nativeAdView: GADNativeAdView!
    @IBOutlet weak var nativeAdHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    let freeImages = ["bee","cat","chicken","cow","pig","sheep"]
    let vipImages = ["axolotl","bat","bee","blaze","cat","chicken","cow","creeper","drowned","enderman","fox","ghast","horse","husk","iron_golem","pig","sheep","shulker","skeleton","slime","snow_golem","spider","stray","vex","villager","witch","wither_skeleton","wolf","zombie_pigman","zombie"]
    
    var data : [String] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    var isVIP = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isVIP == false{
            data = freeImages
            titleLabel.text = "FREE MORPH PACK"
            descriptionTextView.text = "This morph pack allows you to morph into 6 mobs : Bee, Cat, Chicken, Cow, Pig, Sheep."
        }else{
            titleLabel.text = "PREMIUM MORPH PACK"
            data = vipImages
            descriptionTextView.text = "This pack allows you to morph into 30 mobs : axolotl, bat, bee, blaze, cat, chicken, cow, creeper, drowned, enderman, fox, ghast, horse, husk, iron_golem, pig, sheep, shulker, skeleton, slime, snow_golem, spider, stray, vex, villager, witch, wither_skeleton, wolf, zombie_pigman, zombie,axolotl,bat,bee,blaze,cat,chicken,close,cow,creeper,drowned,enderman,fox,ghast,horse,husk,iron_golem,normal,pig,sheep,shulker,skeleton,slime,snow_golem,spider,stray,vex,villager,witch,wither_skeleton,wolf,zombie_pigman,zombie."
        }

        collectionView.register(UINib(nibName: "SkinCell", bundle: nil), forCellWithReuseIdentifier: "SkinCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if nativeAdView == nil{
            let nibObjects = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil)!
            let adView = nibObjects.first as! GADNativeAdView
            
            self.setAdView(adView)
            
            if ViewController.nativeAd == nil || AppStore.shared.isUnlockPremium(){
                nativeAdHolderView.isHidden = true
                nativeAdHeightConstraint.constant = 0
            }else{
                let device = UIScreen.main.traitCollection.userInterfaceIdiom
                if device == .pad{
                    self.nativeAdHeightConstraint.constant = 400
                }else{
                    self.nativeAdHeightConstraint.constant = 300
                }
                
                self.updateNativeAdView()
                
            }
        }
        
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
            let w = (self.collectionView.frame.size.width - 45)/3.0
            let t = self.data.count/3
            let d = w * CGFloat(t) + w
            
            self.collectionViewHeightConstraint.constant = d
            
            self.heightConstraint.constant = self.collectionView.frame.origin.y + d + 90.0 + 100.0
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let w = (collectionView.frame.size.width - 45)/3.0
        let t = data.count/3
        let d = w * CGFloat(t) + w
        
        collectionViewHeightConstraint.constant = d
        
        heightConstraint.constant = collectionView.frame.origin.y + d + 90.0 + 100.0
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkinCell", for: indexPath) as! SkinCell
        cell.backgroundColor = .clear
        cell.skinImageView.image = UIImage(named: data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let w = (collectionView.frame.size.width - 45)/3
        let h = w
        return CGSize(width: w, height: h)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    @IBAction func installAction(_ sender: Any) {
        
        if isVIP{
            if AppStore.shared.isUnlockPremium(){
//                MBProgressHUD.showAdded(to: self.view, animated: true)
//                self.downloadPack(packName: "PREMIUM"){ url in
//                    DispatchQueue.main.async {
//                        MBProgressHUD.hide(for: self.view, animated: true)
//                        if let url = url{
//                            self.install(url, sender)
//                        }
//                    }
//                    
//                }
                
                if let fileURL = Bundle.main.url(forResource: "morph_vip", withExtension: "mcaddon") {
                    print("File path: \(fileURL)")
                    self.install(fileURL, sender)
                }
            }else{
                let vc = StoreVC2()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                return
            }
        }else{
//            MBProgressHUD.showAdded(to: self.view, animated: true)
//            self.downloadPack(packName: "FREE"){ url in
//                DispatchQueue.main.async {
//                    MBProgressHUD.hide(for: self.view, animated: true)
//                    if let url = url{
//                        self.install(url, sender)
//                    }
//                }
//                
//            }
            
            if let fileURL = Bundle.main.url(forResource: "morph_free", withExtension: "mcaddon") {
                print("File path: \(fileURL)")
                self.install(fileURL, sender)
            }
        }
        
        
    }
    
    func install(_ url : URL,_ sender: Any){
//        let file = Bundle.main.url(forResource: packName, withExtension: "mcaddon")!
        
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if let popOver = activityVC.popoverPresentationController {
            popOver.sourceView = sender as! UIButton
        }

        self.present(activityVC, animated: true){}
    }
    
    func downloadPack(packName : String!,completion : @escaping (URL?) -> ()){
       
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        MorphModViewModel.shared.getDownloadLink(namePack: packName) { link in
           
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            if let link = link{
                self.download(link: link) { url in
                    completion(url)
                }
            }
        }
    }
    func download(link : String,completion : @escaping (URL?) -> ()){
        
        let fileName = "MorphMod.mcaddon"
       
        if let url = URL(string: link){
            let destination: DownloadRequest.Destination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent(fileName)
                        return (documentsURL, [.removePreviousFile])
            }

            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
            
            
            AF.download(url, to: destination).responseData { response in
               
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                
                if let destinationUrl = response.fileURL {
                    completion(destinationUrl)
                }else{
                    completion(nil)
                }
            }
        }
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
}
