//
//  Created by Developer on 07.12.2022.
//
import UIKit

extension Bundle {
    
    public static let blah = Bundle.module
    public static let bundle = Bundle.main.bundleIdentifier
}
public extension URL {
    
    static func create(
        with requestDataModel: RequestDataModel,
        parameters: [String: String]
    ) -> URL? {
        var components = URLComponents()
        #if DEBUG
        components.host = requestDataModel.devHostAdvertising
        #elseif RELEASE
        components.host = requestDataModel.prodHostAdvertising
        #else
        components.host = requestDataModel.devHostAdvertising
        #endif
        components.scheme = requestDataModel.schemeAdvertising
        components.path = requestDataModel.pathAdvertising
        components.queryItems = parameters.createQueryItems()
        return components.url
    }
}

public extension Dictionary where Iterator.Element == (key: String, value: String) {
    
    func createQueryItems() -> [URLQueryItem] {
        let result = self.map { URLQueryItem(name: $0, value: $1) }
        return result
    }
}
public extension UIView {
    
    static func loadNib() -> Self {
        let nib = Bundle.module.loadNibNamed(String(describing: Self.self), owner: nil, options: nil)?.first
        return nib as! Self
    }
}
