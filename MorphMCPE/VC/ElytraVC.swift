//
//  ElytraVC.swift
//  MorphMCPE
//
//  Created by son on 6/9/22.
//

import UIKit
import MBProgressHUD
import WebKit
import SDWebImage
import StoreKit
class ElytraVC: ViewController,WKNavigationDelegate {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    let icon_prefix = "ELYTRA/icons/"
    let skin_prefix = "ELYTRA/skins/"
    
    var isWalk = true
    
    @IBOutlet weak var fly_walk_Btn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var webView: WKWebView!
    
    static var skinImage : UIImage! = UIImage(named: "alex")!
    
    var skin : Skin?
    
    var selectedCapeName = ""
    
    var thumbArr = ["akronman1_Cape_Elytra_1mil_Customer_Cape_Reshaded","angel_elytra 1","Angel_elytra","Atmeal245_Elytra","banana","Blue_angel_Elytra","broken_dragon_elytra","broken_elytra","butterfly_elytra","Buzz_Lightyear_Elytra","Candy_Cane_Elytra","Cape_compatable_elytra_dragon_wings","Charizard_elytra","Cobalt_Cape_Elytra_Remastered_and_Reshaded_V2","Cold_Fire_Elytra","Cool_Texture_MCPE_Elytra","creeper_elytra","Crow_Raven_Goth_Gothic_Wings_Elytra","dannyBstyle_Cape_Elytra_Remastered_Reshaded","die_elytra","dinastia_2_elytra","Dragonfly_Wings_Elytra","elytra 2","elytra 3","elytra 4","elytra 5","elytra 6","elytra 7","Elytra 8","elytra 9","elytra 10","elytra 11","elytra 12","elytra 13","elytra 14","elytra 15","elytra 16","elytra 17","elytra 18","Elytra 19","elytra 20","elytra 21","elytra 22","elytra 23","Elytra 25","elytra_1_bearbeitet","Elytra_3d_Galaxy","elytra_dani_pack","elytra_de_agua_y_fuego","elytra_dragon","elytra_fly","elytra_love_love_3","Elytra_modern_Piglin_Alliance","Elytra_Oficial","Elytra_Remastered_Reshaded","elytra","Ender_Dragon_Elytra_Wings","endersanyarcraft_elytra","EskiMojo14_Optifine_Cape_Elytra","Fire_Cape_Elytra","Fire_Elytra","Flower_Elytra","Frayed_Spidey_Elytra","frost_wings_elytra_2_0","Ghost_Cloak_Cape_Elytra_Minecraft_Dungeons","Hawks_elytra","heart_elytra","Infinity_Elytra","J0wsper_Rainbow_Optifine_Cape_Elytra","Jiingy_Optifine_Cape_Elytra","lgbq_elytra","Magma_Elytra","Mario_1_Up_Mushroom_Migrator_Migration_Cape_Elytra","mcpe_elytra","Mechanic_Crimson_Dragon_Elytra_Wings","Microsoft_Migration_cape_Elytra","Migration_Cape_Elytra_Improved","min_elytra","Minecon_2020_Cape_Elytra","Minecraft_1_8_Veteran_Cape_Guardian_Elytra","Minecraft_1_17_Part_1_Veteran_Cape_Glow_Squid_Cape_Elytra","Minecraft_1_17_Part_1_Veteran_Cape_Oxidized_Copper_Cape_Elytra","Minecraft_Alpha_Veteran_Cape_Elytra","Minecraft_Cake_Cape_Elytra","Minecraft_Dungeons_Grass_block_Cape_Elytra","Minecraft_Dungeons_Phantom_Cape_Phantom_Elytra","Minecraft_Dungeons_The_Nameless_One_Cape_Elytra","Mob_Vote_2021_Allay_Cape_Elytra","Mojira_Moderator_Cape_Elytra_Redone","my_elytra","nature_elytra","new_elytra_123423","Nivenny_Elytra_Belfegor","Nivenny_Elytra_Helfheim","Nivenny_Elytra_Mayfair","ominisexual_dragon_elytra","Pane_Glass_Cape_Elytra","Parrot_Wings_Elytra","Penguin_s_Elytra","phantom_elytra 2","Phantom_Elytra","Phoenix_Elytra","Rainbow_Elytra 2","rainbow_elytra 3","rainbow_elytra_entity","rainbow_elytra","rainbow_pride_cape_wiht_elytra","rainimator_elytra","Red_Dragon_Wing_Elytra","Scrolls_Cape_Elytra_Redone","Solar_Elytra","SPIRMAN_HOMECOMING_elytra","Steampunk_Elytra 2","Steampunk_Elytra","sylvonia_elytra","Thaumcraft_Cape_Elytra_Stoplights","The_Warden_Cape_Elytra","Trans_Transgender_Pride_Flag_Elytra","Unused_Minecon_2011_Cape_Elytra","Vampire_Elytra_Wings","Wingsuit_Elytra","ZenW_Optifine_Cape_Elytra"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ELYTRA"
        
//        fly_walk_Btn.layer.borderWidth = 1.5
//        fly_walk_Btn.layer.borderColor = UIColor.white.cgColor
        
        fly_walk_Btn.addTarget(self, action: #selector(changeSteveAction), for: .touchUpInside)
        
        webView.navigationDelegate = self
        webView.backgroundColor = .clear
        webView.isOpaque = false
        
        collectionView.register(UINib(nibName: "SkinCell", bundle: nil), forCellWithReuseIdentifier: "SkinCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.init3DViewer()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AppStore.shared.isUnlockPremium(){
            bottomConstraint.constant = 0
        }else{
            bottomConstraint.constant = ViewController.bannerView.frame.height
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        SKStoreReviewController.requestReview()
//    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MBProgressHUD.hide(for: self.view, animated: true)
        
    }

    @objc func changeSteveAction(){
        isWalk = !isWalk
        
        if isWalk{
            fly_walk_Btn.setTitle("FLY", for: .normal)
            webView.evaluateJavaScript("run()", completionHandler: nil)
        }else{
            fly_walk_Btn.setTitle("WALK", for: .normal)
            webView.evaluateJavaScript("fly()", completionHandler: nil)
        }
    }
    
    
    func init3DViewer(){
        let url = Bundle.main.url(forResource: "/3D/index", withExtension: "html")
        let req = URLRequest(url: url!)
        self.webView.navigationDelegate = self
        self.webView.load(req)
        webView.evaluateJavaScript("reloadElytra()", completionHandler: nil)
    }
    
    func loadSkinIn3D(){
        if let skin = self.skin?.skin{
            
            if let data = skin.pngData(){
                let base64 = data.base64EncodedString(options: .endLineWithLineFeed)
                webView.evaluateJavaScript("loadSkin('data:image/png;base64,\(base64)')", completionHandler: nil)
            }
        }
        
        
    }
    
    func viewElytrIn3D(_ cape : UIImage){
        webView.evaluateJavaScript("reloadElytra()", completionHandler: nil)
        if let data = cape.pngData(){
            let base64 = data.base64EncodedString(options: .endLineWithLineFeed)
            webView.evaluateJavaScript("loadCape('data:image/png;base64,\(base64)')", completionHandler: nil)
        }
    }
    
    
    @IBAction func installAction(_ sender: Any) {
        
        if AppStore.shared.isUnlockPremium() == false{
            let vc = StoreVC2()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            return
        }
        
        if let capeThumb = UIImage(named: "\(icon_prefix)\(self.selectedCapeName)"), let capeSkin = UIImage(named: "\(skin_prefix)\(self.selectedCapeName)"){
            
            
            FileHelper.copyDefaultPack(name: "cape")
            
            FileHelper.createCapeSkin(cape: capeSkin)
            
            FileHelper.creatPackIcon(icon: capeThumb,folder: "cape")
            
            FileHelper.createCapeManifestFile(name: self.selectedCapeName)
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            DispatchQueue.main.async {
                
                if let packFile = FileHelper.zip(mod_name : self.selectedCapeName,folder: "cape",progress: nil){
                    
                    let activityVC = UIActivityViewController(activityItems: [packFile], applicationActivities: nil)
                    if let popOver = activityVC.popoverPresentationController {
                        popOver.sourceView = sender as! UIButton
                    }

                    self.present(activityVC, animated: true){
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
            
        }
    }
    
}
extension ElytraVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkinCell", for: indexPath) as! SkinCell
        let thumb = thumbArr[indexPath.row]
        
        cell.skinImageView.contentMode = .scaleAspectFit
        cell.skinImageView.image = UIImage(named: "\(icon_prefix)\(thumb)")
        
        if indexPath.row % 10 == 1{
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
        func view3D(){
            self.selectedCapeName = thumbArr[indexPath.row]
            
            let cape = UIImage(named: "\(skin_prefix)\(self.selectedCapeName)")
            
            viewElytrIn3D(cape!)
        }
        
        if AppStore.shared.isUnlockPremium(){
            view3D()
            return
        }
        
        if indexPath.row % 10 == 1{
            showRewardedAd {
                view3D()
            }
        }else{
            showInterstitialAds()
            view3D()
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
