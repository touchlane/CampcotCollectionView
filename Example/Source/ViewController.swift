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
    
    let interitemSpacing: CGFloat = 10
    let lineSpacing: CGFloat = 10
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    let backgroundColor = UIColor(red: 189 / 255, green: 195 / 255, blue: 199 / 255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        self.collectionView.backgroundColor = backgroundColor
        self.collectionView.clipsToBounds = true
        self.collectionView.sectionInset = sectionInsets
        self.collectionView.minimumSectionSpacing = 1
        self.collectionView.minimumInteritemSpacing = interitemSpacing
        self.collectionView.minimumLineSpacing = lineSpacing
        self.collectionView.sectionHeadersPinToVisibleBounds = true
        self.collectionView.register(
            CustomCollectionViewCell.self,
            forCellWithReuseIdentifier: CustomCollectionViewCell.reuseIdentifier
        )
        self.collectionView.register(
            CustomHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
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
            view.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor)
            ])
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
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
        view.text = "section: \(indexPath.section)"
        view.delegate = self
        return view
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - sectionInsets.left - sectionInsets.right - interitemSpacing) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
    }
}

extension ViewController: CustomHeaderViewDelegate {
    func selectSection(section: Int) {
        self.collectionView.toggle(to: section, animated: true)
    }
}
