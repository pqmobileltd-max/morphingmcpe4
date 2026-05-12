//
//  AddonsVC.swift
//  MorphMCPE
//
//  Created by son on 22/7/25.
//
import MBProgressHUD
import UIKit

class AddonsVC: ViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel : AddonViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "AddonCell", bundle: nil), forCellWithReuseIdentifier: "AddonCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if viewModel.modArray.count == 0{
            fetchData()
        }
    }

    private func fetchData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        viewModel.fetchingData {
            self.collectionView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.modArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddonCell", for: indexPath) as! AddonCell
        let addon = viewModel.modArray[indexPath.row]
        cell.updateCell(addon: addon)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (collectionView.frame.width - 35)/2
        let h = 281/500*w + 60
        return CGSize(width: w, height: h)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            if viewModel.reachingLast == false{
                fetchData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if UserDefaults.isRateApp == false, AppViewModel.shared.app_ctrl == true{
            let r = Int.random(in: 1...4)
            if r == 2{
                self.rateApp()
                return
            }
        }
        
        let addon = viewModel.modArray[indexPath.row]
        let vc = AddonDetailVC()
        vc.addon = addon
        
        if addon.modType == "ADDON" , AppStore.shared.isUnlockPremium() == false,indexPath.row % 3 == 1{
            vc.needWatchAd = true
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
