//
//  TabBarController.swift
//  MorphMCPE
//
//  Created by son on 6/8/22.
//

import UIKit
import MBProgressHUD
class TabBarController: UITabBarController {

    var isShowStore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        AppViewModel.shared.getAppValue { value in
//            
//            DispatchQueue.main.async {
//                self.initTabBar()
//                MBProgressHUD.hide(for: self.view, animated: true)
//                
//            }
//        }
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
    }
    
    func initTabBar(){
        let skinVC = SkinsVC()
        skinVC.tabBarItem = UITabBarItem.init(title: "Free Skins", image: UIImage(named: "skinItem"), tag: 0)
        
        let capesVC = CapesVC()
        capesVC.tabBarItem = UITabBarItem.init(title: "Capes", image: UIImage(named: "capeItem"), tag: 0)
        
        let morphVC = MorphVC()
        morphVC.tabBarItem = UITabBarItem.init(title: "MORPH", image: UIImage(named: "morphItem"), tag: 0)
        
        let elytraVC = ElytraVC()
        elytraVC.tabBarItem = UITabBarItem.init(title: "Elytra", image: UIImage(named: "elytraItem"), tag: 0)
        
        let moreVC = MoreVC()
        moreVC.tabBarItem = UITabBarItem.init(title: "More", image: UIImage(named: "moreItem"), tag: 0)
        
        let moreNav = UINavigationController(rootViewController: moreVC)
        moreNav.title = "More"
        
        self.viewControllers = [skinVC,capesVC,morphVC,elytraVC,moreNav]
        
        self.selectedIndex = 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showStore()
    }
    
    func showStore(){
        if isShowStore == false, AppStore.shared.isUnlockPremium() == false{
            let vc = StoreVC2()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            isShowStore = true
        }
    }

}
