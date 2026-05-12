//
//  WebVC.swift
//  MorphMCPE
//
//  Created by son on 6/12/22.
//

import UIKit
import WebKit

class WebVC: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var progressView: UIProgressView!
    var link = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);

        let request = URLRequest(url: URL(string: link)!)
        webView.load(request)
        
        let closebtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeVC))
        self.navigationItem.rightBarButtonItem = closebtn
    }

    @objc func closeVC(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(self.webView.estimatedProgress);
            self.progressView.progress = Float(self.webView.estimatedProgress);
            
            if self.progressView.progress == 1.0{
                self.progressView.isHidden = true
            }
        }
    }
}
