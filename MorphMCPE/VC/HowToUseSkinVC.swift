//
//  HowToUseSkinVC.swift
//  MorphMCPE
//
//  Created by son on 6/12/22.
//

import UIKit

class HowToUseSkinVC: UIViewController {

    @IBOutlet weak var lastStepImg: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closebtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeVC))
        self.navigationItem.rightBarButtonItem = closebtn
    }

    @objc func closeVC(){
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        heightConstraint.constant = lastStepImg.frame.origin.y + lastStepImg.frame.height + 100
    }

}
