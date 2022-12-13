//
//  AdvertisingScreenViewController.swift
//  GDAdvertising
//
//  Copyright © 2022 Developer. All rights reserved.
//
import UIKit
import WebKit
import VVMLibrary

final public class AdvertisingScreenViewController: UIViewController, ViewProtocol {
    
    //MARK: - Main ViewProperties
    public struct ViewProperties {
        let delegate : AdvertisingWebViewDelegate
        let urlString: String
    }
    public var viewProperties: ViewProperties?
    
    //MARK: - Outlets
    @IBOutlet weak private var webView: WKWebView!
    
    //MARK: - LifeCycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    public func update(with viewProperties: ViewProperties?) {
        self.viewProperties = viewProperties
        setupURL()
    }
    
    public func create(with viewProperties: ViewProperties?) {
        self.viewProperties = viewProperties
        setup()
        setupURL()
    }
    
    private func setup() {
        self.webView.navigationDelegate = viewProperties?.delegate
    }
    
    private func setupURL() {
        guard let urlString = viewProperties?.urlString else { return }
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
