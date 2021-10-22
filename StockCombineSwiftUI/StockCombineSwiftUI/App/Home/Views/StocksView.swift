//
//  ContentView.swift
//  Stocks
//
//  Created by Marlon David Ruiz Arroyave on 18/10/21.
//

import SwiftUI
import Combine

struct StocksView: View {
    @StateObject var viewModel: StocksViewModel
    @State var searchText: String = ""

    init(viewModel: StocksViewModel = StocksViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            SearchNavigation(text: $searchText, search: search, cancel: cancel) {

                List {
                    ForEach(viewModel.stocks ?? [], id: \.self) { stock in
                        StockCardView(viewModel: viewModel.makeViewModelForStock(stock))
                    }
                }
                .alert(item: $viewModel.alertMessage) { error in
                    Alert(
                        title: Text(error.title),
                        message: Text(error.description)
                    )
                }
                .listStyle(.plain)
                .navigationTitle("Stocks")
            }
            spinner
        }
    }

}

extension StocksView {
    private var spinner: some View {
        ProgressView()
            .opacity(viewModel.isSearching ? 1 : 0)
    }

    // Search action. Called when search key pressed on keyboard
    private func search() {
        viewModel.updateSearchResults(for: searchText)
    }

    // Cancel action. Called when cancel button of search bar pressed
    private func cancel() {
        viewModel.cancelButtonTapped()
    }
}

struct StocksView_Previews: PreviewProvider {
    static var previews: some View {
        StocksView()
    }
}
