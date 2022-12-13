//
//  AdvertisingScreenViewModel.swift
//  GDAdvertising
//
//  Copyright © 2022 Developer. All rights reserved.
//
import Foundation
import GDVVMLibrary

final public class AdvertisingScreenViewModel: ViewModel<AdvertisingScreenViewController> {
    
    var viewProperties: AdvertisingScreenViewController.ViewProperties?
    
    private let advertisingWebViewDelegate: AdvertisingWebViewDelegate
    
    init(
        advertisingWebViewDelegate: AdvertisingWebViewDelegate
    ) {
        self.advertisingWebViewDelegate = advertisingWebViewDelegate
    }
    
    //MARK: - Main state view model
    public enum State {
        case createViewProperties(String)
    }
    
    public var state: State? {
        didSet { self.stateModel() }
    }
    
    private func stateModel() {
        guard let state = self.state else { return }
        switch state {
            case .createViewProperties(let urlString):
               
                viewProperties = AdvertisingScreenViewController.ViewProperties(
                    delegate: advertisingWebViewDelegate,
                    urlString: urlString
                )
                create?(viewProperties)
        }
    }
}
