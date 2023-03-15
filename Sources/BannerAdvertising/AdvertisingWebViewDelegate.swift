//
//  AdvertisingWebViewDelegate.swift
//  
//
//  Created by Developer on 07.12.2022.
//
import WebKit
import Foundation

final public class AdvertisingWebViewDelegate: NSObject, WKNavigationDelegate, WKUIDelegate {
    
    public var didFinish: Closure<Bool>?
    public var didCommit: ClosureEmpty?
    public var redirect: Closure<WKNavigationAction>?
    public var webView: WKWebView?
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView = webView
        didFinish?(true)
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.webView = webView
        didCommit?()
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let response = (navigationResponse.response as? HTTPURLResponse) else { return decisionHandler(.allow) }
        guard response.statusCode == 404 else { return decisionHandler(.allow) }
        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        redirect?(navigationAction)
        decisionHandler(.allow)
    }
}
