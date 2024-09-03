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
    
    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemYellow
        return imageView
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
            contentView.addSubview(favoriteImageView)
            
            NSLayoutConstraint.activate([
                mealNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                mealNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                mealNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                
                favoriteImageView.leadingAnchor.constraint(equalTo: mealNameLabel.trailingAnchor, constant: 8),
                favoriteImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                favoriteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                favoriteImageView.widthAnchor.constraint(equalToConstant: 24),
                favoriteImageView.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
    
    func configure(with viewModel: HistoryViewModel) {
        mealNameLabel.text = viewModel.mealName
        if viewModel.isFavorite {
            favoriteImageView.image = UIImage(systemName: "star.fill")
        }
    }
}
