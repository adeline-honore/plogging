//
//  NetworkService.swift
//  Plogging
//
//  Created by HONORE Adeline on 28/10/2023.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

//protocol APINetworkProtocol {
//    func callNetwork(router: URLRequestConvertible, completionHandler: @escaping (Result<Data, Error>) -> ())
//}

//class APINetwork: APINetworkProtocol {
//    func callNetwork(router: URLRequestConvertible, completionHandler: @escaping (Result<Data, Error>) -> ()) {
//                
//        AF.request(router).responseData { responseData in
//             let reponseResult = responseData.result
//            
//            switch reponseResult {
//            case .success(let data):
//                completionHandler(.success(data))
//            case .failure(let error):
//                completionHandler(.failure(error))
//            }
//            
//        }
//        
//    }
//}

//protocol AllRecipesServiceProtocol {
//    func getData(ingredients: String, completionHandler: @escaping (Result<[Recipe], ErrorType>) -> ())
//    func getImageData(url: String, completionHandler: @escaping (Result<UIImage, ErrorType>) -> ())
//}

//public enum IngredientsRouterNetwork: URLRequestConvertible {
//    
//    enum Constants {
//        static let baseURLPath = "https://api.edamam.com/api/recipes/v2"
//        static let apiId = "e6088885"
//        static let apiKey = "9d5f4557a5f8754c718afdcf5d463945"
//        static let publicType = "public"
//    }
//    
//    case type(String)
//    case ingredients(String)
//    case apiId(String)
//    case apiKey(String)
//    
//    var method: HTTPMethod {
//        switch self {
//        case .type, .ingredients, .apiId, .apiKey:
//            return .get
//        }
//    }
//    
//    var path: String {
//        switch self {
//        case .type:
//            return "/type"
//        case .ingredients:
//            return "/"
//        case .apiId:
//            return "app_id"
//        case .apiKey:
//            return "app_key"
//        }
//    }
//    
//    var parameters: [String: Any] {
//        switch self {
//        case .ingredients(let test):
//            return ["app_id": Constants.apiId, "app_key": Constants.apiKey, "type": Constants.publicType, "q": test]
//        default:
//            return [:]
//        }
//    }
//    
//    public func asURLRequest() throws -> URLRequest {
//        let url = try Constants.baseURLPath.asURL()
//        
//        var request = URLRequest(url: url.appendingPathComponent(path))
//        request.httpMethod = method.rawValue
//        request.timeoutInterval = TimeInterval(10 * 1000)
//        
//        return try URLEncoding.default.encode(request, with: parameters)
//    }
//}


//public enum FetchImageRouter {
//    
//    case urlImage(String)
//    
//    func asURLRequest() throws -> URLRequest {
//        
//        switch self {
//        case .urlImage(let urlString):
//            guard let url = URL(string: urlString) else { throw ErrorType.network }
//            
//            do {
//                return try URLRequest(url: url, method: .get, headers: .none)
//            } catch {
//                throw error
//            }
//        }
//    }
//}

//class ChangeRateService: ChangeRateServiceProtocol {
//    
//    private var network: NetworkProtocol
//        
//    init(network: NetworkProtocol) {
//        self.network = network
//    }
//    
//    func getData(completionHandler: @escaping (Result<Fixer, Error>) -> ()) {
//        
//        return network.callNetwork(router: ChangeRateRouter.getRate, completionHandler: { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let data):
//                    let fixer = self.transformToFixer(data: data)
//                    completionHandler(.success(fixer))
//                case .failure(let error):
//                    completionHandler(.failure(error))
//                }
//            }
//        })
//    }
//    
//    private func transformToFixer(data: Data) -> Fixer {
//        var responseFixer: Fixer
//        let data = data
//        responseFixer = try! JSONDecoder().decode(Fixer.self, from: data)
//        return responseFixer
//    }
//}

//enum ChangeRateRouter: RouterProtocol {
//    
//    var baseURL: String {
//    "http://data.fixer.io/api/latest?"
//    }
//    
//    case getRate
//    
//    func buildParams() -> URL? {
//        switch self {
//        case .getRate:
//            var weatherComponents = URLComponents(string: baseURL)
//            
//            weatherComponents?.queryItems = [
//                URLQueryItem(name: "access_key", value: "7f3ca3bafe654134abd06e9450f7f720"),
//                URLQueryItem(name: "symbols", value: "USD")
//            ]
//            return URL(string: weatherComponents?.string ?? "")
//        }
//    }
//    
//    func asUrlRequest() -> URLRequest? {
//        guard let url = buildParams() else {
//            return nil
//        }
//        return URLRequest(url: url)
//    }
//}

//protocol PloggingServiceProtocol {
//    func createOrUpdateAPIPlogging(plogging: Plogging, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void)
//    func getAPIPloggingList(completionHandler: @escaping (Result<[Plogging], Error>) -> Void)
//}
//
//class NetworkService: PloggingServiceProtocol {
//
//    private var network: PloggingAPINetworkProtocol
//
//    init(network: PloggingAPINetworkProtocol) {
//        self.network = network
//    }

//    func getAPIPloggingList(completionHandler: @escaping (Result<[Plogging], Error>) -> Void) {
//
//        return network.callNetwork(router: PloggingRouter.getApiPloggingList, completionHandler: { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let data):
//                    print(data)
//                    let fixer = self.transformToFixer(data: data)
//                    completionHandler(.success(fixer))
//                case .failure(let error):
//                    print(error)
//                    completionHandler(.failure(error))
//                }
//            }
//        })

