//
//  ResultResponse.swift
//  ImagensNasa
//
//  Created by Ivan Chaves on 30/01/25.
//

import Foundation

struct ResultResponse: Codable {
    let dados: [Dados]
}

struct Dados: Codable {
    let date: String
    let explanation: String
    let hdurl: String?
    let mediaType: String
    let serviceVersion: String
    let title: String
    let url: String
    

    private enum CodingKeys: String, CodingKey {
        case date
        case explanation
        case hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title
        case url
    }
}

