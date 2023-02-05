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
        let closeAction: CurrentValueSubject<Bool, Never>
    }
    public var viewProperties: ViewProperties?
    
    // MARK: - private properties -
    private var anyCancel: Set<AnyCancellable> = []
    
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
    
    //MARK: - Buttons
    @IBAction func tapForwardButton(button: UIButton){
        self.viewProperties?.tapForward()
    }
    
    @IBAction func tapBackButton(button: UIButton){
        self.viewProperties?.tapBack()
    }
    
    @IBAction func closeButton(button: UIButton){
        self.viewProperties?.closeAction.send(true)
        self.viewProperties?.closeAction.sink(receiveValue: { isClose in
            guard isClose else { return }
            self.dismiss(animated: true)
        })
        .store(in: &anyCancel)
    }
    
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
