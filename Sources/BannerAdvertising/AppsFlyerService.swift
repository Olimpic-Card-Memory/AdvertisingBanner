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
    private var anyCancel: Set<AnyCancellable> = []
    
    public var installCompletion = PassthroughSubject<Install, Never>()
    public var completionDeepLinkResult: ((DeepLinkResult) -> Void)?
    public var currentInstall: Install?
    
    private let devKey: String
    private let appID : String
    
    init(
        devKey: String,
        appID: String
    ) {
        self.devKey = devKey
        self.appID = appID
    }
    
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
