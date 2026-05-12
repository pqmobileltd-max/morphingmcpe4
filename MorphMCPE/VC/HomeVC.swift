//
//  HomeVC.swift
//  MorphMCPE
//
//  Created by son on 22/7/25.
//

import UIKit
import MBProgressHUD
class HomeVC: ViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let titleArr = ["Morph Mod","Cool Addons","Free Addons","Capes","Elytras","Skins","More"]
    let imageArr = ["morphIcon","premiumAddonIcon","freeAddonIcon","capeIcon","elytraIcon","skinIcon","skinIcon"]
    
    var isShowStore = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        AppViewModel.shared.getAppValue { value in
//            
//            DispatchQueue.main.async {
//                
//                MBProgressHUD.hide(for: self.view, animated: true)
//                
//            }
//        }
        
        collectionView.backgroundColor = .clear
        

        
        let device = UIScreen.main.traitCollection.userInterfaceIdiom
        if device == .pad{
            self.widthConstraint.constant = 2/3*self.view.bounds.width
        }else{
            self.widthConstraint.constant = self.view.bounds.width
        }
        
        collectionView.register(ImageHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ImageHeaderView.reuseIdentifier)
        
        collectionView.register(MyFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: MyFooterView.reuseIdentifier)


        
        collectionView.register(UINib(nibName: "HomeCell", bundle: nil), forCellWithReuseIdentifier: "HomeCell")
        collectionView.register(UINib(nibName: "MoreCell", bundle: nil), forCellWithReuseIdentifier: "MoreCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.row <= 5{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
            cell.titleLabel.textAlignment = .center
            cell.titleLabel.text = titleArr[indexPath.row]
            cell.thumbImageView.image = UIImage(named: imageArr[indexPath.row])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreCell", for: indexPath) as! MoreCell
            cell.label.textAlignment = .center
            cell.label.text = "MORE"
            cell.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            return cell
        }
       
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row <= 5{
            let size = (collectionView.frame.size.width - 70)/2
            
            return CGSize(width: size, height: size + 60)
        }else{
            return CGSize(width: collectionView.frame.width - 40, height:  60)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            let vc = MorphVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = AddonsVC()
            vc.title = "COOL ADDONS"
            vc.viewModel = PremiumAddonsViewModel
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = AddonsVC()
            vc.title = "FREE ADDONS"
            vc.viewModel = FreeAddonsViewModel
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = CapesVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = ElytraVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = SkinsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 6:
            let vc = MoreVC()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ImageHeaderView.reuseIdentifier,
                for: indexPath
            ) as! ImageHeaderView

//            header.imageView.image = UIImage(named: "yourImageName") // thay bằng ảnh của bạn
            do {
                let gif = try UIImage(gifName: "morphMod.gif")
                header.imageView.setGifImage(gif, loopCount: -1) // Will loop forever
            } catch {
                print(error)
            }
//            header.imageView.image = UIImage(named: "yourImage")
            return header
        }else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MyFooterView.reuseIdentifier,
                for: indexPath
            ) as! MyFooterView
            // Optionally configure footer
            return footer
        }
        fatalError("Unexpected element kind: \(kind)")
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let w = collectionView.frame.width
        let h = 210/376*w
        return CGSize(width: w ,height: h)
    }

}


class ImageHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "ImageHeaderView"

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 20.0),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -20.0)
        ])
        
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class MyFooterView: UICollectionReusableView {
    static let reuseIdentifier = "MyFooterView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        // Add custom UI if needed (e.g., label, button)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
