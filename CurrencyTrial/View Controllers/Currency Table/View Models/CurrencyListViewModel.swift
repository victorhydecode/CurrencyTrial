//
//  CurrencyListViewModel.swift
//  CurrencyTrial
//
//  Created by Victor Hyde on 01/03/2018.
//  Copyright © 2018 Victor Hyde. All rights reserved.
//

import Foundation

/// View Model данных таблицы. Содержит список валют
/// и генерирует View Model для каждой ячейки.
struct CurrencyListViewModel {

    /// Данные о валютах
    let stockData: StockData

    /// Количество валют (= ячеек)
    var numberOfItems: Int {
        return stockData.stock.count
    }

    /// Генерирует View Model для ячейки по индексу.
    func currencyListItemViewModel(for index: Int) -> CurrencyListItemViewModel {
        return CurrencyListItemViewModel(currency: stockData.stock[index])
    }

}
