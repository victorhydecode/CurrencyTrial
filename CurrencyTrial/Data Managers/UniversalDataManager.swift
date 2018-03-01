//
//  UniversalDataManager.swift
//  CurrencyTrial
//
//  Created by Victor Hyde on 01/03/2018.
//  Copyright © 2018 Victor Hyde. All rights reserved.
//

import Foundation

/// Загружает типизированные данные из сети.
/// Использует `SimpleDataManager` для загрузки данных типа Data.
class UniversalDataManager {

    /// Загружает данные типа Data.
    private let dataManager = SimpleDataManager()

    // MARK: - Requesting Data

    /// Общий для всех запросов метод
    /// - parameters:
    ///     - request: запрос
    ///     - completion: блок выполнения после запроса (данные или ошибка)
    ///     - process: блок преобразования Data в нужный тип
    private func fetch<T>(request: URLRequest,
                          completion: @escaping (T?, DataManagerError?) -> (),
                          process: @escaping (Data) -> T?) {

        dataManager.fetchData(request: request) {
            (data, error) in {

                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    if let result = process(data) {
                        completion(result, nil)
                    } else {
                        completion(nil, .invalidResponse("Not a valid data"))
                    }
                }

            }()
        }

    }

    /// Запрашивает Decodable.
    /// - parameters:
    ///     - request: запрос
    ///     - completion: блок выполнения после запроса (данные или ошибка)
    func fetchDecodable<T: Decodable>(request: URLRequest, completion: @escaping (T?, DataManagerError?) -> ()) {

        fetch(request: request, completion: completion) {
            (data: Data) -> T? in
            do {
                let decoded: T = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                return nil
            }
        }

    }

}
