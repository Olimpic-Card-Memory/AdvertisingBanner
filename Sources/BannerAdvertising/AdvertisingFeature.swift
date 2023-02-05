//
//  AdvertisingFeature.swift
//  
//
//  Created by Senior Developer on 07.12.2022.
//
import Combine
import AdvertisingAppsFlyer
import AppsFlyerLib
import AdvertisingFirebase
import UIKit

final public class AdvertisingFeature {
    
    private lazy var firestoreService = FirestoreService()
    private lazy var appsFlyerService = AppsFlyerService()
    private var anyCancel: Set<AnyCancellable> = []
    
    // MARK: - ViewModel
    public var advertisingViewModel: AdvertisingScreenViewModel?
    
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
    
    private func executeFirebase(completion: @escaping Closure<PresentScreen>) {
        let requestData = RequestDataAdvertising()
        firestoreService.get(requestData: requestData) { result in
            switch result {
                case .object(let object):
                    DispatchQueue.main.async {
                        let urlAdvertising = object.urlAdvertising
                        let advertisingBuilder = AdvertisingScreenViewControllerBuilder.create()
                        self.advertisingViewModel = advertisingBuilder.viewModel
                        self.advertisingViewModel?.state = .createViewProperties(urlAdvertising)
                        completion(.advertising(advertisingBuilder.view))
                        self.subscribeClose()
                    }
                case .error(let error):
                    DispatchQueue.main.async {
                        print(error?.localizedDescription ?? "")
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
                    let urlAdvertising = object.urlAdvertising
                    completion(.advertising(urlAdvertising))
                case .error(let error):
                    completion(.error(error?.localizedDescription ?? ""))
            }
        }
    }
    
    private func executeAppsFlyer(completion: @escaping Closure<String?>) {
        appsFlyerService.installCompletion = { install in
            switch install {
                case .organic:
                    completion(nil)
                case .nonOrganic(let parameters):
                    completion(parameters)
                default:
                    completion(nil)
            }
        }
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
                    case .advertising(let urlAdvertising):
                        DispatchQueue.main.async {
                            let advertisingBuilder = AdvertisingScreenViewControllerBuilder.create()
                            self.advertisingViewModel = advertisingBuilder.viewModel
                            let urlAdvertising = urlAdvertising + parameters
                            self.advertisingViewModel?.state = .createViewProperties(urlAdvertising)
                            completion(.advertising(advertisingBuilder.view))
                        }
                       
                    case .error(let error):
                        print(error)
                        completion(.game)
                }
            }
        }
    }
    
    private func subscribeClose(){
        self.advertisingViewModel?.closeAction.sink { isClose in
           
        }
        .store(in: &anyCancel)
    }
    
    public init() {} 
}

final public class RequestDataAdvertising: RequestData {
    
    public typealias ReturnDecodable = RequestDataModel
    
    public var collectionID: String = "olimpicSlots"
    public var documentID  : String = "Zx8Fl8nussho5xBjXaHv"
    
    public init() {}
}

public struct RequestDataModel: Decodable {
    
    public let urlAdvertising: String
    
    public init(urlAdvertising: String) {
        self.urlAdvertising = urlAdvertising
    }
}

public enum PresentScreen {
    case advertising(UIViewController)
    case game
}

public enum AdvertisingURL {
    case advertising(String)
    case error(String)
}

