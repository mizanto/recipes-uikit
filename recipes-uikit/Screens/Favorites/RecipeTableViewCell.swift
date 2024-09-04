//
//  RecipeTableViewCell.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 4.09.2024.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(mealNameLabel)
        addSubview(favoriteIcon)
        
        NSLayoutConstraint.activate([
            mealNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mealNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            favoriteIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            favoriteIcon.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(with viewModel: FavoriteRecipeViewModel) {
        mealNameLabel.text = viewModel.mealName
        favoriteIcon.isHidden = !viewModel.isFavorite
    }
}
