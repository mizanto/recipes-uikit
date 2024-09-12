//
//  HistoryTableViewCell.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    static let identifier = "HistoryTableViewCell"

    private var mealNameLabel: UILabel!
    private var dateAddedLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeUIComponents()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeUIComponents() {
        mealNameLabel = .textLabel()
        dateAddedLabel = .secondaryLabel()
    }

    private func setupLayout() {
        contentView.addSubview(mealNameLabel)
        contentView.addSubview(dateAddedLabel)

        NSLayoutConstraint.activate([
            mealNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mealNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mealNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            dateAddedLabel.leadingAnchor.constraint(equalTo: mealNameLabel.leadingAnchor),
            dateAddedLabel.topAnchor.constraint(equalTo: mealNameLabel.bottomAnchor, constant: 4),
            dateAddedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with viewModel: HistoryViewModel) {
        mealNameLabel.text = viewModel.mealName
        dateAddedLabel.text = viewModel.dateAdded
    }
}
