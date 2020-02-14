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
    static let reuseIdentifier = "CustomHeaderView"
    private let internalBackgroundColor = UIColor.purple
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
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        self.backgroundColor = self.internalBackgroundColor
        self.textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.textLabel.textColor = .white
        self.textLabel.textAlignment = .center
        self.textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.addSubview(self.textLabel)
        self.activateTextLabelConstraints(view: self.textLabel, anchorView: self)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnView(sender:)))
        self.addGestureRecognizer(tapRecognizer)
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
}

private typealias CustomHeaderViewPrivate = CustomHeaderView
private extension CustomHeaderViewPrivate {
    func activateTextLabelConstraints(view: UIView, anchorView: UIView) {
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: anchorView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: anchorView.centerYAnchor)
            ])
    }
    
    @objc func tapOnView(sender: UIGestureRecognizer) {
        guard let section = self.section else {
            return
        }
        self.delegate?.selectSection(section: section)
    }
}
