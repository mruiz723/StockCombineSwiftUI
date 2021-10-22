//
//  StocksViewModelTests.swift
//  StockCombineSwiftUITests
//
//  Created by Marlon David Ruiz Arroyave on 19/10/21.
//

import XCTest
import Combine
@testable import StockCombineSwiftUI
import SwiftUI

class StocksViewModelTests: XCTestCase {

    private var stockRepositoryMock: StockRepositoryMock!
    private var viewModel: StocksViewModel!
    private let stock = Stock(symbol: "AAPL", companyName: "Apple Inc.", price: "144.84")
    private var cancellables = Set<AnyCancellable>()

    override func tearDownWithError() throws {
        stockRepositoryMock = nil
        viewModel = nil
        cancellables = []
    }

    func testInit() {
        stockRepositoryMock = StockRepositoryMock()
        viewModel = StocksViewModel(stockRepository: stockRepositoryMock)
        XCTAssertNil(viewModel.stocks, "stock should be nil")
    }

    func testLoadDataWithStocksResultShouldTriggerStocksWithNotNilValues() {
        // Given
        stockRepositoryMock = StockRepositoryMock()
        stockRepositoryMock.stocks = [stock]
        viewModel = StocksViewModel(stockRepository: stockRepositoryMock)
        let exp = expectation(description: "stocks should be called.")

        // When
        viewModel.$stocks
            .dropFirst()
            .sink { stock in
                // Then
                exp.fulfill()
                XCTAssertNotNil(stock, "stocks value should not be nil after excecuting it")
            }.store(in: &cancellables)

        viewModel.search(by: "A")
        waitForExpectations(timeout: 0.1)
    }

    func testLoadDataWithoutStocksResultShouldTriggerShowAlertEvent() {
        // Given
        stockRepositoryMock = StockRepositoryMock()
        viewModel = StocksViewModel(stockRepository: stockRepositoryMock)
        let exp = expectation(description: "alertMessage should be called")

        // When
        viewModel.$alertMessage
            .dropFirst()
            .sink { alertMessage in
                // Then
                exp.fulfill()
                XCTAssertNotNil(alertMessage, "alertMessage should not be nil after excecuting it")
            }.store(in: &cancellables)

        viewModel.search(by: "$")
        waitForExpectations(timeout: 0.1)
    }

    func testUpdateSearchResultsWithEmptyStringShouldTriggerStocksWithNilValue() {
        // Given
        stockRepositoryMock = StockRepositoryMock()
        viewModel = StocksViewModel(stockRepository: stockRepositoryMock)
        let exp = expectation(description: "Stocks should be called")

        // When
        viewModel.$stocks
            .dropFirst()
            .sink { stocks in
                // Then
                exp.fulfill()
                XCTAssertNil(stocks, "Stocks should be nil")
            }.store(in: &cancellables)

        viewModel.updateSearchResults(for: "")
        waitForExpectations(timeout: 0.1)
    }

        func testUpdateSearchResultsWithAStringShouldTriggerStocksWithNotNilValues() {
            // Given
            stockRepositoryMock = StockRepositoryMock()
            stockRepositoryMock.stocks = [stock]
            viewModel = StocksViewModel(stockRepository: stockRepositoryMock)
            let exp = expectation(description: "Stocks should be called")

            // When
            viewModel.$stocks
                .dropFirst()
                .sink { stocks in
                    // then
                    exp.fulfill()
                    XCTAssertNotNil(stocks, "stocks should not be nil after excecuting it")
                }.store(in: &cancellables)
            viewModel.updateSearchResults(for: "A")
            waitForExpectations(timeout: 0.1)
        }

        func testCancelButtonTappedShouldTriggerStocksWithNilValue() {
            // Given
            stockRepositoryMock = StockRepositoryMock()
            viewModel = StocksViewModel(stockRepository: stockRepositoryMock)
            let exp = expectation(description: "stock should be called")

            // When
            viewModel.$stocks
                .dropFirst()
                .sink { stocks in
                    exp.fulfill()
                    XCTAssertNil(stocks, "Stocks should be nil")
                }.store(in: &cancellables)

            viewModel.cancelButtonTapped()
            waitForExpectations(timeout: 0.1)
        }

        func testMakeViewModelForStockCellShouldReturnAStockViewModelObject() {
            // Given
            stockRepositoryMock = StockRepositoryMock()
            viewModel = StocksViewModel(stockRepository: stockRepositoryMock)

            // When
            let stockViewModel = viewModel.makeViewModelForStock(stock)

            // Then
            XCTAssertNotNil(stockViewModel, "stockViewModel should not be nil")
        }

}
