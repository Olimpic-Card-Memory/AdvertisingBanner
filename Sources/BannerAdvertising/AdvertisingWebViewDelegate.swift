//
//  AdvertisingWebViewDelegate.swift
//  
//
//  Created by Developer on 07.12.2022.
//
import WebKit
import Combine
import Foundation

final public class AdvertisingWebViewDelegate: NSObject, WKNavigationDelegate, WKUIDelegate {
    
    public var didFinish: CurrentValueSubject<Bool, Never>?
    public var didCommit: ClosureEmpty?
    public var webView: WKWebView?
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView = webView
        didFinish?.send(true)
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
}
