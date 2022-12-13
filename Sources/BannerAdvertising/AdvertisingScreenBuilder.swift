//
//  AdvertisingScreenBuilder.swift
//  GDAdvertising
//
//  Copyright © 2022 Developer. All rights reserved.
//
import Resolver
import UIKit
import GDVVMLibrary

final public class AdvertisingScreenViewControllerBuilder: BuilderProtocol {
    
    public typealias V  = AdvertisingScreenViewController
    public typealias VM = AdvertisingScreenViewModel
    
    public var view     : AdvertisingScreenViewController
    public var viewModel: AdvertisingScreenViewModel
    
    public static func create() -> AdvertisingScreenViewControllerBuilder {
        let viewController = AdvertisingScreenViewController()
        let viewModel      = AdvertisingScreenViewModel(
            advertisingWebViewDelegate: Resolver.resolve()
        )
        viewController.loadViewIfNeeded()
        viewModel.bind(with: viewController)
        let selfBuilder = AdvertisingScreenViewControllerBuilder(
            with: viewController,
            with: viewModel
        )
        return selfBuilder
    }
    
    private init(
        with viewController: AdvertisingScreenViewController,
        with viewModel: AdvertisingScreenViewModel
    ) {
        self.view      = viewController
        self.viewModel = viewModel
    }
}

