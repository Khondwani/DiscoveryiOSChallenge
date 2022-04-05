//
//  WebViewViewController.swift
//  DiscoveryChallenge
//
//  Created by Khondwani Sikasote on 2022/04/05.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var htmlMapPage: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString(htmlMapPage, baseURL: nil)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
