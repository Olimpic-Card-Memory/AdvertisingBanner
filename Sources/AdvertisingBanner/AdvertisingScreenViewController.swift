//
//  Created by Developer on 07.12.2022.
//
import SkeletonView
import Combine
import UIKit
import WebKit
import AlertService
import Architecture

final public class AdvertisingScreenViewController: UIViewController, ViewProtocol {
    
    //MARK: - Main ViewProperties
    public struct ViewProperties {
        let advertisingNavigationDelegate: AdvertisingNavigationDelegate
        let advertisingUIDelegate: AdvertisingUIDelegate
        var advertisingModel: AdvertisingModel
        let tapForward: ClosureEmpty
        let tapBack: ClosureEmpty
        var isFinish: Bool
        let updatePage: ClosureEmpty
        let closeAction: CurrentValueSubject<Bool, Never>
        var isNavBarHidden: Bool
        let addAndCreateBannerView: Closure<UIView>
    }
    public var viewProperties: ViewProperties?
    private var anyCancel: Set<AnyCancellable> = []
    private var configurationWKWebView: WKWebView!
    private var urlAdvertising: String = ""
    private let alertService = AlertService()
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
        setupWebViewURL()
        setUrlLabel()
        setAdvertisingTitleLabel()
        skeletonLoading()
        setNavBar()
        viewProperties?.addAndCreateBannerView(self.view)
        self.urlAdvertising = viewProperties?.advertisingModel.urlAdvertising?.absoluteString ?? ""
    }
    
    private func setup() {
        self.configurationWKWebView.navigationDelegate = viewProperties?.advertisingNavigationDelegate
        self.configurationWKWebView.uiDelegate = viewProperties?.advertisingUIDelegate
    }
    
    private func setupWebViewURL() {
        guard let urlAdvertising = viewProperties?.advertisingModel.urlAdvertising else { return }
        let urlRequest = URLRequest(url: urlAdvertising)
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        self.configurationWKWebView = WKWebView(
            frame: .zero,
            configuration: configuration
        )
        self.webView.addSubview(configurationWKWebView)
        self.setup()
        self.configurationWKWebView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        configurationWKWebView.load(urlRequest)
    }
    
    private func skeletonLoading(){
        guard let isFinish = self.viewProperties?.isFinish else { return }
        if !isFinish {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }
    
    private func tapHome(){
        if let url = URL(string: self.urlAdvertising) {
            let urlRequest = URLRequest(url: url)
            configurationWKWebView.load(urlRequest)
        } else {
            alertService.default(title: "Ошибка", message: "Ошибка обнавления")
        }
    }
    
    //MARK: - Buttons
    @IBAction func tapForwardButton(button: UIButton){
        self.viewProperties?.tapForward()
    }
    
    @IBAction func tapBackButton(button: UIButton){
        self.tapHome()
    }
    
    @IBAction func updatePageButton(button: UIButton){
        configurationWKWebView.reload()
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
        guard let urlAdvertising = viewProperties?.advertisingModel.urlAdvertising else {
            urlLabel.isHidden = true
            return
        }
        urlLabel.text = urlAdvertising.absoluteString
        urlLabel.isHidden = false
        #else
        urlLabel.isHidden = true
        #endif
    }
    
    // MARK: - Override
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: {_ in
            //self.configurationWKWebView?.evaluateJavaScript("location.reload();", completionHandler: nil)
        })
    }
    
    // Enable detection of shake motion
    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard let isCopyUrl = viewProperties?.advertisingModel.isCopyUrl else {
            return
        }
        guard let urlAdvertising = viewProperties?.advertisingModel.urlAdvertising else {
            return
        }
        if motion == .motionShake, isCopyUrl {
            UIPasteboard.general.string = urlAdvertising.absoluteString
        }
    }
    
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
