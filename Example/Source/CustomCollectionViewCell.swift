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
        self.clipsToBounds = true
        self.backgroundColor = self.internalBackgroundColor
        self.layer.cornerRadius = 10
        self.textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.textColor = .white
        self.addSubview(self.textLabel)
        self.activateTextLabelConstraints(view: self.textLabel, anchorView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.layoutIfNeeded()
    }
    
    private func activateTextLabelConstraints(view: UIView, anchorView: UIView) {
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: anchorView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: anchorView.centerYAnchor)]
        )
    }
}
