//
//  Created by Developer on 07.12.2022.
//
import UIKit
import FirestoreFirebase
import AlertService

public struct RequestDataModel: Codable {
    
    public let schemeAdvertising: String
    public let prodHostAdvertising: String
    public let devHostAdvertising: String
    public let pathAdvertising: String
    public let titleAdvertising: String
    public let isAdvertising: Bool
    public let isClose: Bool
    public let isCopyUrl: Bool
    
    public init(
        schemeAdvertising: String,
        prodHostAdvertising: String,
        devHostAdvertising: String,
        pathAdvertising: String,
        titleAdvertising: String,
        isAdvertising: Bool,
        isClose: Bool,
        isCopyUrl: Bool
    ) {
        self.schemeAdvertising = schemeAdvertising
        self.prodHostAdvertising = prodHostAdvertising
        self.devHostAdvertising = devHostAdvertising
        self.pathAdvertising = pathAdvertising
        self.titleAdvertising = titleAdvertising
        self.isAdvertising = isAdvertising
        self.isClose = isClose
        self.isCopyUrl = isCopyUrl
    }
}

public struct AdvertisingModel {
    
    public let prodHostAdvertising: String
    public let devHostAdvertising: String
    public var urlAdvertising: URL?
    public let isAdvertising: Bool
    public let isClose: Bool
    public let titleAdvertising: String
    public let isCopyUrl: Bool
    
    public init(requestDataModel: RequestDataModel) {
        self.devHostAdvertising = requestDataModel.devHostAdvertising
        self.prodHostAdvertising = requestDataModel.prodHostAdvertising
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

public enum BannerURL: String, CaseIterable {
    case rules
    case tg = "tg://"
    
    static func isOpen(with url: URL?) -> Bool {
        guard let absoluteString = url?.absoluteString else { return false }
        let result = BannerURL.allCases.first(where: { absoluteString.contains($0.rawValue)})
        switch result {
            case .rules:
                return true
            case .tg:
                return true
            default:
                return false
        }
    }
    
    static func isOpenApp(with url: URL?) -> BannerURL? {
        guard let absoluteString = url?.absoluteString else { return nil }
        let result = BannerURL.allCases.first(where: { absoluteString.contains($0.rawValue)})
        switch result {
            case .rules:
                return .rules
            case .tg:
                return .tg
            default:
                return nil
        }
    }
}

struct TelegramAlert: AlertButtonOptionsoble {
    var buttonsCount: Int = 2
    var buttonsText: Array<String> = ["Да", "Нет"]
}
