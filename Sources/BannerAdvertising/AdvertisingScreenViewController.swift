//
//  AdvertisingScreenViewController.swift
//  GDAdvertising
//
//  Copyright © 2022 Developer. All rights reserved.
//
import SkeletonView
import Combine
import UIKit
import WebKit
import VVMLibrary

final public class AdvertisingScreenViewController: UIViewController, ViewProtocol {
    
    //MARK: - Main ViewProperties
    public struct ViewProperties {
        let delegate : AdvertisingWebViewDelegate
        let advertisingModel: AdvertisingModel
        let tapForward: ClosureEmpty
        let tapBack: ClosureEmpty
        var isFinish: Bool
        let updatePage: ClosureEmpty
        let closeAction: CurrentValueSubject<Bool, Never>
        var isNavBarHidden: Bool
    }
    public var viewProperties: ViewProperties?
    private var anyCancel: Set<AnyCancellable> = []
    
    //MARK: - Outlets
    @IBOutlet weak private var webView: WKWebView!
    @IBOutlet weak private var urlLabel: UILabel!
    @IBOutlet weak private var advertisingNavigationBar: UINavigationBar!
    @IBOutlet weak private var activityIndicatorView: UIActivityIndicatorView!
    
    public func update(with viewProperties: ViewProperties?) {
        self.viewProperties = viewProperties
        skeletonLoading()
        setUrlLabel()
        setAdvertisingTitleLabel()
        setNavBar()
    }
    
    public func create(with viewProperties: ViewProperties?) {
        self.viewProperties = viewProperties
        setup()
        setupWebViewURL()
        setUrlLabel()
        setAdvertisingTitleLabel()
        skeletonLoading()
        setNavBar()
    }
    
    private func setup() {
        self.webView.navigationDelegate = viewProperties?.delegate
    }
    
    private func setupWebViewURL() {
        guard let urlString = viewProperties?.advertisingModel.urlAdvertising else { return }
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func skeletonLoading(){
        guard let isFinish = self.viewProperties?.isFinish else { return }
        if !isFinish {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            webView.isSkeletonable = true
            webView.showAnimatedGradientSkeleton()
            let baseColor = UIColor(named: "baseColor") ?? .blue
            webView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: baseColor))
        } else {
            webView.hideSkeleton()
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
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
    
    private func setAdvertisingTitleLabel(){
        guard let titleAdvertising = viewProperties?.advertisingModel.titleAdvertising else {
            return
        }
        advertisingNavigationBar.items?.first?.title = titleAdvertising
        advertisingNavigationBar.isHidden = titleAdvertising.isEmpty
    }
    
    private func setNavBar(){
        guard let isNavBarHidden = viewProperties?.isNavBarHidden else {
            return
        }
        advertisingNavigationBar.isHidden = isNavBarHidden
    }
    
    private func setUrlLabel(){
        #if DEBUG
        guard let urlString = viewProperties?.advertisingModel.urlAdvertising else {
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
