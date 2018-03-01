//
//  SimpleDataManager.swift
//  CurrencyTrial
//
//  Created by Victor Hyde on 01/03/2018.
//  Copyright © 2018 Victor Hyde. All rights reserved.
//

import Foundation
import os.log

///
/// Загружает данные формата Data
///
class SimpleDataManager {

    let successfulResponseCode = 200

    typealias Completion = (Data?, DataManagerError?) -> ()

    // MARK: - Requesting Data

    /// Запрашивает данные
    /// - parameters:
    ///     - request: запрос
    ///     - completion: блок выполнения после запроса (данные или ошибка)
    func fetchData(request: URLRequest, completion: @escaping Completion) {

        URLSession.shared.dataTask(with: request) {
            (data, response, error) in

            self.didFetchData(url: request.url?.absoluteString ?? "",
                              data: data, response: response,
                              error: error, completion: completion)

            }.resume()

    }

    // MARK: - Handling response

    /// Обрабатывает ответ на запрос
    private func didFetchData(
        url: String, data: Data?, response: URLResponse?,
        error: Error?, completion: Completion) {

        // Ошибка
        if let error = error {
            completion(nil, .failedRequest(error.localizedDescription))
            return
        }

        // Что-то не так с данными
        guard let data = data, let response = response as? HTTPURLResponse else {
            completion(nil, .unknown)
            return
        }

        // Не тот код ответа
        if response.statusCode != successfulResponseCode {
            if let result = String(data: data, encoding: .utf8) {
                os_log("Ответ: %@", type: .debug, result)
            }
            completion(nil, .failedRequest("Response status code \(response.statusCode)"))
            return
        }

        completion(data, nil)

    }

}
