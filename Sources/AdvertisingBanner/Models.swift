//
//  Created by Developer on 07.12.2022.
//
import UIKit
import FirestoreFirebase

public struct RequestDataModel: Decodable {
    
    public let schemeAdvertising: String
    public let hostAdvertising: String
    public let pathAdvertising: String
    public let titleAdvertising: String
    public let isAdvertising: Bool
    public let isClose: Bool
    public let isCopyUrl: Bool
    
    public init(
        schemeAdvertising: String,
        hostAdvertising: String,
        pathAdvertising: String,
        titleAdvertising: String,
        isAdvertising: Bool,
        isClose: Bool,
        isCopyUrl: Bool
    ) {
        self.schemeAdvertising = schemeAdvertising
        self.hostAdvertising = hostAdvertising
        self.pathAdvertising = pathAdvertising
        self.titleAdvertising = titleAdvertising
        self.isAdvertising = isAdvertising
        self.isClose = isClose
        self.isCopyUrl = isCopyUrl
    }
}

public struct AdvertisingModel {
    
    public let hostAdvertising: String
    public var urlAdvertising: URL?
    public let isAdvertising: Bool
    public let isClose: Bool
    public let titleAdvertising: String
    public let isCopyUrl: Bool
    
    public init(requestDataModel: RequestDataModel) {
        self.hostAdvertising = requestDataModel.hostAdvertising
        self.urlAdvertising = nil
        self.isAdvertising = requestDataModel.isAdvertising
        self.titleAdvertising = requestDataModel.titleAdvertising
        self.isClose = requestDataModel.isClose
        self.isCopyUrl = requestDataModel.isCopyUrl
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
