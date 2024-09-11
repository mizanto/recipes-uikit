//
//  FavoriteRecipeCollectionViewCell.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import UIKit

class FavoriteRecipeCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavoriteRecipeCollectionViewCell"

    private lazy var imageView: UIImageView = createImageView()
    private lazy var titleLabel: UILabel = createTitleLabel()
    private lazy var categoryLabel: PaddedLabel = createTagLabel(color: .systemYellow)
    private lazy var areaLabel: PaddedLabel = createTagLabel(color: .systemGreen)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }

    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func createTagLabel(color: UIColor) -> PaddedLabel {
        let label = PaddedLabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = color
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
