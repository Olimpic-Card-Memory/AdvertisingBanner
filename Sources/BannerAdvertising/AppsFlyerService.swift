//
//  AppsFlyerService.swift
//  
//
//  Created by Developer on 23.01.2023.
//
import AppsFlyerLib
import AdvertisingAppsFlyer
import Foundation
import Combine
import UIKit

final class AppsFlyerService {
    
    private let appsFlyer = GDAppsFlyer()
    private let devKey    = "zgnKRCbyHh8k7AcFrCzh7E"
    private let appID     = "1662068962"
    private var anyCancel: Set<AnyCancellable> = []
    
    public var installCompletion = PassthroughSubject<Install, Never>()
    public var completionDeepLinkResult: ((DeepLinkResult) -> Void)?
    public var currentInstall: Install?
    
    public func start(){
        appsFlyer.startRequestTrackingAuthorization()
    }
    
    public func setup(){
        setupParseAppsFlyerData()
        setupAppsFlyerDeepLinkDelegate()
        appsFlyer.setDebag(isDebug: true)
        appsFlyer.setup(
            appID : appID,
            devKey: devKey
        )
    }
    
    public func setupParseAppsFlyerData(){
        appsFlyer.installCompletion.sink { [weak self] install in
            guard let self = self else { return }
            self.currentInstall = install
            self.installCompletion.send(install)
        }.store(in: &anyCancel)
    }
    
    public func setupAppsFlyerDeepLinkDelegate(){
        appsFlyer.completionDeepLinkResult = { deepLinkResult in
            self.completionDeepLinkResult?(deepLinkResult)
        }
    }
}
