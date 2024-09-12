//
//  UIButton+Extension.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 12.09.2024.
//

import UIKit

extension UIButton {
    static func linkButton(title: String, action: UIAction) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(action, for: .touchUpInside)
        return button
    }
}
