//
//  AddonDetailVC.swift
//  MorphMCPE
//
//  Created by son on 22/7/25.
//

import WebKit
import UIKit
import SDWebImage
import Alamofire
import MBProgressHUD
import GoogleMobileAds

class AddonDetailVC: ViewController,UIScrollViewDelegate,WKNavigationDelegate {
    
    var webView: WKWebView!
    
    @IBOutlet weak var downloadBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var addon : Addon!
    
    var needWatchAd = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let device = UIScreen.main.traitCollection.userInterfaceIdiom
        if device == .pad{
            self.downloadBtnHeightConstraint.constant = 65
        }
        
        self.title = addon.title

        thumbnailImageView.sd_setImage(with: URL(string: addon.thumbnailURL!), completed: nil)
        
        titleLabel.text = addon.title
        titleLabel.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.initWebView()
        }
        
        if addon.modType == "PREMIUM"{
            if AppStore.shared.isUnlockPremium(){
                downloadBtn.setTitle("DOWNLOAD", for: .normal)
            }else{
                downloadBtn.setTitle("UNLOCK", for: .normal)
            }
        }else{
            
            if needWatchAd == false{
                downloadBtn.setTitle("DOWNLOAD", for: .normal)
            }else{
                downloadBtn.setTitle("WATCH AD TO INSTALL", for: .normal)
            }
            
        }
        
        downloadBtn.addTarget(self, action: #selector(downloadBtnPress), for: .touchUpInside)
        
    }
    
    @objc func downloadBtnPress(){
        if addon.modType == "PREMIUM"{
            if AppStore.shared.isUnlockPremium(){
                downloadAddon()
            }else{
                let vc = StoreVC2()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }else{
            if needWatchAd == false{
                downloadAddon()
            }else{
                showRewardedAd {
                    self.needWatchAd = false
                }
            }
        }
    }
    
    
    func initWebView(){
        if webView != nil{
            return
        }
        heightConstraint.constant = self.view.frame.height
        
        let wkConfiguration = WKWebViewConfiguration()
        wkConfiguration.userContentController = userContentController()
        
        let h = self.view.frame.height * 2

        webView = WKWebView(frame: CGRect(x: 10, y: self.titleLabel.frame.origin.y + self.titleLabel.frame.height + 30, width: self.view.frame.width - 20, height: h),configuration: wkConfiguration)
        
        webView.backgroundColor = .clear
        webView.isOpaque = false
//        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        webView.sizeToFit()
        webView.scrollView.bouncesZoom = false
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.navigationDelegate = self
        
        self.mainView.addSubview(webView)
        
       // self.parentView.bringSubviewToFront(self.downloadBtn)

        if let html = self.addon.detail{
            DispatchQueue.main.async {
                self.loadHtml(htmlString: html)
            }
            
        }
        
        
    }
    func viewPortScript() -> WKUserScript {
        let viewPortScript = """
        var meta = document.createElement('meta');
        meta.setAttribute('name', 'viewport');
        meta.setAttribute('content', 'width=device-width');
        meta.setAttribute('initial-scale', '1.0');
        meta.setAttribute('maximum-scale', '1.0');
        meta.setAttribute('minimum-scale', '1.0');
        meta.setAttribute('user-scalable', 'no');
        document.getElementsByTagName('head')[0].appendChild(meta);
    """
        return WKUserScript(source: viewPortScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    func userContentController() -> WKUserContentController {
        let controller = WKUserContentController()
        controller.addUserScript(viewPortScript())
        return controller
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (keyPath == "estimatedProgress") {
            
           // progressView.isHidden = webView.estimatedProgress == 1
          //  progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
        }
    }
    
    func loadHtml(htmlString : String){
        let newString = htmlString.replacingOccurrences(of: "img data-src", with: "img src")
        webView.loadHTMLString(newString, baseURL: nil)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        let youtubeAdjust = "var style = document.createElement('style');style.innerHTML = 'iframe { display: inline;height: auto;max-width: 100%; }';document.getElementsByTagName('head')[0].appendChild(style);"
        
        let hinhAdjust = "var style = document.createElement('style');style.innerHTML = 'img { display: inline;height: auto;max-width: 100%; }';document.getElementsByTagName('head')[0].appendChild(style);"
        
        let fontsize = "30px"
        
        let stringAdjust = "var style = document.createElement('style');style.innerHTML = 'h1   {font-size:\(fontsize);color : white} h2 {font-size:\(fontsize);color : white} h3 {font-size:\(fontsize);color : white} h4 {font-size:\(fontsize);color : white} h5 {font-size:\(fontsize);color : white} p {font-size:\(fontsize);color : white} li {font-size:\(fontsize);color : white} ';document.getElementsByTagName('head')[0].appendChild(style);"
        
        webView.evaluateJavaScript(youtubeAdjust)
        
        webView.evaluateJavaScript(hinhAdjust)
        
        webView.evaluateJavaScript(stringAdjust)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
                    if complete != nil {
                        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in

                            let frame = CGRect(x: 0, y: self.titleLabel.frame.origin.y + self.titleLabel.frame.height + 30, width: self.view.frame.width, height: (height as! CGFloat) )
                            
                            self.webView.frame = frame
                            webView.backgroundColor = .clear
                            
                            self.heightConstraint.constant = self.webView.frame.origin.y + self.webView.frame.size.height  + 150
                            
                        })
                    }
                })
     }
    
    func downloadAddon(){
        if let urlString = addon.fileURL,let url = URL(string: urlString){
            
            let destination: DownloadRequest.Destination = { _, _ in
                       var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent("\(self.addon.title!).\(self.addon.fileExtension)")
                       return (documentsURL, [.removePreviousFile])
                   }
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            AF.download(url, to: destination).responseData { response in
                if let destinationUrl = response.fileURL {
                   print("destinationUrl \(destinationUrl)")
                    
                    self.install(path: destinationUrl, installBtn: self.downloadBtn)
                    
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                }
            }

        }
    }
    
    func install(path : URL,installBtn : UIButton){
        let paths = [path]
        DispatchQueue.main.async {
            
            let activity = UIActivityViewController(activityItems: paths, applicationActivities: nil)
            self.present(activity, animated: true, completion: nil)
            
            if let popOver = activity.popoverPresentationController{
                popOver.sourceView = installBtn
                popOver.sourceRect = installBtn.frame
            }
        }
    }
}
