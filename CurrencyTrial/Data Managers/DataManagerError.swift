//
//  DataManagerError.swift
//  CurrencyTrial
//
//  Created by Victor Hyde on 01/03/2018.
//  Copyright © 2018 Victor Hyde. All rights reserved.
//

import Foundation

/// Ошибки при запросах.
enum DataManagerError: Error, LocalizedError {

    /// Неизвестная ошибка
    case unknown

    /// Запрос не прошел
    case failedRequest(String)

    /// Неверный ответ
    case invalidResponse(String)

    public var errorDescription: String? {

        switch self {

        case .unknown:
            return "Something went wrong"

        case .failedRequest(let message):
            return "Request failed with message: \(message)"

        case .invalidResponse(let message):
            return "Unexpected response with message: \(message)"

        }

    }

}
