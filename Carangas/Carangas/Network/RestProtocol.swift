//
//  RestProtocol.swift
//  Carangas
//
//  Created by Luiz on 5/13/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

protocol RestProtocol {

    func save(car: Car, onComplete: @escaping (Result<Void, RestError>) -> Void)
    func update(car: Car, onComplete: @escaping (Result<Void, RestError>) -> Void)
    func delete(car: Car, onComplete: @escaping (Result<Void, RestError>) -> Void)
    func fetchCars(onComplete: @escaping(Result<[Car], RestError>) -> Void )
    func fetchBrands(onComplete: @escaping(Result<[Brand], RestError>) -> Void )
    
}
