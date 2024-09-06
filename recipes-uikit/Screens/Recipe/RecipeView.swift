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

    private lazy var imageView: UIImageView = createImageView()
    private lazy var categoryLabel: PaddedLabel = createTagLabel(color: .systemYellow)
    private lazy var areaLabel: PaddedLabel = createTagLabel(color: .systemGreen)
    private lazy var ingredientsTitleLabel: UILabel = createTitleLabel(text: NSLocalizedString("ingredients.title", comment: ""))
    private lazy var ingredientsLabel: UILabel = createTextLabel()
    private lazy var instructionsTitleLabel: UILabel = createTitleLabel(text: NSLocalizedString("instructions.title", comment: ""))
    private lazy var instructionsLabel: UILabel = createTextLabel()
    private lazy var youtubeButton: UIButton = createLinkButton(title: NSLocalizedString("youtube_button.title", comment: ""))
    private lazy var sourceButton: UIButton = createLinkButton(title: NSLocalizedString("source_button.title", comment: ""))
    
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

    private var currentRecipeURL: URL?
    private var currentSourceURL: URL?

    func configure(with viewModel: RandomRecipeViewModel) {
        imageView.kf.setImage(with: viewModel.mealThumbURL)
        categoryLabel.text = viewModel.category
        areaLabel.text = viewModel.area
        setIngredientsText(viewModel.ingredients)
        setInstructionsText(viewModel.instructions)
        
        youtubeButton.isHidden = viewModel.youtubeURL == nil
        sourceButton.isHidden = viewModel.sourceURL == nil
        categoryLabel.isHidden = viewModel.category == nil
        areaLabel.isHidden = viewModel.area == nil
        
        currentRecipeURL = viewModel.youtubeURL
        currentSourceURL = viewModel.sourceURL
    }

    // MARK: - Actions

    @objc private func openYoutube() {
        guard let url = currentRecipeURL else { return }
        UIApplication.shared.open(url)
    }

    @objc private func openSource() {
        guard let url = currentSourceURL else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - Helpers
    
    private func setIngredientsText(_ text: String) {
        ingredientsLabel.attributedText = formattedText(text)
    }
    
    private func setInstructionsText(_ text: String) {
        instructionsLabel.attributedText = formattedText(text)
    }
    
    private func formattedText(_ text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5

        let attributedString = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        
        return attributedString
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func createTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createTextLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createTagLabel(color: UIColor) -> PaddedLabel {
        let label = PaddedLabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.backgroundColor = color
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func createLinkButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
