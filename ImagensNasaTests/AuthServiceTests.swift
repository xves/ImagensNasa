//
//  AuthServiceTests.swift
//  ImagensNasaTests
//
//  Created by Ivan Chaves on 02/02/25.
//


import XCTest
import Testing
@testable import ImagensNasa

class AuthServiceTests: XCTestCase {
    
    var service: AuthService!
    
    override func setUp() {
        super.setUp()
        service = AuthService()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    // MARK: ✅ Teste de Sucesso
    func testGetImage_Success() {
        let expectation = self.expectation(description: "Requisição bem-sucedida")
        
        service.getImage(date: "2025-01-01") { result in
            switch result {
            case .success(let dados):
                XCTAssertNotNil(dados.url, "A URL da imagem não deve ser nula")
                XCTAssertEqual(dados.mediaType, "image", "O tipo de mídia deve ser 'image'")
                XCTAssertEqual(dados.date, "2025-01-01", "A data deve ser a mesma que foi solicitada")
            case .failure(let error):
                XCTFail("A requisição falhou com erro: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // MARK: ❌ Teste de Falha (Erro de Requisição)
    func testGetImage_Failure() {
        let expectation = self.expectation(description: "Requisição falhou")
        
        service.getImage(date: "0000-00-00") { result in
            switch result {
            case .success:
                XCTFail("O teste deveria falhar, mas obteve sucesso")
            case .failure(let error):
                XCTAssertNotNil(error, "O erro deve existir")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
