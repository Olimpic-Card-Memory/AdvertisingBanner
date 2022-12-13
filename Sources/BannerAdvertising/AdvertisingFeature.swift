//
//  AdvertisingFeature.swift
//  
//
//  Created by Senior Developer on 07.12.2022.
//
import AdvertisingFirebase
import Foundation

final public class AdvertisingFeature {
    
    private let firestoreService = FirestoreService()
    private let firebaseService = FirebaseService()
    
    // MARK: - ViewModel
    public var advertisingViewModel: AdvertisingScreenViewModel?
    
    public func setup() {
        firebaseService.setup()
    }
    
    public func createAdvertisingScreen(completion: @escaping Closure<PresentScreen>) {
        let requestData = RequestDataAdvertising()
        firestoreService.get(requestData: requestData) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .object(let object):
                    let urlAdvertising = object.urlAdvertising
                    let advertisingBuilder = AdvertisingScreenViewControllerBuilder.create()
                    self.advertisingViewModel = advertisingBuilder.viewModel
                    self.advertisingViewModel?.state = .createViewProperties(urlAdvertising)
                    completion(.advertising(advertisingBuilder.view))
                case .error(let error):
                    print(error?.localizedDescription ?? "")
                    completion(.game)
            }
        }
        
    }
}

final class RequestDataAdvertising: RequestData {
    
    typealias ReturnDecodable = RequestDataModel
    
    var collectionID: String = "olimpicSlots"
    var documentID  : String = "Zx8Fl8nussho5xBjXaHv"
}

struct RequestDataModel: Decodable {
    
    let urlAdvertising: String
}

public enum PresentScreen {
    case advertising(AdvertisingScreenViewController)
    case game
}
