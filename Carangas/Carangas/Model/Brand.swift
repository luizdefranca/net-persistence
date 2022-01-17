//  Brand.swift
//  Carangas
//

import Foundation

struct Brand: Codable {
    let fipeName: String
    let codigo: String

    enum CodingKeys: String, CodingKey {
        case fipeName = "nome"
        case codigo
    }
}

struct NewBrand: Codable {
    // Atributos devem ser baseados no backend do servidor:
    // baseado na referencia 25 do site: https://deividfortuna.github.io/fipe/
    
    var codigo: String
    var nome: String
}
