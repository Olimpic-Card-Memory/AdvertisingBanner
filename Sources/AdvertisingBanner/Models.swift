//
//  Created by Developer on 07.12.2022.
//
import UIKit
import FirestoreFirebase
import AlertService

public struct RequestDataModel: Codable {
    
    public let schemeAdvertising: String
    public let hostAdvertising: String
    public let pathAdvertising: String
    public let titleAdvertising: String
    public let isAdvertising: Bool
    public let isClose: Bool
    public let isCopyUrl: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case schemeAdvertising
        case devHostAdvertising
        case prodHostAdvertising
        case pathAdvertising
        case titleAdvertising
        case isAdvertising
        case isClose
        case isCopyUrl
    }
    
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
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        #if DEBUG
        self.hostAdvertising = try values.decode(String.self, forKey: .devHostAdvertising)
        #elseif RELEASE
        self.hostAdvertising = try values.decode(String.self, forKey: .prodHostAdvertising)
        #else
        self.hostAdvertising = try values.decode(String.self, forKey: .devHostAdvertising)
        #endif
        self.schemeAdvertising = try values.decode(String.self, forKey: .schemeAdvertising)
        self.pathAdvertising = try values.decode(String.self, forKey: .pathAdvertising)
        self.titleAdvertising = try values.decode(String.self, forKey: .titleAdvertising)
        self.isAdvertising = try values.decode(Bool.self, forKey: .isAdvertising)
        self.isClose = try values.decode(Bool.self, forKey: .isClose)
        self.isCopyUrl = try values.decode(Bool.self, forKey: .isCopyUrl)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        #if DEBUG
        try container.encode(hostAdvertising, forKey: .devHostAdvertising)
        #elseif RELEASE
        try container.encode(hostAdvertising, forKey: .prodHostAdvertising)
        #else
        try container.encode(hostAdvertising, forKey: .devHostAdvertising)
        #endif
        try container.encode(schemeAdvertising, forKey: .schemeAdvertising)
        try container.encode(pathAdvertising, forKey: .pathAdvertising)
        try container.encode(titleAdvertising, forKey: .titleAdvertising)
        try container.encode(isAdvertising, forKey: .isAdvertising)
        try container.encode(isClose, forKey: .isClose)
        try container.encode(isCopyUrl, forKey: .isCopyUrl)
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
