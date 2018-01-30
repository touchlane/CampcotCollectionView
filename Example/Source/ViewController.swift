//
//  ViewController.swift
//  Example
//
//  Created by Panda Systems on 12/19/17.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

import UIKit
import CampcotCollectionView

class ViewController: UIViewController {
    
    let collectionView = CampcotCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.clipsToBounds = true
        self.collectionView.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        self.collectionView.minimumSectionSpacing = 1
        self.collectionView.minimumInteritemSpacing = 1
        self.collectionView.minimumLineSpacing = 1
        self.collectionView.sectionHeadersPinToVisibleBounds = true
        self.collectionView.register(
            CustomCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier
        )
        self.collectionView.register(
            CustomHeaderView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: CustomHeaderView.reuseIdentifier
        )
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        self.activateCollectionViewConstraints(view: self.collectionView, anchorView: self.view)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func activateCollectionViewConstraints(view: UIView, anchorView: UIView) {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: anchorView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: anchorView.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)]
        )
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4 //Int(arc4random_uniform(7)) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier,
            for: indexPath) as! CustomCollectionViewCell
        cell.text = "\(indexPath.section):\(indexPath.row)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CustomHeaderView.reuseIdentifier,
            for: indexPath) as! CustomHeaderView
        view.section = indexPath.section
        view.text = "Section: \(indexPath.section)"
        view.delegate = self
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 3) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
    }
}

extension ViewController: CustomHeaderViewDelegate {
    func selectSection(section: Int) {
        if self.collectionView.isExpanded {
            self.collectionView.collapse(to: section, animated: true)
        }
        else {
            self.collectionView.expand(from: section, animated: true)
        }
    }
}
