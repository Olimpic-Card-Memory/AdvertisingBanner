//
//  AppsFlyerService.swift
//  
//
//  Created by Developer on 23.01.2023.
//
import AppsFlyerLib
import AdvertisingAppsFlyer
import Foundation
import UIKit

final class AppsFlyerService {
    
    private let appsFlyer = GDAppsFlyer()
    private let devKey    = "zgnKRCbyHh8k7AcFrCzh7E"
    private let appID     = "1662068962"
    
    public var urlParameters: ((String?) -> Void)?
    public var installCompletion: ((Install?) -> Void)?
    public var completionDeepLinkResult: ((DeepLinkResult) -> Void)?
    
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
        
        appsFlyer.installCompletion = { install in
            self.installCompletion?(install)
            switch install {
                case .nonOrganic:
                    print("nonOrganic")
                case .organic:
                    print("organic")
                default:
                    break
            }
        }
    }
    
    public func setupAppsFlyerDeepLinkDelegate(){
        appsFlyer.completionDeepLinkResult = { deepLinkResult in
            self.completionDeepLinkResult?(deepLinkResult)
        }
    }
}

