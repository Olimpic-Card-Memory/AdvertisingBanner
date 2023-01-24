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
    
    private let firestoreService = FirestoreService()
    static let appsFlyerService = AppsFlyerService()
    static let firebaseService = FirebaseService()
  
    // MARK: - ViewModel
    public var advertisingViewModel: AdvertisingScreenViewModel?
    
    static public func setupFirebase() {
        firebaseService.setup()
    }
    
    static public func setupAppsFlyer() {
        appsFlyerService.setup()
        appsFlyerService.start()
    }
    
    static public func startAppsFlyer() {
        appsFlyerService.start()
    }
    
    public func createAdvertisingScreen(completion: @escaping Closure<PresentScreen>) {
        let requestData = RequestDataAdvertising()
        firestoreService.get(requestData: requestData) { [weak self] result in
            guard let self = self else { return }
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
