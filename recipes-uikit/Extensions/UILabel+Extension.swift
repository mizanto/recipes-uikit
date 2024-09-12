//
//  UILabel+Extension.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 12.09.2024.
//

import UIKit

extension UILabel {
    static func titleLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func textLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    static func secondaryLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        }
}
