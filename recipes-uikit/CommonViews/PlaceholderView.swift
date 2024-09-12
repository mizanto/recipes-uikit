//
//  PlaceholderView.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 6.09.2024.
//

import UIKit

class PlaceholderView: UIView {

    enum PlaceholderType {
        case noFavorites
        case noHistory

        var image: UIImage? {
            switch self {
            case .noFavorites:
                return UIImage(systemName: "star")
            case .noHistory:
                return UIImage(systemName: "clock")
            }
        }

        var message: String {
            switch self {
            case .noFavorites:
                return NSLocalizedString("no_favorites_placeholder.message", comment: "")
            case .noHistory:
                return NSLocalizedString("no_history_placeholder.message", comment: "")
            }
        }
    }

    private let imageView = UIImageView()
    private let label = UILabel.textLabel()

    init(type: PlaceholderType) {
        super.init(frame: .zero)
        setupView()
        configure(with: type)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(imageView)
        addSubview(label)
        label.textAlignment = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),

            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    func configure(with type: PlaceholderType) {
        imageView.image = type.image
        label.text = type.message
    }
}
