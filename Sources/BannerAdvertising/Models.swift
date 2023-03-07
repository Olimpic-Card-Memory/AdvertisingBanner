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
    
    public var collectionID: String = "Advertising"
    public var documentID  : String? = "FYGi1cwOd2f1pGOh1pIP"
    
    public init() {}
}

public struct RequestDataModel: Decodable {
    
    public var urlAdvertising: String
    public let isAdvertising: Bool
    public let isClose: Bool
    public let advertisingTitle: String
    
    public init(
        urlAdvertising: String,
        advertisingTitle: String,
        isAdvertising: Bool,
        isClose: Bool
    ) {
        self.urlAdvertising = urlAdvertising
        self.isAdvertising = isAdvertising
        self.advertisingTitle = advertisingTitle
        self.isClose = isClose
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
