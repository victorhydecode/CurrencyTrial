//
//  CurrencyTableViewCell.swift
//  CurrencyTrial
//
//  Created by Victor Hyde on 01/03/2018.
//  Copyright © 2018 Victor Hyde. All rights reserved.
//

import UIKit

/// Ячейка таблицы. Отображает название, количество и цену.
class CurrencyTableViewCell: UITableViewCell {

    static let reuseIdentifier = "CurrencyTableViewCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    private var widthLayoutConstraint: NSLayoutConstraint!

    /// Конфигурирует ячейку
    func configure(with viewModel: CurrencyListItemViewModel) {
        nameLabel.text = viewModel.name
        volumeLabel.text = viewModel.volume
        amountLabel.text = viewModel.amount

        setupLabelSizeFitText(label: volumeLabel)
    }

    /// Устанавливает констрейнт ширины такой, чтобы влез весь текст
    private func setupLabelSizeFitText(label: UILabel) {

        let widthOfText = label.intrinsicContentSize.width
        if let widthLayoutConstraint = widthLayoutConstraint {
            NSLayoutConstraint.deactivate([
                widthLayoutConstraint
                ])
        }
        widthLayoutConstraint = label.widthAnchor.constraint(equalToConstant: widthOfText)
        NSLayoutConstraint.activate([
            widthLayoutConstraint
            ])

    }
}
