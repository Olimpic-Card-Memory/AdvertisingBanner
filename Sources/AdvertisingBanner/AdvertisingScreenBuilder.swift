//
//  Created by Developer on 07.12.2022.
//
import UIKit
import Architecture
import OpenURL
import AlertService

final public class AdvertisingScreenViewControllerBuilder: BuilderProtocol {
    
    public typealias V  = AdvertisingScreenViewController
    public typealias VM = AdvertisingScreenViewManager
    
    public var view: AdvertisingScreenViewController
    public var viewManager: AdvertisingScreenViewManager
    
    public static func create() -> AdvertisingScreenViewControllerBuilder {
        let viewController = AdvertisingScreenViewController()
        let viewManager    = AdvertisingScreenViewManager()
        viewController.loadViewIfNeeded()
        viewManager.bind(with: viewController)
        let selfBuilder = AdvertisingScreenViewControllerBuilder(
            with: viewController,
            with: viewManager
        )
        return selfBuilder
    }
    
    private init(
        with viewController: AdvertisingScreenViewController,
        with viewManager: AdvertisingScreenViewManager
    ) {
        self.view = viewController
        self.viewManager = viewManager
    }
}

