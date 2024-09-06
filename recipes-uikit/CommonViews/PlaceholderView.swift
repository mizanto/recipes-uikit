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
                return "No favorite recipes"
            case .noHistory:
                return "No history available"
            }
        }
    }

    private let imageView = UIImageView()
    private let label = UILabel()

    init(type: PlaceholderType) {
        super.init(frame: .zero)
        setupView()
        configure(with: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(imageView)
        addSubview(label)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 21)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
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
