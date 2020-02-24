//
//  CustomCollectionViewCell.swift
//  Example
//
//  Created by Panda Systems on 1/8/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CustomCell"

    private let internalBackgroundColor = UIColor(red: 61 / 255, green: 86 / 255, blue: 166 / 255, alpha: 1)
    private let textLabel = UILabel()

    var text: String? {
        didSet {
            self.textLabel.text = text
        }
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        clipsToBounds = true
        backgroundColor = internalBackgroundColor
        layer.cornerRadius = 10
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .white
        addSubview(textLabel)
        activateTextLabelConstraints(view: textLabel, anchorView: self)
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        layoutIfNeeded()
    }

    private func activateTextLabelConstraints(view: UIView, anchorView: UIView) {
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: anchorView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: anchorView.centerYAnchor)
        ])
    }
}
