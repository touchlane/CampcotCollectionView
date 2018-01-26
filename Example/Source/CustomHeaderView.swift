//
//  CustomHeaderView.swift
//  Example
//
//  Created by Panda Systems on 1/8/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

import UIKit

protocol CustomHeaderViewDelegate: class {
    func selectSection(section: Int)
}

class CustomHeaderView: UICollectionReusableView {
    private let internalBackgroundColor = UIColor(red: 214.0 / 255.0, green: 218.0 / 255.0, blue: 231.0 / 255.0, alpha: 1)
    private let textLeadingOffset: CGFloat = 20
    private let textLabel = UILabel()
    
    weak var delegate: CustomHeaderViewDelegate?
    var section: Int?
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
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnView(sender:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.text = nil
        self.section = nil
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.layoutIfNeeded()
    }
    
    private func activateTextLabelConstraints(view: UIView, anchorView: UIView) {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: anchorView.leadingAnchor, constant: self.textLeadingOffset),
            view.centerYAnchor.constraint(equalTo: anchorView.centerYAnchor)]
        )
    }
    
    @objc private func tapOnView(sender: UIGestureRecognizer) {
        guard let section = self.section else {
            return
        }
        self.delegate?.selectSection(section: section)
    }
}
