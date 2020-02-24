//
//  CustomHeaderView.swift
//  Example
//
//  Created by Panda Systems on 1/8/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

import UIKit

protocol CustomHeaderViewDelegate: AnyObject {
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
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = internalBackgroundColor
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .white
        textLabel.textAlignment = .center
        textLabel.font = UIFont.boldSystemFont(ofSize: 24)
        addSubview(textLabel)
        activateTextLabelConstraints(view: textLabel, anchorView: self)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnView(sender:)))
        addGestureRecognizer(tapRecognizer)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        text = nil
        section = nil
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        layoutIfNeeded()
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
        delegate?.selectSection(section: section)
    }
}
