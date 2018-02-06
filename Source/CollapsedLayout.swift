//
//  CollapsedLayout.swift
//  CampcotCollectionView
//
//  Created by Vadim Morozov on 1/29/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

public class CollapsedLayout: UICollectionViewFlowLayout {
    var targetSection: Int = 0
    var offsetCorrection: CGFloat = 0
    var minimumSectionSpacing: CGFloat = 0 {
        didSet {
            self.invalidateLayout()
        }
    }
    
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = self.collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: max(contentHeight, self.collectionView?.bounds.size.height ?? 0))
    }
    
    override public var sectionInset: UIEdgeInsets {
        get {
            return super.sectionInset
        }
        set {
            super.sectionInset = UIEdgeInsets(top: 0, left: newValue.left, bottom: 0, right: newValue.right)
        }
    }
    
    private var headersAttributes: [UICollectionViewLayoutAttributes] = []
    private var itemsAttributes: [[UICollectionViewLayoutAttributes]] = []
    
    override public func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else {
            return
        }
        
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
            return
        }
        
        guard let dataSource = collectionView.dataSource else {
            return
        }
        self.headersAttributes = []
        self.itemsAttributes = []
        self.contentHeight = 0
        
        let numberOfSections = dataSource.numberOfSections!(in: collectionView)
        for section in 0..<numberOfSections {
            let headerSize = delegate.collectionView!(collectionView, layout: self, referenceSizeForHeaderInSection: section)
            let height = headerSize.height
            let width = headerSize.width
            let indexPath = IndexPath(row: 0, section: section)
            let attributes = UICollectionViewLayoutAttributes(
                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                with: indexPath
            )
            attributes.frame = CGRect(x: 0, y: self.contentHeight, width: width, height: height)
            self.headersAttributes.append(attributes)
            self.contentHeight += height
            self.contentHeight += self.minimumSectionSpacing / 2
            
            self.itemsAttributes.append([])
            let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
            for row in 0..<numberOfItems {
                let indexPath = IndexPath(row: row, section: section)
                let itemSize = delegate.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                if row % 2 == 0 {
                    attributes.frame = CGRect(
                        x: self.sectionInset.left,
                        y: contentHeight,
                        width: itemSize.width,
                        height: 0
                    )
                }
                else {
                    attributes.frame = CGRect(
                        x: self.sectionInset.left + itemSize.width + self.minimumInteritemSpacing,
                        y: contentHeight,
                        width: itemSize.width,
                        height: 0
                    )
                }
                attributes.isHidden = true
                self.itemsAttributes[section].append(attributes)
            }
            self.contentHeight += self.minimumSectionSpacing / 2
        }
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        
        for attributes in headersAttributes {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard self.headersAttributes.indices.contains(indexPath.section) else {
            return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        }
        return self.headersAttributes[indexPath.section]
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) ->  UICollectionViewLayoutAttributes? {
        guard self.itemsAttributes.indices.contains(indexPath.section) else {
            return super.layoutAttributesForItem(at: indexPath)
        }
        guard self.itemsAttributes[indexPath.section].indices.contains(indexPath.row) else {
            return super.layoutAttributesForItem(at: indexPath)
        }
        return self.itemsAttributes[indexPath.section][indexPath.row]
    }
    
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        var targetOffset = proposedContentOffset
        targetOffset.y = 0
        for section in 0..<self.targetSection {
            let height = self.headersAttributes[section].frame.size.height
            targetOffset.y += height
            targetOffset.y += minimumSectionSpacing
        }
        if self.contentHeight < self.collectionViewContentSize.height {
            let emptySpace = self.collectionViewContentSize.height - targetOffset.y
            if emptySpace > 0 {
                targetOffset.y = 0
            }
        }
        targetOffset.y += self.offsetCorrection
        return targetOffset
    }
}
