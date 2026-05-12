//
//  MorphModTutorialVC.swift
//  MorphMCPE
//
//  Created by son on 6/11/22.
//
import GoogleMobileAds
import youtube_ios_player_helper
import UIKit
import WebKit
import MBProgressHUD
class MorphModTutorialVC: ViewController,WKNavigationDelegate,WKUIDelegate {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nativeAdHolderView: UIView!
    var nativeAdView: GADNativeAdView!
    
    @IBOutlet weak var nativeAdHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var ytView: YTPlayerView!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tutorial"
        
        
        //add observer to get estimated progress value
//        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);
//        webView.navigationDelegate = self

        
        
        
        let closebtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeVC))
        self.navigationItem.rightBarButtonItem = closebtn
        
        let nibObjects = Bundle.main.loadNibNamed("NativeAdView", owner: nil, options: nil)!
        let adView = nibObjects.first as! GADNativeAdView
        
        self.setAdView(adView)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if ViewController.nativeAd == nil || AppStore.shared.isUnlockPremium(){
            nativeAdHolderView.isHidden = true
            nativeAdHeightConstraint.constant = 0
        }else{
            nativeAdHolderView.isHidden = false
            let device = UIScreen.main.traitCollection.userInterfaceIdiom
            if device == .pad{
                self.nativeAdHeightConstraint.constant = 400
            }else{
                self.nativeAdHeightConstraint.constant = 300
            }
            self.updateNativeAdView()
        }
        
        
        initWebView()
    }
    
    func getDescription(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        MorphModViewModel.shared.getTutorial { html,youtubeID in
            DispatchQueue.main.async {
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let htmlStr = html{
                    self.webView.loadHTMLString(htmlStr, baseURL: nil)
                }
                
                if let youtubeID = youtubeID{
                    self.ytView.load(withVideoId: youtubeID)
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

        webView = WKWebView(frame: CGRect(x: 0, y: self.ytView.frame.origin.y + self.ytView.frame.height, width: self.view.frame.width, height: h),configuration: wkConfiguration)
        
        webView.backgroundColor = .white
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true
        webView.sizeToFit()
        webView.scrollView.bouncesZoom = false
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        self.mainView.addSubview(webView)
        
        getDescription()
    }
    
    func userContentController() -> WKUserContentController {
        let controller = WKUserContentController()
        controller.addUserScript(viewPortScript())
        return controller
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
        return WKUserScript(source: viewPortScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        

        webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                    
                    print("self.ytView.frame.origin.y=====\(self.ytView.frame.origin.y)")

                    let frame = CGRect(x: 0, y: self.ytView.frame.origin.y + self.ytView.frame.height + 10, width: self.view.frame.width, height: (height as! CGFloat) )
                    
                    self.webView.frame = frame
                    self.webView.backgroundColor = .clear
                    self.heightConstraint.constant = self.ytView.frame.origin.y + self.ytView.frame.height + self.webView.frame.origin.y + self.webView.frame.size.height  + ViewController.bannerView.frame.height + 150
                    
                })
            }
        })
     }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let youtubeAdjust = "var style = document.createElement('style');style.innerHTML = 'iframe { display: inline;height: auto;max-width: 100%; }';document.getElementsByTagName('head')[0].appendChild(style);"

        let hinhAdjust = "var style = document.createElement('style');style.innerHTML = 'img { display: inline;height: auto;max-width: 100%; }';document.getElementsByTagName('head')[0].appendChild(style);"

        let fontsize = "45px"
        let textColor = "black"

        let stringAdjust = "var style = document.createElement('style');style.innerHTML = 'span   {font-size:\(fontsize);color : \(textColor)} h1   {font-size:\(fontsize);color : \(textColor)} h2 {font-size:\(fontsize);color : \(textColor)} h3 {font-size:\(fontsize);color : \(textColor)} h4 {font-size:\(fontsize);color : \(textColor)} h5 {font-size:\(fontsize);color : \(textColor)} p {font-size:\(fontsize);color : \(textColor)} li {font-size:\(fontsize);color : \(textColor)} ';document.getElementsByTagName('head')[0].appendChild(style);"

        webView.evaluateJavaScript(youtubeAdjust)

        webView.evaluateJavaScript(hinhAdjust)

        webView.evaluateJavaScript(stringAdjust)
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
    
    override func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        super.adLoader(adLoader, didReceive: nativeAd)

        let device = UIScreen.main.traitCollection.userInterfaceIdiom
        if device == .pad{
            self.nativeAdHeightConstraint.constant = 400
        }else{
            self.nativeAdHeightConstraint.constant = 300
        }

        self.nativeAdHolderView.isHidden = false
       
        self.updateNativeAdView()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            
            
            print("self.ytView.frame.origin.y====\(self.ytView.frame.origin.y)")
            let frame = CGRect(x: 0, y: self.ytView.frame.origin.y + self.ytView.frame.height + 10, width: self.view.frame.width, height: self.webView.frame.height )

            self.webView.frame = frame
            
            self.webView.backgroundColor = .clear
            
            self.heightConstraint.constant = self.ytView.frame.origin.y + self.ytView.frame.height + self.webView.frame.origin.y + self.webView.frame.size.height  + ViewController.bannerView.frame.height + 150
            
            self.mainView.setNeedsLayout()
        }
        
    }

    func setAdView(_ view: GADNativeAdView) {
      nativeAdView = view
      nativeAdHolderView.addSubview(view)
      nativeAdView.translatesAutoresizingMaskIntoConstraints = false

      // Layout constraints for positioning the native ad view to stretch the entire width and height
      // of the nativeAdPlaceholder.
      let viewDictionary = ["_nativeAdView": nativeAdView!]
      self.view.addConstraints(
        NSLayoutConstraint.constraints(
          withVisualFormat: "H:|[_nativeAdView]|",
          options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
      )
      self.view.addConstraints(
        NSLayoutConstraint.constraints(
          withVisualFormat: "V:|[_nativeAdView]|",
          options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)
      )
    }
    
    func updateNativeAdView(){
        (nativeAdView.headlineView as? UILabel)?.text = ViewController.nativeAd.headline
        (nativeAdView.headlineView as? UILabel)?.textColor = .black
        nativeAdView.mediaView?.mediaContent = ViewController.nativeAd.mediaContent

        
        nativeAdView.callToActionView?.isHidden = ViewController.nativeAd.callToAction == nil

        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false

        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = ViewController.nativeAd
    }
}
