//
//  StockViewModelTests.swift
//  StockCombineSwiftUITests
//
//  Created by Marlon David Ruiz Arroyave on 21/10/21.
//

import XCTest
import Combine
@testable import StockCombineSwiftUI

class StockViewModelTests: XCTestCase {

    private var viewModel: StockViewModel!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() async throws {
        let stock = Stock(symbol: "AAPL", companyName: "Apple Inc.", price: "144.84")
        viewModel = StockViewModel(stock: stock)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testInitShouldTriggerSymbolValue() {
        // Given
        let exp = expectation(description: "symbol should be called")

        // When
        viewModel.$symbol
            .sink { symbol in
                exp.fulfill()
                // Then
                XCTAssertNotNil(symbol, "symbol value should not be nil after excecuting it")
            }.store(in: &cancellables)
        waitForExpectations(timeout: 0.1)
    }

    func testInitShouldTriggerCompanyNameValue() {
        // Given
        let exp = expectation(description: "name should be called")

        // When
        viewModel.$name
            .sink { name in
                exp.fulfill()
                // Then
                XCTAssertNotNil(name, "name value should not be nil after excecuting it")
            }.store(in: &cancellables)

        waitForExpectations(timeout: 0.1)
    }

    func testInitShouldTriggerPriceValue() {
        // Given
        let exp = expectation(description: "price should be called")

        // When
        viewModel.$price
            .sink { price in
                exp.fulfill()
                // Then
                XCTAssertNotNil(price, "price value should not be nil after excecuting it")
            }.store(in: &cancellables)

        waitForExpectations(timeout: 0.1)
    }

}
