//
//  AdvertisingFeature.swift
//  
//
//  Created by Senior Developer on 07.12.2022.
//
import AdvertisingAppsFlyer
import AppsFlyerLib
import AdvertisingFirebase
import Foundation

final public class AdvertisingFeature {
    
    private lazy var firestoreService = FirestoreService()
    private lazy var appsFlyerService = AppsFlyerService()
    
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
    
    public func executeFirebase(completion: @escaping Closure<PresentScreen>) {
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
                    }
                case .error(let error):
                    DispatchQueue.main.async {
                        print(error?.localizedDescription ?? "")
                        completion(.game)
                    }
            }
        }
    }
    
     public func executeAppsFlyer(completion: @escaping Closure<PresentScreen>) {
        appsFlyerService.installCompletion = { install in
            switch install {
                case .organic:
                    DispatchQueue.main.async {
                        completion(.game)
                    }
                case .nonOrganic:
                    DispatchQueue.main.async {
                        let advertisingBuilder = AdvertisingScreenViewControllerBuilder.create()
                        self.advertisingViewModel = advertisingBuilder.viewModel
                        self.advertisingViewModel?.state = .createViewProperties("https://www.sports.ru/")
                        completion(.advertising(advertisingBuilder.view))
                    }
                default:
                    break
            }
        }
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
    case advertising(AdvertisingScreenViewController)
    case game
}
