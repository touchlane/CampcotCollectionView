//
//  StoryboardViewController.swift
//  Example
//
//  Created by Alex Yanski on 2/7/20.
//  Copyright © 2020 Touchlane LLC. All rights reserved.
//

import UIKit
import CampcotCollectionView

class StoryboardViewController: UIViewController {

    @IBOutlet weak var collectionView: CampcotCollectionView!

    let backgroundColor = UIColor(red: 189 / 255, green: 195 / 255, blue: 199 / 255, alpha: 1)

    let itemsInRow = 2
    var itemsInSection: [Int: Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        self.collectionView.backgroundColor = backgroundColor
        self.collectionView.clipsToBounds = true
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
        self.collectionView.toggle(to: section, animated: true)
    }
}
