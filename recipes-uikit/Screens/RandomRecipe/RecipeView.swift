//
//  RecipeView.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import UIKit
import Kingfisher

class RecipeView: UIView {
    // MARK: - UI Elements

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let ingredientsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ingredients"
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let areaLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .systemGreen
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Instructions"
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let youtubeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Watch on YouTube", for: .normal)
        button.backgroundColor = UIColor.systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let sourceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Source", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    // MARK: - Setup Layout

    private func setupLayout() {
        let buttonsStackView = UIStackView(arrangedSubviews: [youtubeButton, sourceButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 16
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addSubview(categoryLabel)
        imageView.addSubview(areaLabel)
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            ingredientsTitleLabel,
            ingredientsLabel,
            instructionsTitleLabel,
            instructionsLabel,
            buttonsStackView,
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
            
            categoryLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16),
            categoryLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            
            areaLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
            areaLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            
            youtubeButton.heightAnchor.constraint(equalToConstant: 44),
            sourceButton.heightAnchor.constraint(equalToConstant: 44),
        ])

        youtubeButton.addTarget(self, action: #selector(openYoutube), for: .touchUpInside)
        sourceButton.addTarget(self, action: #selector(openSource), for: .touchUpInside)
    }
    
    // MARK: - Configure View

    private var currentRecipe: Recipe?

    func configure(with recipe: Recipe) {
        currentRecipe = recipe
        imageView.kf.setImage(with: recipe.mealThumbURL)
        categoryLabel.text = recipe.category
        areaLabel.text = recipe.area
        setIngredientsText(recipe.ingredients.map { "\($0.name): \($0.measure)" }.joined(separator: "\n"))
        setInstructionsText(recipe.instructions)
    }

    // MARK: - Actions

    @objc private func openYoutube() {
        guard let url = currentRecipe?.youtubeURL else { return }
        UIApplication.shared.open(url)
    }

    @objc private func openSource() {
        guard let url = currentRecipe?.sourceURL else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - Helpers
    
    private func setIngredientsText(_ text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        let attributedString = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        ingredientsLabel.attributedText = attributedString
    }
    
    private func setInstructionsText(_ text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        let attributedString = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        instructionsLabel.attributedText = attributedString
    }
}
