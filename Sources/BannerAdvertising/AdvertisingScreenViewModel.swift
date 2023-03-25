//
//  AdvertisingScreenViewModel.swift
//  GDAdvertising
//
//  Copyright © 2022 Developer. All rights reserved.
//
import Combine
import Foundation
import VVMLibrary

final public class AdvertisingScreenViewModel: ViewModel<AdvertisingScreenViewController> {
    
    var viewProperties: AdvertisingScreenViewController.ViewProperties?
    
    // MARK: - public properties -
    public let closeAction: CurrentValueSubject<Bool, Never> = .init(false)
    
    // MARK: - private properties -
    private let advertisingWebViewDelegate: AdvertisingWebViewDelegate
   
    
    init(
        advertisingWebViewDelegate: AdvertisingWebViewDelegate
    ) {
        self.advertisingWebViewDelegate = advertisingWebViewDelegate
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
                    self.advertisingWebViewDelegate.webView?.goForward()
                }
                let tapBack: ClosureEmpty = {
                    self.advertisingWebViewDelegate.webView?.goBack()
                }
                let updatePage: ClosureEmpty = {
                    self.advertisingWebViewDelegate.webView?.reload()
                }
                self.advertisingWebViewDelegate.didFinish = { isFinish in
                    self.viewProperties?.isFinish = isFinish
                    self.update?(self.viewProperties)
                }
                viewProperties = AdvertisingScreenViewController.ViewProperties(
                    delegate: advertisingWebViewDelegate,
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
                self.advertisingWebViewDelegate.webView?.goBack()
                
            case .updateViewProperties:
                update?(viewProperties)
        }
    }
    
    private func subscribeDelegate(){
        self.advertisingWebViewDelegate.didFinish = { [weak self] isFinish in
            guard let self = self else { return }
            self.viewProperties?.isFinish = isFinish
            self.state = .updateViewProperties
        }
        
        self.advertisingWebViewDelegate.redirect = { [weak self] navigationAction in
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
