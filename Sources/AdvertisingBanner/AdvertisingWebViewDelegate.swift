//
//  Created by Developer on 07.12.2022.
//
import WebKit
import Foundation

final public class AdvertisingUIDelegate: NSObject, WKUIDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
    }
    
    public func webView(_ webView: WKWebView, contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo) {
        
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
    }
    
    public func webView(_ webView: WKWebView, contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo) {
        
    }
    
    public func webViewDidClose(_ webView: WKWebView) {
        
    }
}

final public class AdvertisingNavigationDelegate: NSObject, WKNavigationDelegate {
    
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
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        if #available(iOS 14.5, *) {
            decisionHandler(.download, preferences)
        } else {
            decisionHandler(.allow, preferences)
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        redirect?(navigationAction)
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }

}
