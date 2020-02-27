//
//  StoryboardViewController.swift
//  Example
//
//  Created by Alex Yanski on 2/7/20.
//  Copyright © 2020 Touchlane LLC. All rights reserved.
//

import CampcotCollectionView
import UIKit

class StoryboardViewController: UIViewController {
    @IBOutlet var collectionView: CampcotCollectionView!

    let itemsInRow = 2
    var itemsInSection: [Int: Int] = [:]

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

extension StoryboardViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfItems = itemsInSection[section] {
            return numberOfItems
        }
        let numberOfItems = Int.random(in: 1...6)
        itemsInSection[section] = numberOfItems
        return numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! CustomCollectionViewCell
        cell.text = "\(indexPath.section):\(indexPath.row)"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CustomHeaderView.reuseIdentifier,
            for: indexPath
        ) as! CustomHeaderView
        view.section = indexPath.section
        view.text = "section: \(indexPath.section)"
        view.delegate = self
        return view
    }
}

extension StoryboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interitemSpacing = self.collectionView.minimumInteritemSpacing * CGFloat(itemsInRow - 1)
        let totalSpacing = collectionView.bounds.width - self.collectionView.sectionInset.left - self.collectionView.sectionInset.right - interitemSpacing
        let width = totalSpacing / CGFloat(itemsInRow)
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
    }
}

extension StoryboardViewController: CustomHeaderViewDelegate {
    func selectSection(section: Int) {
        collectionView.toggle(to: section, animated: true)
    }
}
