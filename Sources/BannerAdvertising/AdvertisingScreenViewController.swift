//
//  AdvertisingScreenViewController.swift
//  GDAdvertising
//
//  Copyright © 2022 Developer. All rights reserved.
//
import Combine
import UIKit
import WebKit
import VVMLibrary

final public class AdvertisingScreenViewController: UIViewController, ViewProtocol {
    
    //MARK: - Main ViewProperties
    public struct ViewProperties {
        let delegate : AdvertisingWebViewDelegate
        let urlString: String
        let tapForward: ClosureEmpty
        let tapBack: ClosureEmpty
        let updatePage: ClosureEmpty
        let closeAction: CurrentValueSubject<Bool, Never>
    }
    public var viewProperties: ViewProperties?
    
    //MARK: - Outlets
    @IBOutlet weak private var webView: WKWebView!
    @IBOutlet weak private var urlLabel: UILabel!
    
    public func update(with viewProperties: ViewProperties?) {
        self.viewProperties = viewProperties
        setupWebViewURL()
        setUrlLabel()
    }
    
    public func create(with viewProperties: ViewProperties?) {
        self.viewProperties = viewProperties
        setup()
        setupWebViewURL()
        setUrlLabel()
    }
    
    private func setup() {
        self.webView.navigationDelegate = viewProperties?.delegate
    }
    
    private func setupWebViewURL() {
        guard let urlString = viewProperties?.urlString else { return }
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    //MARK: - Buttons
    @IBAction func tapForwardButton(button: UIButton){
        self.viewProperties?.tapForward()
    }
    
    @IBAction func tapBackButton(button: UIButton){
        self.viewProperties?.tapBack()
    }
    
    @IBAction func updatePageButton(button: UIButton){
        self.viewProperties?.updatePage()
    }
    
    @IBAction func closeButton(button: UIButton){
        self.viewProperties?.closeAction.send(true)
    }
    
    private func setUrlLabel(){
        #if DEBUG
        guard let urlString = viewProperties?.urlString else {
            urlLabel.isHidden = true
            return
        }
        urlLabel.text = urlString
        urlLabel.isHidden = false
        #else
        urlLabel.isHidden = true
        #endif
    }
    
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
