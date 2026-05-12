//
//  MoreVC.swift
//  MorphMCPE
//
//  Created by son on 6/9/22.
//

import UIKit

class MoreVC: ViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let section1 = ["Premium Access","Privacy Policy","Terms of use"]
    let section2 = ["How to use Skins","How to use Capes","How to use Elytra"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "More"
        tableView.register(UINib(nibName: "MoreTableViewCell", bundle: nil), forCellReuseIdentifier: "MoreTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreTableViewCell", for: indexPath) as! MoreTableViewCell
        if indexPath.section == 0{
            cell.itemLabel.text = section1[indexPath.row]
        }else{
            cell.itemLabel.text = section2[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Store"
        }else{
            return "How to?"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            switch indexPath.row {
            case 0:
                let vc = StoreVC2()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            case 1:
                let vc = WebVC()
                vc.title = "Privacy Policy"
                vc.link = "https://sites.google.com/view/jalistudio/privacy-policy"
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            case 2:
                let vc = WebVC()
                vc.title = "Terms of use"
                vc.link = "https://sites.google.com/view/jalistudio/terms-of-use"
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            default:
                break
            }
        }else{
            switch indexPath.row {
            case 0:
                let vc = HowToUseSkinVC()
                vc.title = "How to use Skin"
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            case 1:
                let vc = HowToUseCapeVC()
                vc.title = "How to use Cape"
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            case 2:
                let vc = HowToUseElytra()
                vc.title = "How to use Elytra"
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 100
        }
    }
}


