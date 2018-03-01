//
//  ViewController.swift
//  CurrencyTrial
//
//  Created by Victor Hyde on 01/03/2018.
//  Copyright © 2018 Victor Hyde. All rights reserved.
//

import UIKit
import os.log

/// Контроллер таблицы валют
class CurrencyTableViewController: UITableViewController {

    /// Интервал обновления таблицы
    private let updateTimeIntervalInSeconds = 15.0

    /// Слой запрашивающий данные
    private let dataManager = UniversalDataManager()

    /// Запрос данных
    private let urlRequest = Configuration.currencyUrlRequest

    /// Делегат таблицы (загружает данные)
    private var delegate: CurrencyTableViewControllerDelegate?

    /// Таймер считающий промежутки между обновлениями
    private var timer: Timer?

    /// Состояние ожидания данных
    var loadWaiting = false

    /// Форматтер времени для заголовка
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()

    /// View Model данных (MVVM)
    private var viewModel: CurrencyListViewModel? {
        didSet {
            let currentTime = dateFormatter.string(from: Date())
            if viewModel == nil {
                updateView(nil, "Error occurred on " + currentTime)
            } else {
                updateView(tableView, "Updated on " + currentTime)
            }
            loadWaiting = false
            setTimer()
        }
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        delegate?.stockDataRequested()
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - Helper methods

    private func updateView(_ tableView: UITableView?, _ message: String) {
        tableView?.reloadData()
        self.title = message
    }

    private func setTimer() {
        // Убираем старый таймер если он есть, устанавливаем новый
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: updateTimeIntervalInSeconds, repeats: false) {
            [weak self]
            (timer) in
            os_log("timer fired", type: .debug)
            // Таймер запскает загрузку
            self?.delegate?.stockDataRequested()
        }
        os_log("timer settled", type: .debug)
    }

    // MARK: - Actions

    /// Нажатие на кнопку рефреш
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        os_log("refresh button tapped", type: .debug)
        timer?.invalidate()
        self.delegate?.stockDataRequested()
    }

}

// MARK: - Table View DataSource

extension CurrencyTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
            guard let viewModel = viewModel else {
                return 0
            }
            return viewModel.numberOfItems
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {

            var cell: CurrencyTableViewCell! = tableView.dequeueReusableCell(
                withIdentifier: CurrencyTableViewCell.reuseIdentifier,
                for: indexPath) as? CurrencyTableViewCell

            // Такого не должно произойти, но на всякий случай
            if cell == nil {
                cell = CurrencyTableViewCell()
            }

            // Конфигурируем ячейку
            if let cellViewModel = viewModel?.currencyListItemViewModel(for: indexPath.row) {
                cell.configure(with: cellViewModel)
            }

            return cell

    }

}

// MARK: - Currency Table ViewController Delegate

protocol CurrencyTableViewControllerDelegate {
    func stockDataRequested()
}

extension CurrencyTableViewController: CurrencyTableViewControllerDelegate {

    /// Запрашивает данные
    func stockDataRequested() {

        if loadWaiting {
            os_log("data requested rejected, already waiting", type: .debug)
            return
        }
        // Состояние ожидания данных
        loadWaiting = true

        dataManager.fetchDecodable(request: urlRequest) {

            (stockData: StockData?, error: Error?) in

            if let stockData = stockData {
                // Обрабатываем данные
                DispatchQueue.main.async {
                    self.viewModel = CurrencyListViewModel(stockData: stockData)
                    os_log("data settled", type: .debug)
                }
            } else {
                // Обрабатываем ошибку
                os_log("received no data, error message: %@",
                       type: .debug, error?.localizedDescription ?? "")
                DispatchQueue.main.async {
                    self.viewModel = nil
                }
            }

        }
    }

}
