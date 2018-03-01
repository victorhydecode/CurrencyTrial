//
//  Configuration.swift
//  CurrencyTrial
//
//  Created by Victor Hyde on 01/03/2018.
//  Copyright © 2018 Victor Hyde. All rights reserved.
//

import Foundation

/// Конфигурация
enum Configuration {

    /// Ссылка на данные
    static let currencyUrl = "http://phisix-api3.appspot.com/stocks.json"

    /// Запрос
    static let currencyUrlRequest: URLRequest = {
        return URLRequest(url: URL(string: currencyUrl)!)
    }()

}
