//
//  FavoriteRecipeCollectionViewCell.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import UIKit

class FavoriteRecipeCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoriteRecipeCollectionViewCell"

    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var categoryLabel: PaddedLabel!
    private var areaLabel: PaddedLabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUIComponents()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeUIComponents() {
        imageView = .imageView()
        titleLabel = .textLabel()
        categoryLabel = .tagLabel(color: .systemYellow)
        areaLabel = .tagLabel(color: .systemGreen)
    }

    private func setupLayout() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(areaLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            categoryLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            categoryLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 8),

            areaLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8),
            areaLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func configure(with viewModel: FavoriteRecipeViewModel) {
        imageView.kf.setImage(with: viewModel.imageUrl)
        titleLabel.text = viewModel.mealName
        categoryLabel.text = viewModel.category
        areaLabel.text = viewModel.area

        categoryLabel.isHidden = viewModel.category == nil
        areaLabel.isHidden = viewModel.area == nil
    }
}
