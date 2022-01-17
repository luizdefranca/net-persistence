//
//  AFRest.swift
//  Carangas
//
//  Created by Luiz Carlos F Ramos on 15/05/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation
import Alamofire


class AFRest: RestProtocol {
  
    static var shared: AFRest = {
        let instance = AFRest()
        // ... configure the instance
        // ...
        return instance
    }()
    
    /// The Singleton's initializer should always be private to prevent direct
    /// construction calls with the `new` operator.
    private init() {}
    
    func save(car: Car, onComplete: @escaping (Result<Void, RestError>) -> Void){
        applyOperation(car: car, operation: .save, onComplete: onComplete)
    }
    
   func update(car: Car, onComplete: @escaping (Result<Void, RestError>) -> Void) {
        applyOperation(car: car, operation: .update, onComplete: onComplete)
    }
    
   func delete(car: Car, onComplete: @escaping (Result<Void, RestError>) -> Void) {
        applyOperation(car: car, operation: .delete, onComplete: onComplete)
    }
    
    func fetchCars(onComplete: @escaping(Result<[Car], RestError>) -> Void ) {
        
        fetchDataOnURL(NetworkRoute.basePath.url()) { (response: Result<[Car], RestError>) in
            onComplete(response)
        }
        
    }
    
 func fetchBrands(onComplete: @escaping(Result<[Brand], RestError>) -> Void ) {
        
        fetchDataOnURL(NetworkRoute.fipeTable.url()) { (response: Result<[Brand], RestError>) in
            onComplete(response)
        }
        
    }
    
    private func fetchDataOnURL<T>(_ url: String, onComplete: @escaping (Result<T, RestError>) -> Void) where T : Decodable, T : Encodable {
        AF.request(url)
            .responseDecodable(of: T.self){ response in
                
                switch response.result {
                case .success(_):
                    guard let data = response.value else {
                        print("\(RestError.noData) - \(#file) - \(#function) - \(#line)")
                        onComplete(.failure(.noData))
                        return
                    }
                    onComplete(.success(data))
                case .failure(let error):
                    print(error.errorDescription!)
                    onComplete(.failure(RestError.alamofireError(description: error.localizedDescription)))
                }
                
            }
    }
    
    private func applyOperation(car: Car, operation: RestOperator , onComplete:  @escaping(Result<Void, RestError>)-> Void ) {
        
        let urlString = NetworkRoute.basePath.rawValue + "/" + (car._id ?? "")
        
        var httpMethod : HTTPMethod
        
        switch operation {
        case .delete:
            httpMethod = .delete
            print("Delete Method")
        case .save:
            print("Save Method")
            httpMethod = .post
        case .update:
            print("Update Method")
            httpMethod = .put
        }
        
        AF.request(urlString, method: httpMethod, parameters: car, encoder: JSONParameterEncoder.default).response {
            response in
            
            switch response.result {
            case .success(_):
                onComplete(.success(Void()))
            case .failure(let error):
                onComplete(.failure(.alamofireError(description: error.errorDescription!)))
            }
        }
    }
}
