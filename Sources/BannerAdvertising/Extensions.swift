//
//  Extension.swift
//  
//
//  Created by Developer on 11.12.2022.
//
import UIKit

extension Bundle {
    
    public static let blah = Bundle.module
    public static let bundle = Bundle.main.bundleIdentifier
}
public extension URL {
    
    static func create(
        with requestDataModel: RequestDataModel,
        parameters: [String: String]? = nil
    ) -> URL? {
        var components = URLComponents()
        components.scheme     = requestDataModel.schemeAdvertising
        components.host       = requestDataModel.hostAdvertising
        components.path       = requestDataModel.pathAdvertising
        components.queryItems = parameters?.createQueryItems()
        return components.url
    }
}

public extension Dictionary where Iterator.Element == (key: String, value: String) {
    
    func createQueryItems() -> [URLQueryItem] {
        let result = self.map { URLQueryItem(name: $0, value: $1) }
        return result
    }
}
