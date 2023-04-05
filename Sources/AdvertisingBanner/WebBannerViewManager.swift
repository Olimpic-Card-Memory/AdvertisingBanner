//
//  Created by Developer on 07.12.2022.
//
import Foundation
import Architecture

final class WebBannerViewManager: ViewManager<WebBannerView> {
    
    var viewProperties: WebBannerView.ViewProperties?
    
    // MARK: - private properties -
    private let advertisingNavigationDelegate: AdvertisingNavigationDelegate
    private let advertisingUIDelegate: AdvertisingUIDelegate
    
    init(
        advertisingNavigationDelegate: AdvertisingNavigationDelegate,
        advertisingUIDelegate: AdvertisingUIDelegate
    ) {
        self.advertisingNavigationDelegate = advertisingNavigationDelegate
        self.advertisingUIDelegate = advertisingUIDelegate
    }
    
    //MARK: - Main state view Manager
    enum State {
        case createViewProperties(URL)
        case updateUrl(URL)
        case presentBanner(Bool)
    }
    
    public var state: State? {
        didSet { self.stateManager() }
    }
    
    private func stateManager(){
        guard let state = self.state else { return }
        switch state {
            case .createViewProperties(let url):
                guard isOpen(with: url) else { return }
                viewProperties =  WebBannerView.ViewProperties(
                    advertisingNavigationDelegate: advertisingNavigationDelegate,
                    advertisingUIDelegate: advertisingUIDelegate,
                    bannerURL: url,
                    isPresentBanner: true
                )
                create?(viewProperties)
                
            case .updateUrl(let bannerURL):
                viewProperties?.bannerURL = bannerURL
                update?(viewProperties)
                
            case .presentBanner(let isPresent):
                viewProperties?.isPresentBanner = isPresent
                update?(viewProperties)
        }
    }
    private func isOpen(with url: URL?) -> Bool {
        guard let absoluteString = url?.absoluteString else { return false }
        let result = BannerURL.allCases.first(where: { absoluteString.contains($0.rawValue)})
        switch result {
            case .rules:
                return true
            default:
                return false
        }
    }
}
