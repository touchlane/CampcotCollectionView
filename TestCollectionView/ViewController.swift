//
//  ViewController.swift
//  TestCollectionView
//
//  Created by Panda Systems on 12/19/17.
//  Copyright © 2017 Panda Systems. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).sectionHeadersPinToVisibleBounds = true
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2000
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4 //Int(arc4random_uniform(7)) + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SuperCell
        
        cell.superLabel.text = "\(indexPath.section):\(indexPath.row)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderView
        view.headerTitle.text = "Section: \(indexPath.section)"
        
        view.delegate = self
        view.indexPath = indexPath
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 60)
    }
}

extension ViewController: HeaderViewDelegate {
    func didTapped(at indexPath: IndexPath) {
        var newLayout: UICollectionViewFlowLayout
        if let _ = collectionView.collectionViewLayout as? ExpandableLayout {
            newLayout = UICollectionViewFlowLayout()
            newLayout.sectionHeadersPinToVisibleBounds = true
            
        } else {
            newLayout = ExpandableLayout()
        }

        self.collectionView.setCollectionViewLayout(newLayout, animated: true, completion: { _ in

        })
    }
}

