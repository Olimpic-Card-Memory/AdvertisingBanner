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
    
    public var urlAdvertising: String
    public let isAdvertising: Bool
    public let isClose: Bool
    public let titleAdvertising: String
    
    public init(
        urlAdvertising: String,
        titleAdvertising: String,
        isAdvertising: Bool,
        isClose: Bool
    ) {
        self.urlAdvertising = urlAdvertising
        self.isAdvertising = isAdvertising
        self.titleAdvertising = titleAdvertising
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
