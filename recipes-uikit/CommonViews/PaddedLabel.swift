//
//  PaddedLabel.swift
//  recipes-uikit
//
//  Created by Sergey Bendak on 3.09.2024.
//

import UIKit

class PaddedLabel: UILabel {
    var padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}

extension PaddedLabel {
    static func tagLabel(color: UIColor) -> PaddedLabel {
        let label = PaddedLabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.backgroundColor = color
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
