//
//  WebViewController.swift
//  Word Unscrambler
//
//  Created by Satish Boggarapu on 10/14/16.
//  Copyright © 2016 Satish Boggarapu. All rights reserved.
//

import UIKit
import GoogleMobileAds

class WebViewController: UIViewController, GADBannerViewDelegate {

    // MARK: Properties
    
    var webView: UIWebView!
    var adBannerView: GADBannerView!
    
    var word: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = UIWebView()
        view.addSubview(webView)
        
        adBannerView = GADBannerView(adSize: kGADAdSizeBanner)
        adBannerView.adUnitID = "ca-app-pub-6364543110450580/1349792967"
        adBannerView.delegate = self
        adBannerView.rootViewController = self
        self.view.addSubview(adBannerView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: webView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: adBannerView)
        view.addConstraintsWithFormat(format: "V:|[v0][v1(65)]|", views: webView, adBannerView)
        
        adBannerView.load(GADRequest())
        
        // Do any additional setup after loading the view.
        let urlstring = "http://www.dictionary.com/browse/" + word!
        let url = URL(string: urlstring)
        let requestObj = URLRequest(url: url!)
        print(requestObj)
        webView.loadRequest(requestObj)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Fail to recieve ads")
        print(error)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */


}
