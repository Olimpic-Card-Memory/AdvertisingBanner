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
    private lazy var appsFlyerService = AppsFlyerService(
        devKey: self.devKey,
        appID: self.appID
    )
    private var anyCancel: Set<AnyCancellable> = []
    private var isClose = true
    
    public var advertisingViewModel: AdvertisingScreenViewModel?
    public let closeAction: CurrentValueSubject<Bool, Never> = .init(false)
    
    private let devKey: String
    private let appID : String
    
    public init(
        devKey: String,
        appID: String
    ) {
        self.devKey = devKey
        self.appID = appID
    }
    
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
        self.getURLAdvertising { [weak self] advertisingURL in
            guard let self = self else { return }
            
            switch advertisingURL {
                case .advertising(let requestDataModel):
                    guard requestDataModel.isAdvertising else {
                        completion(.game)
                        return
                    }
                    self.executeAppsFlyer { parameters in
                        
                        DispatchQueue.main.async {
                            
                            var advertisingModel = AdvertisingModel(
                                requestDataModel: requestDataModel
                            )
                            advertisingModel.urlAdvertising = URL.create(
                                with: requestDataModel,
                                parameters: parameters
                            )
                            
                            let createAdvertisingScreenVC = self.createAdvertisingScreenVC(
                                with: advertisingModel
                            )
                            completion(.advertising(createAdvertisingScreenVC))
                            self.subscribeClose()
                        }
                    }
                    
                case .error(let error):
                    print(error)
                    DispatchQueue.main.async {
                        completion(.game)
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
    
    private func executeAppsFlyer(completion: @escaping Closure<[String: String]?>) {
        switch self.appsFlyerService.currentInstall {
            case .nonOrganic(let parameters):
                completion(parameters)
            case .organic:
                completion(nil)
            default:
                appsFlyerService.installCompletion
                    .sink(receiveValue: { install in
                        switch install {
                            case .nonOrganic(let parameters):
                                completion(parameters)
                            case .organic:
                                completion(nil)
                        }
                    })
                    .store(in: &anyCancel)
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
}
