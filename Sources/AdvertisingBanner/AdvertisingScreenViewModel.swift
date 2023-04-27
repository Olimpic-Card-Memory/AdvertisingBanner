//
//  Created by Developer on 07.12.2022.
//
import Combine
import UIKit
import SnapKit
import OpenURL
import Architecture
import AlertService
import UserDefaultsStandard

final public class AdvertisingScreenViewManager: ViewManager<AdvertisingScreenViewController> {
    
    var viewProperties: AdvertisingScreenViewController.ViewProperties?
    
    // MARK: - public properties -
    public let closeAction: CurrentValueSubject<Bool, Never> = .init(false)
    
    private var webBannerViewManager: WebBannerViewManager?
    
    // MARK: - private properties -
    private let advertisingNavigationDelegate: AdvertisingNavigationDelegate
    private let advertisingUIDelegate: AdvertisingUIDelegate
    private let openURL: OpenURL
    private let alertService: AlertService
    
    init(
        advertisingNavigationDelegate: AdvertisingNavigationDelegate,
        openURL: OpenURL,
        alertService: AlertService,
        advertisingUIDelegate: AdvertisingUIDelegate
    ) {
        self.advertisingNavigationDelegate = advertisingNavigationDelegate
        self.openURL = openURL
        self.alertService = alertService
        self.advertisingUIDelegate = advertisingUIDelegate
    }
    
    //MARK: - Main state view model
    public enum State {
        case createViewProperties(AdvertisingModel)
        case close(Bool)
        case tapBack
        case updateViewProperties
    }
    
    public var state: State? {
        didSet { self.stateModel() }
    }
    
    private func stateModel() {
        guard let state = self.state else { return }
        switch state {
            case .createViewProperties(let advertisingModel):
                let tapForward: ClosureEmpty = {
                    self.advertisingNavigationDelegate.webView?.goForward()
                }
                let tapBack: ClosureEmpty = {
                    self.advertisingNavigationDelegate.webView?.goBack()
                }
                let updatePage: ClosureEmpty = {
                    self.advertisingNavigationDelegate.webView?.reload()
                }
                self.advertisingNavigationDelegate.openBanner = { url in
                    self.openURL(with: url)
                }
                self.advertisingNavigationDelegate.didFinish = { isFinish in
                    self.viewProperties?.isFinish = isFinish
                    self.update?(self.viewProperties)
                }
                viewProperties = AdvertisingScreenViewController.ViewProperties(
                    advertisingNavigationDelegate: advertisingNavigationDelegate,
                    advertisingUIDelegate: advertisingUIDelegate,
                    advertisingModel: advertisingModel,
                    tapForward: tapForward,
                    tapBack: tapBack,
                    isFinish: false,
                    updatePage: updatePage,
                    closeAction: closeAction,
                    isNavBarHidden: false,
                    addAndCreateBannerView: addAndCreateBannerView
                )
                create?(viewProperties)
                subscribeDelegate()
            case .close(let isClose):
                closeAction.send(isClose)
                
            case .tapBack:
                self.advertisingNavigationDelegate.webView?.goBack()
                
            case .updateViewProperties:
                update?(viewProperties)
        }
    }
    
    private func subscribeDelegate(){
        self.advertisingNavigationDelegate.didFinish = { [weak self] isFinish in
            guard let self = self else { return }
            self.viewProperties?.isFinish = isFinish
            self.state = .updateViewProperties
        }
        
        self.advertisingNavigationDelegate.redirect = { [weak self] navigationAction in
            guard let self = self else { return }
            guard let hostAdvertising = self.viewProperties?.advertisingModel.hostAdvertising else {
                self.viewProperties?.isNavBarHidden = false
                self.state = .updateViewProperties
                return
            }
            guard let isNavBarHidden = navigationAction.request.url?.host?.contains(hostAdvertising) else {
                self.viewProperties?.isNavBarHidden = false
                self.state = .updateViewProperties
                return
            }
            self.viewProperties?.isNavBarHidden = isNavBarHidden
            self.state = .updateViewProperties
        }
    }
    
    private func addAndCreateBannerView(with containerView: UIView) {
        let webBannerViewBuilder = WebBannerViewBuilder.build()
        let webBannerView = webBannerViewBuilder.view
        containerView.addSubview(webBannerView)
        webBannerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.webBannerViewManager = webBannerViewBuilder.viewManager
        self.webBannerViewManager?.state = .presentBanner(false)
    }
    
    private func openURL(with url: URL?){
        guard BannerURL.isOpen(with: url) else { return }
        let bannerURL = BannerURL.isOpenApp(with: url)
        switch bannerURL {
            case .tg:
                let isOpen: Bool? = UserDefaultsStandard.shared.get(key: .isTelegramOpen)
                guard let url = url else { return }
                
                guard let isOpen = isOpen, !isOpen else {
                    self.openURL.open(with: .telegram(url))
                    return
                }
                alertService.options(title: "Telegramm", message: "Вы пользуетесь Telegramm?", options: TelegramAlert()){ index in
                    if index == 0 {
                        self.openURL.open(with: .telegram(url))
                    } else {
                        self.openURL.open(with: .urlList(.telegramApp))
                    }
                    UserDefaultsStandard.shared.save(key: .isTelegramOpen, value: true)
                }
                
            default:
                break
        }
    }
}
