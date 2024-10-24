//
//  WebViewViewController.swift
//  InfoApp
//
//  Created by Thalia on 24/10/24.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, UIWebViewDelegate, WKUIDelegate, WKNavigationDelegate {

    var url: String? = ""
    private var webView: WKWebView!

    override func loadView() {

        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        guard let urlString = url, let urlValid = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url: urlValid))
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