//        let firestoreDataBase = Firestore.firestore()
//        firestoreDataBase.collection("ploggingList").getDocuments { snapshot, error in
//
//            if error == nil && snapshot != nil {
//                for ploggingDocumentList in snapshot!.documents {
//                    let ploggingDocument = ploggingDocumentList.data()
//                    var ploggingToDisplay: Plogging = Plogging()
//
//                    for pair in ploggingDocument {
//                        switch pair.key {
//                        case "id":
//                            ploggingToDisplay.id = pair.value as? String ?? ""
//                        case "admin":
//                            ploggingToDisplay.admin = pair.value as? String ?? ""
//                        case "beginning":
//                            ploggingToDisplay.beginning = pair.value as? Int ?? 1
//                        case "distance":
//                            ploggingToDisplay.distance = pair.value as? Int ?? 2
//                        case "latitude":
//                            ploggingToDisplay.latitude = pair.value as? Double ?? 0
//                        case "longitude":
//                            ploggingToDisplay.longitude = pair.value as? Double ?? 0
//                        case "place":
//                            ploggingToDisplay.place = pair.value as? String ?? ""
//                        case "ploggers":
//                            ploggingToDisplay.ploggers = pair.value as? [String] ?? [""]
//                        default:
//                            break
//                        }
//                    }
//                    ploggingList.append(ploggingToDisplay)
//                }

//                let ploggingList: [Plogging] = self.convertAPIDocumentToPlogging(snapshot: snapshot!)
//                    completionHandler(.success(ploggingList))
//                } else {
//                    completionHandler(.failure(ErrorType.network))
//            }
//        }
//    }

//    private func convertAPIDocumentToPlogging(snapshot: QuerySnapshot)-> [Plogging] {
//        var ploggingList: [Plogging] = []
//
//        for ploggingDocumentList in snapshot.documents {
//            let ploggingDocument = ploggingDocumentList.data()
//            var ploggingToDisplay: Plogging = Plogging()
//
//            for pair in ploggingDocument {
//                switch pair.key {
//                case "id":
//                    ploggingToDisplay.id = pair.value as? String ?? ""
//                case "admin":
//                    ploggingToDisplay.admin = pair.value as? String ?? ""
//                case "beginning":
//                    ploggingToDisplay.beginning = pair.value as? Int ?? 1
//                case "distance":
//                    ploggingToDisplay.distance = pair.value as? Int ?? 2
//                case "latitude":
//                    ploggingToDisplay.latitude = pair.value as? Double ?? 0
//                case "longitude":
//                    ploggingToDisplay.longitude = pair.value as? Double ?? 0
//                case "place":
//                    ploggingToDisplay.place = pair.value as? String ?? ""
//                case "ploggers":
//                    ploggingToDisplay.ploggers = pair.value as? [String] ?? [""]
//                default:
//                    break
//                }
//            }
//            ploggingList.append(ploggingToDisplay)
//        }
//        return ploggingList
//    }
//
//    func createOrUpdateAPIPlogging(plogging: Plogging, completionHandler: @escaping (Result<FirebaseResult, Error>) -> Void) {
//
//        return network.callNetwork(router: PloggingRouter.createApiPlogging, completionHandler: { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    completionHandler(.success(FirebaseResult.success))
//                case .failure(let error):
//                    completionHandler(.failure(error))
//                }
//            }
//        })

//        let ploggingDoc: [String: Any] = [
//            "admin": plogging.admin,
//            "beginning": plogging.beginning,
//            "distance": plogging.distance,
//            "id": plogging.id,
//            "latitude": plogging.latitude,
//            "longitude": plogging.longitude,
//            "place": plogging.place,
//            "ploggers": plogging.ploggers
//        ]
//
//        let firestoreDatabase = Firestore.firestore()
//        firestoreDatabase.collection("ploggingList").document(plogging.id).setData(ploggingDoc) { error in
//            if error == nil {
//                completionHandler(.success(FirebaseResult.success))
//            } else {
//                completionHandler(.failure(ErrorType.network))
//            }
//        }
//    }

    func uploadPhoto(mainImageBinary: Data, ploggingId: String, completionHandler: @escaping (Result<FirebaseResult, ErrorType>) -> Void) {

        let path = "images/\(ploggingId).jpg"
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(path)

        fileRef.putData(mainImageBinary, metadata: nil) { metadata, error in
            let firestoreDatabase = Firestore.firestore()
            firestoreDatabase.collection("images").document().setData(["url": path])

            if error == nil && metadata != nil {
                completionHandler(.success(FirebaseResult.success))
            } else {
                completionHandler(.failure(ErrorType.network))
            }
        }
    }

//    func getPloggingImage(ploggingId: String, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
//
//        let path = "images/\(ploggingId).jpg"
//        let storageRef = Storage.storage().reference()
//        let fileRef = storageRef.child(path)
//
//        fileRef.getData(maxSize: 5 * 1024 * 1024) { result in
//            switch result {
//            case .success(let data):
//                if let image = UIImage(data: data) {
//                    completionHandler(.success(image))
//                }
//            case .failure(let error):
//                completionHandler(.failure(error))
//            }
//        }
//    }
//}
