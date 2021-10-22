//
//  StockCardView.swift
//  StockCombineSwiftUI
//
//  Created by Marlon David Ruiz Arroyave on 18/10/21.
//

import SwiftUI

struct StockCardView: View {

    @StateObject var viewModel: StockViewModel

    init(viewModel: StockViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(viewModel.symbol)
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                Text(viewModel.price)
                    .font(.system(size: 20))
                    .bold()
            }
            Text(viewModel.name)
                .font(.system(size: 17))
                .bold()
                .opacity(0.60)
        }
    }
}

struct StockCardView_Previews: PreviewProvider {
    static var previews: some View {
        let stock = Stock(symbol: "AAPL", companyName: "Apple Inc.", price: "144.84")
        let viewModel = StockViewModel(stock: stock)
        StockCardView(viewModel: viewModel)
    }
}
