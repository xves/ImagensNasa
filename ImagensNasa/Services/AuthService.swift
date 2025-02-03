//
//  AuthService.swift
//  ImagensNasa
//
//  Created by Ivan Chaves on 30/01/25.
//

import Foundation
import Alamofire


class AuthService {
    private let baseURL = "https://api.nasa.gov/planetary/apod"
    private let api_key = "eC0BXpaohWFVmrMD9g5f8PlbmF4MsChx1s5KdePx"
    
    func getImage(date: String, completion: @escaping (Result<Dados, Error>) -> Void) {
        let url = "\(baseURL)?api_key=\(api_key)&date=\(date)"

        AF.request(url, method: .get).response { response in
            if let error = response.error {
                completion(.failure(error))
                print("Erro na requisição: \(error.localizedDescription)")
                return
            }

            guard let data = response.data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Dados ausentes na resposta"])
                completion(.failure(error))
                print("Erro: Dados ausentes na resposta")
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Resposta da API: \(jsonString)")
            }

            do {
                let result = try JSONDecoder().decode(Dados.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
                print("Erro ao decodificar: \(error.localizedDescription)")
            }
        }
    }

    
}
