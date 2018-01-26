//
//  CustomCollectionViewCell.swift
//  Example
//
//  Created by Panda Systems on 1/8/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    private let internalBackgroundColor = UIColor(red: 59.0 / 255.0, green: 128.0 / 255.0, blue: 144.0 / 255.0, alpha: 1)
    private let textLabel = UILabel()
    
    var text: String? {
        didSet {
            self.textLabel.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = self.internalBackgroundColor
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
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
