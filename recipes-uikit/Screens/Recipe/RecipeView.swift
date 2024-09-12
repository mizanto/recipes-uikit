//
//  RecipeView.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 2.09.2024.
//

import UIKit
import Kingfisher

class RecipeView: UIView {

    private var imageView: UIImageView!
    private var categoryLabel: PaddedLabel!
    private var areaLabel: PaddedLabel!
    private var ingredientsTitleLabel: UILabel!
    private var ingredientsLabel: UILabel!
    private var instructionsTitleLabel: UILabel!
    private var instructionsLabel: UILabel!
    private var youtubeButton: UIButton!
    private var sourceButton: UIButton!

    private var onYoutubeButtonTapped: VoidHandler?
    private var onSourceButtonTapped: VoidHandler?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUIComponents()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeUIComponents() {
        imageView = .imageView()
        imageView.accessibilityIdentifier = "RecipeImageView"

        categoryLabel = .tagLabel(color: .systemYellow)
        categoryLabel.accessibilityIdentifier = "CategoryLabel"

        areaLabel = .tagLabel(color: .systemGreen)
        areaLabel.accessibilityIdentifier = "AreaLabel"

        ingredientsTitleLabel = .titleLabel(text: NSLocalizedString("ingredients.title", comment: ""))
        ingredientsTitleLabel.accessibilityIdentifier = "IngredientsTitleLabel"

        ingredientsLabel = .textLabel()
        ingredientsLabel.accessibilityIdentifier = "IngredientsLabel"

        instructionsTitleLabel = .titleLabel(text: NSLocalizedString("instructions.title", comment: ""))
        instructionsTitleLabel.accessibilityIdentifier = "InstructionsTitleLabel"

        instructionsLabel = .textLabel()
        instructionsLabel.accessibilityIdentifier = "InstructionsLabel"

        youtubeButton = .linkButton(title: NSLocalizedString("youtube_button.title", comment: ""),
                                    action: UIAction { _ in self.onYoutubeButtonTapped?() })
        youtubeButton.accessibilityIdentifier = "YoutubeButton"

        sourceButton = .linkButton(title: NSLocalizedString("source_button.title", comment: ""),
                                   action: UIAction { _ in self.onSourceButtonTapped?() })
        sourceButton.accessibilityIdentifier = "SourceButton"
    }

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
            buttonsStackView
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
            sourceButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func configure(with viewModel: RecipeViewModel) {
        configureImageView(with: viewModel.mealThumbURL)
        configureLabels(with: viewModel)
        configureButtons(with: viewModel)
    }

    private func configureImageView(with url: URL?) {
        imageView.kf.setImage(with: url)
    }

    private func configureLabels(with viewModel: RecipeViewModel) {
        categoryLabel.text = viewModel.category
        areaLabel.text = viewModel.area
        setText(viewModel.ingredients, for: ingredientsLabel)
        setText(viewModel.instructions, for: instructionsLabel)

        categoryLabel.isHidden = viewModel.category?.isEmpty ?? true
        areaLabel.isHidden = viewModel.area?.isEmpty ?? true
    }

    private func configureButtons(with viewModel: RecipeViewModel) {
        onYoutubeButtonTapped = viewModel.onYoutubeButton
        onSourceButtonTapped = viewModel.onSourceButton

        youtubeButton.isHidden = viewModel.onYoutubeButton == nil
        sourceButton.isHidden = viewModel.onSourceButton == nil
    }

    private func setText(_ text: String, for label: UILabel) {
        label.attributedText = formattedText(text)
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
}
