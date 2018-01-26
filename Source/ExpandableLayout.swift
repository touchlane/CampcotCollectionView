//
//  ExpandableLayout.swift
//  ExpandableLayout
//
//  Created by Vadim Morozov on 1/26/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

import UIKit

public class ExpandableLayout: UICollectionViewFlowLayout  {
    var expanded: Bool = false {
        didSet {
            self.invalidateLayout()
        }
    }
    
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override public var collectionViewContentSize: CGSize {
        if !expanded {
            return CGSize(width: contentWidth, height: contentHeight)
        }
        else {
            return super.collectionViewContentSize
        }
    }
    
    private var headersAttributes: [UICollectionViewLayoutAttributes] = []
    private var itemsAttributes: [[UICollectionViewLayoutAttributes]] = []
    
    override public func prepare() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
            return
        }
        
        guard let dataSource = collectionView.dataSource else {
            return
        }
        
        if !expanded {
            headersAttributes = []
            itemsAttributes = []
            
            contentHeight = 0
            let numberOfSections = dataSource.numberOfSections!(in: collectionView)
            for section in 0..<numberOfSections {
                
                let headerSize = delegate.collectionView!(collectionView, layout: self, referenceSizeForHeaderInSection: section)
                let height = headerSize.height
                let width = headerSize.width
                
                let indexPath = IndexPath(row: 0, section: section)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
                attributes.frame = CGRect(x: 0, y: contentHeight, width: width, height: height)
                headersAttributes.append(attributes)
                
                contentHeight += height
                
                
                let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
                //                var array: [UICollectionViewLayoutAttributes] = []
                //                array.reserveCapacity(numberOfItems)
                itemsAttributes.append([])
                for row in 0..<numberOfItems {
                    let indexPath = IndexPath(row: row, section: section)
                    let itemSize = delegate.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    if row % 2 == 0 {
                        attributes.frame = CGRect(x: 0, y: contentHeight, width: itemSize.width, height: 0)
                    }
                    else {
                        attributes.frame = CGRect(x: self.collectionViewContentSize.width - itemSize.width, y: contentHeight, width: itemSize.width, height: 0)
                    }
                    attributes.isHidden = true
                    itemsAttributes[section].append(attributes)
                }
            }
            print("custom prepare")
        }
        else {
            super.prepare()
        }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if !expanded {
            var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
            
            for attributes in headersAttributes {
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
            return visibleLayoutAttributes
        }
        else {
            return super.layoutAttributesForElements(in: rect)
        }
    }
    
    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if !expanded {
            return self.headersAttributes[indexPath.section]
        }
        else {
            return super.layoutAttributesForItem(at: indexPath)
        }
    }
    
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) ->  UICollectionViewLayoutAttributes? {
        if !expanded {
            return self.itemsAttributes[indexPath.section][indexPath.row]
        }
        else {
            return super.layoutAttributesForItem(at: indexPath)
        }
    }
}
