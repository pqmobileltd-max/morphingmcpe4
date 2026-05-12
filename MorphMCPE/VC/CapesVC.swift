//
//  CapesVC.swift
//  MorphMCPE
//
//  Created by son on 6/9/22.
//

import UIKit
import MBProgressHUD
import WebKit
import SDWebImage

class CapesVC: ViewController,WKNavigationDelegate {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    let icon_prefix = "CAPES/icons/"
    let skin_prefix = "CAPES/skins/"

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var webView: WKWebView!
    
    static var skinImage : UIImage! = UIImage(named: "background")!
    
    var skin : Skin?
    
    var selectedCapeName = ""
    
    var thumbArr = ["Acacia Leaves","Adorable Bunny Girl","Adventure_Time_BMO_Cape_HD","Adviser cape","among us 2","AMONG US","among_us","anime 2","anime girl 2","anime","AntiAc Badlion Cape","asuna","Autumn Tree Lunar","Axolotl Cape","Axolotl","BADLION 14 Dino","BADLION 15","BastiGHG ZickZack V3","BedlessNoob Badlion","Berry","Birthday Cape","Bucket of Axolotl","Calvin Blue Lunar","cape","Cape157","captainpuffy Rainbow","Caracal KF3","cat","cat2","Chesticuffs Cape","Christmas_Stocking_Xmas_Cape","Command Block","Cookie Cape","Cross bow","Cross Lunar","CRYSTAL TOKYO","Cute bears","Cyan - Green Cape Elytra 2","Dear in forest Cape","Demon_King_Cape","devil____","devil2","devil3","Diamond Sword","Dino","DNA_Cape","Doge Lunar","Downpour_Cape_Minecraft_Dungeons","Dragon Cape","Duck Cape","Easter cape","Easter eggs cloak","Enchanted Totem","Enderman winged cape","Enderman_Migration_Migrator_Cape_Elytra","Festive Snowflake","Fezzy Badlion","Fire Cape","Fire Dragon","Fire Fenix Cape","Frog_Cape","Gemstone Blue Cape","glass","Goku Cape 2","Graffiti cape","green torn elven cap","Gryffindor","Guardian Cape","Halloween Scary Monster Cape","HALLOWTITCH","Hollow Knight Hornet","Hypixel","Ice Fire Creeper","Jiingys custom OF","JoungGengar","Kakashi Hatake","Kamui","karton","Kawaii Pastel Bear","King_Crown_Cape_Royal","Lava Lunar","Lava Volcano Nether Cape","LManburg Flag DSMP","lolitsalexkoifish","LoneWolf Community","looshy cat anim","Luck_Bunnies_cape","LUFFY SIMPLE","Lunar comics cape 2","Lunar comics cape","Lunar Dolphin","Lunar Ghost","Lunar Halloween Cape","Lunar Refraction Per","Lunar Sword","Lunar USA","LunarClient Walter","Maccarita cape","Magma Cube","Magma HD Blackstone","magma","Mantle Axolotl Cape","McdPhantomcapelytras","McDungeons Hero Cape","Minecraft Dungeons","Mio Naruse","Mojira_Moderator_Cape_Reshaded_New","Monalisa cape","Mountain Lunar","Mystery_Cape_Minecraft_Dungeons","NameMc_Early_Supporter_Cape","Neon Slime Cape","Nether Lunar","Nether Portal","Nezuko Galaxy cape","Nezuko","Nihon","Omega","One Piece","ori","PhantomWings","pi","Pikape","Planet Minecraft","Pokemon Master Ball Cape","Premium lag","Pride Cape","Princess Crown Flower Petals Cape","Pug Cape","PURPLE 1","Purple Migration V2","Purple_Gold_Crown_King_Cape","rain cape","Rainbow Cape","Rainbow Gay Pride Llama","Rainbow Heart Undertale Cape Clouds","Rainbow Minecon cape","rainbow","Rem","Rimuru 2","Rimuru","Rune Magic Cape Elytra","Samurai Lunar","shark","Sitama","Skull With cool Back","Snacky Panda","Snowflake Lunar","Snowflake Snow Cape","Space Theme Cape","SpeedSilverRedLunar","Stimpy Lunar","Strawberry Cake","SuchSpeed Lava New","SuchSpeed Old","Sword Cape","The Flash Cape","Therealokin_Optifine_Cape","Tiger Cape","Tiny Ender Dragon","Tiny Ice Dragon","Totoro_YellowHeart","Touhou Kogasa Tatara","Touhou Reimu Hakurei","UwU cape","Warden","Wolf Cape Silver","Wolf cape","Woop On Da Beach","wooperTM","Ying Yang Cape","yuseiredcrow byNevee","Zero Two"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CAPES"
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
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MBProgressHUD.hide(for: self.view, animated: true)
//        loadSkinIn3D()
    }

    
    
    func init3DViewer(){
        let url = Bundle.main.url(forResource: "/3D/index", withExtension: "html")
        let req = URLRequest(url: url!)
        self.webView.load(req)
    }
    
    func loadSkinIn3D(){
        if let skin = SkinsVC.skinImage{
            if let data = skin.pngData(){
                let base64 = data.base64EncodedString(options: .endLineWithLineFeed)
                webView.evaluateJavaScript("loadSkin('data:image/png;base64,\(base64)')", completionHandler: nil)
            }
        }
    }
    
    func viewCapeIn3D(_ cape : UIImage){
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
extension CapesVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
            
            viewCapeIn3D(cape!)
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
