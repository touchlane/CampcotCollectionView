//
//  HeaderView.swift
//  Example
//
//  Created by Panda Systems on 1/8/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    func didTapped(at indexPath: IndexPath)
}

class HeaderView: UICollectionReusableView {
        
    @IBOutlet weak var headerTitle: UILabel!

    var indexPath: IndexPath!
    
    weak var delegate: HeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleTap() {
        self.delegate?.didTapped(at: self.indexPath)
    }
}
