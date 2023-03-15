//
//  File.swift
//  
//
//  Created by Senior Developer on 07.03.2023.
//

import UIKit
import FirebaseBackend

final public class RequestDataAdvertising: RequestData {
    
    public typealias ReturnDecodable = RequestDataModel
    
    public var collectionID: String = "advertising"
    public var documentID  : String? = "configuration"
    
    public init() {}
}

public struct RequestDataModel: Decodable {
    
    public let domainAdvertising: String
    public let urlAdvertising: String
    public let isAdvertising: Bool
    public let isClose: Bool
    public let titleAdvertising: String
    
    public init(
        domainAdvertising: String,
        titleAdvertising: String,
        urlAdvertising: String,
        isAdvertising: Bool,
        isClose: Bool
    ) {
        self.domainAdvertising = domainAdvertising
        self.isAdvertising = isAdvertising
        self.titleAdvertising = titleAdvertising
        self.isClose = isClose
        self.urlAdvertising = urlAdvertising
    }
}

public struct AdvertisingModel {
    
    public let domainAdvertising: String
    public var urlAdvertising: String
    public var fullUrlAdvertising: String
    public var parametersAdvertising: String
    public let isAdvertising: Bool
    public let isClose: Bool
    public let titleAdvertising: String
    
    public init(requestDataModel: RequestDataModel) {
        self.urlAdvertising = requestDataModel.urlAdvertising
        self.parametersAdvertising = ""
        self.fullUrlAdvertising = ""
        self.isAdvertising = requestDataModel.isAdvertising
        self.titleAdvertising = requestDataModel.titleAdvertising
        self.isClose = requestDataModel.isClose
        self.domainAdvertising = requestDataModel.domainAdvertising
    }
}

public enum PresentScreen {
    case advertising(UIViewController)
    case game
}

public enum AdvertisingURL {
    case advertising(RequestDataModel)
    case error(String)
}
