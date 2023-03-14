//
//  AdvertisingFeature.swift
//  
//
//  Created by Developer on 07.12.2022.
//
import Combine
import AdvertisingAppsFlyer
import AppsFlyerLib
import FirebaseBackend
import UIKit

final public class AdvertisingFeature {
    
    private lazy var firestoreService = FirestoreService()
    private lazy var appsFlyerService = AppsFlyerService()
    private var anyCancel: Set<AnyCancellable> = []
    private var isClose = true
    
    // MARK: - ViewModel
    public var advertisingViewModel: AdvertisingScreenViewModel?
    public let closeAction: CurrentValueSubject<Bool, Never> = .init(false)
    
    public func setupFirebase() {
        let firebaseService = FirebaseService()
        firebaseService.setup()
    }
    
    public func setupAppsFlyer() {
        appsFlyerService.setup()
    }
    
    public func startAppsFlyer() {
        appsFlyerService.start()
    }
    
    public func createAdvertisingScreenVC(
        with advertisingModel: AdvertisingModel
    ) -> AdvertisingScreenViewController {
        let advertisingBuilder = AdvertisingScreenViewControllerBuilder.create()
        self.isClose = advertisingModel.isClose
        self.advertisingViewModel = advertisingBuilder.viewModel
        self.advertisingViewModel?.state = .createViewProperties(advertisingModel)
        return advertisingBuilder.view
    }
    
    public func presentAdvertising(completion: @escaping Closure<PresentScreen>){
        self.executeAppsFlyer { [weak self] parameters in
            guard let self = self else { return }
            guard let parameters = parameters else {
                completion(.game)
                return
            }
            self.getURLAdvertising { advertisingURL in
                switch advertisingURL {
                    case .advertising(let requestDataModel):
                        DispatchQueue.main.async {
                            var advertisingModel = AdvertisingModel(
                                requestDataModel: requestDataModel
                            )
                            advertisingModel.urlAdvertising += parameters
                            
                            let createAdvertisingScreenVC = self.createAdvertisingScreenVC(
                                with: advertisingModel
                            )
                            completion(.advertising(createAdvertisingScreenVC))
                            self.subscribeClose()
                        }
                        
                    case .error(let error):
                        print(error)
                        completion(.game)
                }
            }
        }
    }
    
    private func executeFirebase(completion: @escaping Closure<AdvertisingURL>) {
        let requestData = RequestDataAdvertising()
        firestoreService.get(requestData: requestData) { result in
            switch result {
                case .object(let object):
                    guard let requestDataModel = object.first else { return }
                    DispatchQueue.main.async {
                        completion(.advertising(requestDataModel))
                        self.subscribeClose()
                    }
                case .error(let error):
                    DispatchQueue.main.async {
                        completion(.error(error?.localizedDescription ?? ""))
                    }
            }
        }
    }
    
    private func getURLAdvertising(completion: @escaping Closure<AdvertisingURL>) {
        let requestData = RequestDataAdvertising()
        firestoreService.get(requestData: requestData) { result in
            switch result {
                case .object(let object):
                    guard let requestDataModel = object.first
                    else {
                        completion(.error(""))
                        return
                    }
                    completion(.advertising(requestDataModel))
                case .error(let error):
                    completion(.error(error?.localizedDescription ?? ""))
            }
        }
    }
    
    private func executeAppsFlyer(completion: @escaping Closure<String?>) {
        appsFlyerService.installCompletion = { install in
            guard let install = install else { return }
            switch install {
                case .nonOrganic(let parameters):
                    completion(parameters)
                case .organic:
                    completion(nil)
            }
        }
    }
    
    private func subscribeClose(){
        self.advertisingViewModel?.closeAction.sink { isClose in
            guard isClose, self.isClose else {
                self.advertisingViewModel?.state = .tapBack
                return
            }
            self.closeAction.send(isClose)
        }
        .store(in: &anyCancel)
    }
    
    public init() {} 
}
