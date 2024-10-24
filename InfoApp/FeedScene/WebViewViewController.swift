//
//  WebViewViewController.swift
//  InfoApp
//
//  Created by Thalia on 24/10/24.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKNavigationDelegate {
    
    var url: String?
    var webView: WKWebView!
    var loadingView: LoadingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupLoadingView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    private func setupWebView() {
        webView = WKWebView(frame: view.bounds)
        webView.navigationDelegate = self // Verifique se isso está presente
        view.addSubview(webView)
        self.tabBarController?.tabBar.isHidden = true
        
        // Carregar a URL se existir
        if let urlString = url, let url = URL(string: urlString) {
            let request = URLRequest(url: url) // Mostrar o loading ao iniciar
            webView.load(request)
        }
    }

    private func setupLoadingView() {
        loadingView = LoadingView(frame: view.bounds)
        view.addSubview(loadingView)
        loadingView.startLoading() // Mostrar o loading ao iniciar
    }

    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingView.stopLoading() // Ocultar o loading após o carregamento
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingView.stopLoading() // Também parar o loading se houver erro
        // Aqui você pode exibir uma mensagem de erro, se desejar
        print("Erro ao carregar a página: \(error.localizedDescription)")
    }
}

