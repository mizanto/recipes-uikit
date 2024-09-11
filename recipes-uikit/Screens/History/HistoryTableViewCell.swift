//
//  HistoryTableViewCell.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateAddedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
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
