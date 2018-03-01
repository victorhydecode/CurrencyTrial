//
//  CurrencyListItemViewModel.swift
//  CurrencyTrial
//
//  Created by Victor Hyde on 01/03/2018.
//  Copyright © 2018 Victor Hyde. All rights reserved.
//

import Foundation

/// View Model данных одной валюты.
struct CurrencyListItemViewModel {

    /// Данные о валюте
    let currency: Currency

    /// Форматтер количества (целое число)
    private let volumeFormatter: NumberFormatter = {
        let volumeFormatter = NumberFormatter()
        volumeFormatter.usesGroupingSeparator = true
        volumeFormatter.numberStyle = .decimal
        volumeFormatter.maximumFractionDigits = 0
        return volumeFormatter
    }()

    /// Форматтер цены (дво знака после запятой)
    private let amountFormatter: NumberFormatter = {
        let amountFormatter = NumberFormatter()
        amountFormatter.usesGroupingSeparator = true
        amountFormatter.numberStyle = .decimal
        amountFormatter.maximumFractionDigits = 2
        amountFormatter.minimumFractionDigits = 2
        return amountFormatter
    }()

    /// Название
    var name: String {
        return currency.name
    }

    /// Количество
    var volume: String {
        return volumeFormatter.string(from: NSNumber(value: currency.volume)) ?? ""
    }

    /// Цена
    var amount: String {
        return amountFormatter.string(from: NSNumber(value: currency.price.amount)) ?? ""
    }

}
