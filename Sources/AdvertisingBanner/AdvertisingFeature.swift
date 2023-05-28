//
//  Created by Developer on 07.12.2022.
//
import Combine
import AppFlyerFramework
import AppsFlyerLib
import UIKit
import FirestoreFirebase

final public class AdvertisingFeature {
    
    private lazy var firestoreService = FirestoreService()
    private lazy var remoteService = RemoteService()
    private lazy var appsFlyerService = AppsFlyerService(
        devKey: self.devKey,
        appID: self.appID
    )
    private var anyCancel: Set<AnyCancellable> = []
    private var isClose = true
    private var parameters: [String: String] = [:]
    
    public var advertisingScreenViewManager: AdvertisingScreenViewManager?
    public let closeAction: CurrentValueSubject<Bool, Never> = .init(false)
    public var isFirstLaunch = true

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
        let firebaseManager = FirebaseManager()
        firebaseManager.setup()
    }
    
    public func setupAppsFlyer() {
        appsFlyerService.setup()
    }
    
    public func startAppsFlyer() {
        guard self.isFirstLaunch else { return }
        self.remoteService.getBoolValue(key: Constants.IDFAKey) { [weak self] isIDFA in
            self?.appsFlyerService.start(isIDFA: isIDFA)
        }
    }
    
    public func createAdvertisingScreenVC(
        with advertisingModel: AdvertisingModel
    ) -> AdvertisingScreenViewController {
        let advertisingBuilder = AdvertisingScreenViewControllerBuilder.create()
        self.isClose = advertisingModel.isClose
        self.advertisingScreenViewManager = advertisingBuilder.viewManager
        self.advertisingScreenViewManager?.state = .createViewProperties(advertisingModel)
        return advertisingBuilder.view
    }
    
    public func updateParameters(with parameters: [String: String]){
        parameters.forEach { key, value in
            self.parameters.updateValue(value, forKey: key)
        }
    }
    
    public func presentAdvertising(requestData: some RequestData, completion: @escaping Closure<PresentScreen>){
        self.getURLAdvertising(requestData: requestData) { [weak self] advertisingURL in
            guard let self = self else { return }
            
            switch advertisingURL {
                case .advertising(let requestDataModel):
                    guard requestDataModel.isAdvertising else {
                        completion(.game)
                        return
                    }
                    self.executeAppsFlyer { parameters in
                        DispatchQueue.main.async {
                            
                            guard let parameters = parameters else {
                                completion(.game)
                                return
                            }
                            self.saveParameters(with: parameters)
                            var advertisingModel = AdvertisingModel(
                                requestDataModel: requestDataModel
                            )
                            
                            advertisingModel.urlAdvertising = URL.create(
                                with: requestDataModel,
                                parameters: self.parameters
                            )
                            
                            let createAdvertisingScreenVC = self.createAdvertisingScreenVC(
                                with: advertisingModel
                            )
                            completion(.advertising(createAdvertisingScreenVC))
                            self.subscribeClose()
                            self.isFirstLaunch = false
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
    
    private func getURLAdvertising(requestData: some RequestData, completion: @escaping Closure<AdvertisingURL>) {
        firestoreService.get(requestData: requestData) { result in
            switch result {
                case .object(let object):
                    guard let requestDataModel = object?.first as? RequestDataModel
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
    
    private func saveParameters(with parameters: [String: String]? = nil){
        let parameters = parameters
        UserDefaults.standard.set(parameters, forKey: Constants.parametersKey)
    }
    
    private func saveInstal(with afStatus: AfStatus){
        UserDefaults.standard.set(afStatus.rawValue, forKey: Constants.afStatusKey)
    }
    
    private func executeAppsFlyer(completion: @escaping Closure<[String: String]?>) {
        let afStatusRawValue = UserDefaults.standard.string(forKey: Constants.afStatusKey) ?? "none"
        let afStatus = AfStatus(rawValue: afStatusRawValue)
        switch afStatus {
            case .organic:
                completion(nil)
            case .nonOrganic:
                if let parameters = UserDefaults.standard.dictionary(forKey: Constants.parametersKey) as? [String : String] {
                    completion(parameters)
                } else {
                    completion(["":""])
                }
            default:
                if let installGet = self.appsFlyerService.appsFlayerInstall {
                    switch installGet {
                        case .nonOrganic(let parameters):
                            self.saveParameters(with: parameters)
                            self.saveInstal(with: .nonOrganic)
                            completion(parameters)
                        case .organic:
                            self.saveParameters()
                            self.saveInstal(with: .organic)
                            completion(nil)
                    }
                } else {
                    self.appsFlyerService.installCompletion
                        .sink(receiveValue: { [weak self] install in
                            switch install {
                                case .nonOrganic(let parameters):
                                    self?.saveParameters(with: parameters)
                                    self?.saveInstal(with: .nonOrganic)
                                    completion(parameters)
                                case .organic:
                                    self?.saveParameters()
                                    self?.saveInstal(with: .organic)
                                    completion(nil)
                            }
                            self?.anyCancel.removeAll()
                        })
                        .store(in: &anyCancel)
                }
        }
    }
    
    private func subscribeClose(){
        self.advertisingScreenViewManager?.closeAction.sink { isClose in
            guard isClose, self.isClose else {
                self.advertisingScreenViewManager?.state = .tapBack
                return
            }
            self.closeAction.send(isClose)
        }
        .store(in: &anyCancel)
    }
}
private struct Constants {
    static let parametersKey = "parameters"
    static let afStatusKey = "AfStatus"
    static let IDFAKey = "IDFA"
}
