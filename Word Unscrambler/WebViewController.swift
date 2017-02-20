//
//  WebViewController.swift
//  Word Unscrambler
//
//  Created by Satish Boggarapu on 10/14/16.
//  Copyright © 2016 Satish Boggarapu. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var webView: UIWebView!
    
    var word: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let urlstring = "http://www.dictionary.com/browse/" + word!
        let url = URL(string: urlstring)
        let requestObj = URLRequest(url: url!)
        webView.loadRequest(requestObj)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
