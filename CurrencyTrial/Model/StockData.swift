//
//  StockData.swift
//  CurrencyTrial
//
//  Created by Victor Hyde on 01/03/2018.
//  Copyright © 2018 Victor Hyde. All rights reserved.
//

import Foundation

/// Массив валют
struct StockData: Decodable {
    let stock: [Currency]
}

/// Одна валюта
struct Currency: Decodable {
    /// Название
    let name: String
    /// Количество
    let volume: Int
    /// Цена
    let price: Price
}

/// Цена
struct Price: Decodable {
    let amount: Double
}
