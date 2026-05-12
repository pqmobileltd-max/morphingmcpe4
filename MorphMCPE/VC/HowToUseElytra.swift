//
//  HowToUseElytra.swift
//  MorphMCPE
//
//  Created by son on 6/12/22.
//

import UIKit

class HowToUseElytra: UIViewController {
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lastTextView: UITextView!
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
        
        heightConstraint.constant = lastTextView.frame.origin.y + lastTextView.frame.height + 100
    }


}
