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
    
    public var urlParameters: ((String?) -> Void)?
    public var installCompletion: ((Install?) -> Void)?
    public var completionDeepLinkResult: ((DeepLinkResult) -> Void)?
    private var anyCancel: Set<AnyCancellable> = []
    
    public func start(){
        appsFlyer.start()
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
        appsFlyer.urlParameters = { parameters in
            self.urlParameters?(parameters)
        }
        
        appsFlyer.installCompletion.sink { install in
            self.installCompletion?(install)
        }.store(in: &anyCancel)
    }
    
    public func setupAppsFlyerDeepLinkDelegate(){
        appsFlyer.completionDeepLinkResult = { deepLinkResult in
            self.completionDeepLinkResult?(deepLinkResult)
        }
    }
}

