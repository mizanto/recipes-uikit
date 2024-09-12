//
//  UIImageView+Extension.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 12.09.2024.
//

import UIKit

extension UIImageView {
    static func imageView(cornerRadius: CGFloat = 8) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
