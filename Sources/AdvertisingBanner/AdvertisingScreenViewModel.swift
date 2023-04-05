//
//  Created by Developer on 07.12.2022.
//
import Combine
import Foundation
import Architecture

final public class AdvertisingScreenViewManager: ViewManager<AdvertisingScreenViewController> {
    
    var viewProperties: AdvertisingScreenViewController.ViewProperties?
    
    // MARK: - public properties -
    public let closeAction: CurrentValueSubject<Bool, Never> = .init(false)
    
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
                    isNavBarHidden: false
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
}