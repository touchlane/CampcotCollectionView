//
//  ExpandedLayout.swift
//  CampcotCollectionView
//
//  Created by Vadim Morozov on 1/26/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

public class ExpandedLayout: UICollectionViewFlowLayout  {
    var targetSection: Int = 0
    var offsetCorrection: CGFloat = 0
    var minimumSectionSpacing: CGFloat = 0
    
    private var isTransitingToCollapsed = false {
        didSet {
            guard oldValue != isTransitingToCollapsed else {
                return
            }
            self.invalidateLayout()
        }
    }
    private var isTransitingToExpanded = false {
        didSet {
            guard oldValue != isTransitingToExpanded else {
                return
            }
            self.didFinishExpandTransition = !isTransitingToExpanded
            self.invalidateLayout()
        }
    }
    private var didFinishExpandTransition = false
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    public var contentSizeAdjustmentBehavior: ContentSizeAdjustmentBehavior = .normal {
        didSet {
            self.invalidateLayout()
        }
    }
    
    override public var collectionViewContentSize: CGSize {
        switch self.contentSizeAdjustmentBehavior {
        case .normal:
            return CGSize(width: self.contentWidth, height: self.contentHeight)
        case .fitHeight(let adjustInsets):
            guard let collectionView = self.collectionView else {
                return CGSize(width: self.contentWidth, height: self.contentHeight)
            }
            var adjustedContentHeight = collectionView.bounds.height
            if adjustInsets.contains(.top) {
                adjustedContentHeight -= collectionView.contentInset.top
            }
            if adjustInsets.contains(.bottom) {
                adjustedContentHeight -= collectionView.contentInset.bottom
            }
            let contentHeight = max(self.contentHeight, adjustedContentHeight)
            return CGSize(width: self.contentWidth, height: contentHeight)
        }
    }
    
    private var headersAttributes: [UICollectionViewLayoutAttributes] = []
    private var itemsAttributes: [[UICollectionViewLayoutAttributes]] = []
    
    override public func prepare() {
        super.prepare()
        
        guard !self.isTransitingToCollapsed else {
            self.collapseInvisibleSections()
            return
        }
        
        guard !self.isTransitingToExpanded else {
            self.expandVisibleSections()
            return
        }
        
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
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            attributes.frame = CGRect(x: 0, y: contentHeight, width: width, height: height)
            self.headersAttributes.append(attributes)
            self.contentHeight += height
            self.contentHeight += self.sectionInset.top
            
            self.itemsAttributes.append([])
            let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
            for row in 0..<numberOfItems {
                let indexPath = IndexPath(row: row, section: section)
                let itemSize = delegate.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let columnsCount = Int(contentWidth / itemSize.width)
                let column = row % columnsCount
                attributes.frame = CGRect(
                    x: sectionInset.left + CGFloat(column) * (itemSize.width + minimumInteritemSpacing),
                    y: contentHeight,
                    width: itemSize.width,
                    height: itemSize.height
                )

                attributes.isHidden = false
                self.itemsAttributes[section].append(attributes)

                if column == columnsCount - 1 || row == numberOfItems - 1 {
                    self.contentHeight += itemSize.height
                    if row < numberOfItems - 1 {
                        contentHeight += minimumLineSpacing
                    }
                }
            }
            self.contentHeight += self.sectionInset.bottom
        }
        if self.didFinishExpandTransition {
            self.setRealOffset()
            self.didFinishExpandTransition = false
        }
    }
    
    override public func prepareForTransition(to newLayout: UICollectionViewLayout) {
        super.prepareForTransition(to: newLayout)
        if newLayout is CollapsedLayout {
            self.isTransitingToCollapsed = true
        }
    }
    
    override public func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        super.prepareForTransition(from: oldLayout)
        if oldLayout is CollapsedLayout {
            self.isTransitingToExpanded = true
        }
    }
    
    override public func finalizeLayoutTransition() {
        super.finalizeLayoutTransition()
        self.isTransitingToCollapsed = false
        self.isTransitingToExpanded = false
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard self.collectionView?.dataSource != nil else {
            return nil
        }
        
        guard isTransitingToCollapsed || isTransitingToExpanded else {
            let superAttributes = super.layoutAttributesForElements(in: rect)
            guard let attributes = superAttributes else {
                return superAttributes
            }
            for elementAttributes in attributes {
                guard elementAttributes.representedElementCategory == .supplementaryView else {
                    continue
                }
                guard self.headersAttributes.indices.contains(elementAttributes.indexPath.section) else {
                    continue
                }
                elementAttributes.frame.origin.y -= self.sectionHeadersPinToBoundsCorrection(
                    proposedTopOffset: elementAttributes.frame.origin.y,
                    estimatedTopOffset: self.headersAttributes[elementAttributes.indexPath.section].frame.origin.y)
            }
            return attributes
        }
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in headersAttributes {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        for sectionAttributes in itemsAttributes {
            for attributes in sectionAttributes {
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        return visibleLayoutAttributes
    }
   
    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard self.headersAttributes.indices.contains(indexPath.section) else {
            return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        }
        guard isTransitingToCollapsed || isTransitingToExpanded else {
            let attributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
            
            guard let proposedTopOffset = attributes?.frame.origin.y else {
                return attributes
            }
            let estimatedTopOffset = self.headersAttributes[indexPath.section].frame.origin.y
            attributes?.frame.origin.y -= self.sectionHeadersPinToBoundsCorrection(
                proposedTopOffset: proposedTopOffset,
                estimatedTopOffset: estimatedTopOffset)
            return attributes
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
        guard let collectionView = self.collectionView else {
            return proposedContentOffset
        }
        var targetOffset = proposedContentOffset
        targetOffset.y = offsetCorrection
        for section in 0..<self.targetSection {
            let height = self.headersAttributes[section].frame.size.height
            targetOffset.y += height
            targetOffset.y += self.sectionInset.top
            var sectionContentHeight: CGFloat = 0
            let numberOfItems = self.itemsAttributes[section].count
            for row in 0..<numberOfItems {
                let itemSize = self.itemsAttributes[section][row].frame.size

                let columnsCount = Int(self.contentWidth / itemSize.width)
                let column = row % columnsCount

                if column == columnsCount - 1 || row == numberOfItems - 1 {
                    sectionContentHeight += itemSize.height
                    targetOffset.y += itemSize.height
                    if row < numberOfItems - 1 && itemSize.height > 0 {
                        targetOffset.y += self.minimumLineSpacing
                    }
                }
            }
            targetOffset.y += self.sectionInset.bottom
            if sectionContentHeight == 0 {
                targetOffset.y -= self.sectionInset.top
                targetOffset.y -= self.sectionInset.bottom
                targetOffset.y += self.minimumSectionSpacing
            }
        }
        let emptySpace = collectionView.bounds.size.height - (max(self.contentHeight, collectionView.bounds.size.height) - targetOffset.y)
        if emptySpace > 0 {
            targetOffset.y = targetOffset.y - emptySpace
        }
        return targetOffset
    }
    
    public func collapseInvisibleSections() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
            return
        }
        
        guard let dataSource = collectionView.dataSource else {
            return
        }
        
        var contentOffset = collectionView.contentOffset
        let previousItemsAttributes = self.itemsAttributes
        let visibleItemIndexPaths = collectionView.indexPathsForVisibleItems
        let visibleSections = Set<Int>(visibleItemIndexPaths.map({ $0.section }))
        
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
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                with: indexPath
            )
            attributes.frame = CGRect(x: 0, y: contentHeight, width: width, height: height)
            self.headersAttributes.append(attributes)
            self.contentHeight += height
            
            if visibleSections.contains(section) {
                self.contentHeight += self.sectionInset.top
            }
            else {
                self.contentHeight += self.minimumSectionSpacing / 2
                if section < targetSection {
                    contentOffset.y -= self.sectionInset.top
                    contentOffset.y += self.minimumSectionSpacing
                }
            }
            
            self.itemsAttributes.append([])
            let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
            for row in 0..<numberOfItems {
                let indexPath = IndexPath(row: row, section: section)
                var itemSize = delegate.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)
                itemSize.height = visibleItemIndexPaths.contains(indexPath) ? itemSize.height : 0
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let columnsCount = Int(self.contentWidth / itemSize.width)
                let column = row % columnsCount
                attributes.frame = CGRect(
                    x: self.sectionInset.left + CGFloat(column) * (itemSize.width + self.minimumInteritemSpacing),
                    y: contentHeight,
                    width: itemSize.width,
                    height: itemSize.height
                )

                attributes.isHidden = false
                self.itemsAttributes[section].append(attributes)

                if column == columnsCount - 1 || row == numberOfItems - 1 {
                    self.contentHeight += itemSize.height
                    if !visibleItemIndexPaths.contains(indexPath) && section < targetSection {
                        contentOffset.y -= previousItemsAttributes[section][row].frame.size.height
                    }
                    let hasVisibleItemsAfterCurrent = visibleItemIndexPaths.filter({ $0.section == section && $0.row > row }).count > 0
                    if !visibleItemIndexPaths.contains(indexPath) && section == targetSection && hasVisibleItemsAfterCurrent {
                        contentOffset.y -= previousItemsAttributes[section][row].frame.size.height
                    }
                    if row < numberOfItems - 1 && visibleItemIndexPaths.contains(indexPath) {
                        let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                        if visibleItemIndexPaths.contains(nextIndexPath) {
                            contentHeight += self.minimumLineSpacing
                        }
                    }
                    if row < numberOfItems - 1 && !visibleItemIndexPaths.contains(indexPath) && section < targetSection {
                        contentOffset.y -= self.minimumLineSpacing
                    }
                    if !visibleItemIndexPaths.contains(indexPath) && section == targetSection && hasVisibleItemsAfterCurrent {
                        contentOffset.y -= self.minimumLineSpacing
                    }
                }
            }
            
            if visibleSections.contains(section) {
                self.contentHeight += self.sectionInset.bottom
            }
            else {
                self.contentHeight += self.minimumSectionSpacing / 2
                if section < targetSection {
                    contentOffset.y -= self.sectionInset.bottom
                }
            }
            
            if sectionHeadersPinToVisibleBounds {
                let headerAttributes = self.headersAttributes[section]
                if section == self.targetSection &&
                    self.contentHeight - contentOffset.y < collectionView.contentInset.top {

                    headerAttributes.frame.origin.y = min(self.contentHeight - headerAttributes.frame.size.height, contentOffset.y)
                    let originY = headerAttributes.frame.origin.y
                    for i in (0..<section).reversed() {
                        self.headersAttributes[i].frame.origin.y = originY - self.headersAttributes[i].frame.size.height * CGFloat(section - i)
                    }
                    headerAttributes.frame.origin.y = originY
                }
                else if visibleSections.contains(section) && contentOffset.y > headerAttributes.frame.origin.y {

                    let originY = min(self.contentHeight - headerAttributes.frame.size.height, contentOffset.y)
                    for i in (0..<section).reversed() {
                        self.headersAttributes[i].frame.origin.y = originY - self.headersAttributes[i].frame.size.height * CGFloat(section - i)
                    }
                    headerAttributes.frame.origin.y = originY
                }
            }
        }
        collectionView.setContentOffset(contentOffset, animated: false)
    }

    public func expandVisibleSections() {
        guard let collectionView = self.collectionView else {
            return
        }
        
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
            return
        }
        
        guard let dataSource = collectionView.dataSource else {
            return
        }
        
        let visibleItemIndexPaths = self.determineVisibleIndexPaths()
        let visibleSections = Set<Int>(visibleItemIndexPaths.map({ $0.section }))
        
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
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                with: indexPath
            )
            attributes.frame = CGRect(x: 0, y: contentHeight, width: width, height: height)
            self.headersAttributes.append(attributes)
            self.contentHeight += height
            
            if visibleSections.contains(section) {
                self.contentHeight += self.sectionInset.top
            }
            else {
                self.contentHeight += self.minimumSectionSpacing / 2
            }
            
            self.itemsAttributes.append([])
            let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
            for row in 0..<numberOfItems {
                let indexPath = IndexPath(row: row, section: section)
                var itemSize = delegate.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)
                itemSize.height = visibleItemIndexPaths.contains(indexPath) ? itemSize.height : 0
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let columnsCount = Int(self.contentWidth / itemSize.width)
                let column = row % columnsCount
                attributes.frame = CGRect(
                    x: self.sectionInset.left + CGFloat(column) * (itemSize.width + self.minimumInteritemSpacing),
                    y: contentHeight,
                    width: itemSize.width,
                    height: itemSize.height
                )

                attributes.isHidden = false
                // Sometimes cells overlap headers, the code below fixes it
                attributes.transform3D = CATransform3DMakeTranslation(0, 0, -1)
                self.itemsAttributes[section].append(attributes)

                if column == columnsCount - 1 || row == numberOfItems - 1 {
                    self.contentHeight += itemSize.height
                    if row < numberOfItems - 1 && visibleItemIndexPaths.contains(indexPath) {
                        let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                        if visibleItemIndexPaths.contains(nextIndexPath) {
                            contentHeight += self.minimumLineSpacing
                        }
                    }
                }
            }
            
            if visibleSections.contains(section) {
                self.contentHeight += self.sectionInset.bottom
            }
            else {
                self.contentHeight += self.minimumSectionSpacing / 2
            }
        }
        
        if self.sectionHeadersPinToVisibleBounds {
            let visibleFrameHeight = collectionView.bounds.size.height + offsetCorrection
            let visibleContentOffset = self.contentHeight - visibleFrameHeight
            for section in 0..<numberOfSections {
                if visibleSections.contains(section) {
                    if self.headersAttributes[section].frame.origin.y < visibleContentOffset {
                        if section <= self.targetSection && section < numberOfSections - 1 && self.headersAttributes[section + 1].frame.origin.y > visibleContentOffset {
                            if section != self.targetSection {
                                self.headersAttributes[section].frame.origin.y = min(
                                    self.headersAttributes[section + 1].frame.origin.y - self.headersAttributes[section].frame.size.height,
                                    visibleContentOffset)
                            }
                            let originY = self.headersAttributes[section].frame.origin.y
                            for i in (0..<section).reversed() {
                                self.headersAttributes[i].frame.origin.y = originY - self.headersAttributes[i].frame.size.height * CGFloat(section - i)
                            }
                        }
                    }
                }
            }
        }
    }
}

private typealias ExpandedLayoutPrivate = ExpandedLayout
private extension ExpandedLayoutPrivate {
    private func sectionHeadersPinToBoundsCorrection(proposedTopOffset: CGFloat,
                                                     estimatedTopOffset: CGFloat) -> CGFloat {
        guard let collectionViewContentOffset = self.collectionView?.contentOffset.y,
            let collectionViewTopInset = self.collectionView?.contentInset.top,
            self.sectionHeadersPinToVisibleBounds else {
                return 0
        }
        
        var topOffsetCorrection: CGFloat = 0
        if proposedTopOffset <= estimatedTopOffset {
            topOffsetCorrection = 0
        }
        else if proposedTopOffset - estimatedTopOffset <= collectionViewTopInset {
            if proposedTopOffset - collectionViewContentOffset >= collectionViewTopInset {
                topOffsetCorrection = proposedTopOffset - estimatedTopOffset
            } else {
                let newProposedTopOffset = proposedTopOffset - (collectionViewContentOffset - estimatedTopOffset)
                topOffsetCorrection = min(newProposedTopOffset, proposedTopOffset) - estimatedTopOffset
            }
        }
        else if proposedTopOffset - collectionViewContentOffset < collectionViewTopInset {
            topOffsetCorrection = proposedTopOffset - collectionViewContentOffset
        }
        else if proposedTopOffset - estimatedTopOffset > collectionViewTopInset {
            topOffsetCorrection = collectionViewTopInset
        }
        topOffsetCorrection = max(topOffsetCorrection, 0)
        return topOffsetCorrection
    }

    private func determineVisibleIndexPaths() -> [IndexPath] {
        guard let collectionView = self.collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
            let dataSource = collectionView.dataSource else {
            return []
        }
        
        let visibleFrameHeight = collectionView.bounds.size.height + offsetCorrection
        
        var visibleItems: [IndexPath] = []
        var visibleContentHeight: CGFloat = 0
        
        guard visibleContentHeight < visibleFrameHeight else {
            return visibleItems
        }
        
        let numberOfSections = dataSource.numberOfSections!(in: collectionView)
        for section in self.targetSection..<numberOfSections {
            let headerHeight = delegate.collectionView!(collectionView, layout: self, referenceSizeForHeaderInSection: section).height
            visibleContentHeight += headerHeight
            visibleContentHeight += self.sectionInset.top
            
            guard visibleContentHeight < visibleFrameHeight else {
                return visibleItems
            }
            
            let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
            for row in 0..<numberOfItems {
                let indexPath = IndexPath(row: row, section: section)
                visibleItems.append(indexPath)
                let itemSize = delegate.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)

                let columnsCount = Int(self.contentWidth / itemSize.width)
                let column = row % columnsCount

                if column == columnsCount - 1 || row == numberOfItems - 1 {
                    visibleContentHeight += itemSize.height
                    if row < numberOfItems - 1 {
                        visibleContentHeight += self.minimumLineSpacing
                    }
                    guard visibleContentHeight < visibleFrameHeight else {
                        return visibleItems
                    }
                }
            }
            visibleContentHeight += self.sectionInset.bottom
        }
        
        for section in (0..<self.targetSection).reversed() {
            visibleContentHeight += self.sectionInset.bottom
            let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
            for row in 0..<numberOfItems {
                let indexPath = IndexPath(row: row, section: section)
                visibleItems.append(indexPath)
                let itemSize = delegate.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)

                let columnsCount = Int(self.contentWidth / itemSize.width)
                let column = row % columnsCount

                if column == columnsCount - 1 {
                    visibleContentHeight += itemSize.height
                    if row > 0 {
                        visibleContentHeight += self.minimumLineSpacing
                    }
                    guard visibleContentHeight < visibleFrameHeight else {
                        return visibleItems
                    }
                }
            }
            visibleContentHeight += self.sectionInset.top
            let headerHeight = delegate.collectionView!(collectionView, layout: self, referenceSizeForHeaderInSection: section).height
            visibleContentHeight += headerHeight
            
            guard visibleContentHeight < visibleFrameHeight else {
                return visibleItems
            }
        }
        
        return visibleItems
    }
    
    private func setRealOffset() {
        guard let collectionView = self.collectionView,
            let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
            let dataSource = collectionView.dataSource else {
            return
        }
        
        var contentOffset: CGFloat = self.offsetCorrection
        for section in 0..<targetSection {
            let headerHeigth = self.headersAttributes[section].frame.size.height
            contentOffset += headerHeigth
            contentOffset += self.sectionInset.top
            
            let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: section)
            for row in 0..<numberOfItems {
                let indexPath = IndexPath(row: row, section: section)
                let itemSize = delegate.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)

                let columnsCount = Int(self.contentWidth / itemSize.width)
                let column = row % columnsCount

                if column == columnsCount - 1 || row == numberOfItems - 1 {
                    contentOffset += itemSize.height
                    if row < numberOfItems - 1 {
                        contentOffset += self.minimumLineSpacing
                    }
                }
            }
            
            contentOffset += self.sectionInset.bottom
        }
        let maxContentOffset = max(self.contentHeight, collectionView.bounds.size.height) - collectionView.bounds.size.height
        contentOffset = min(contentOffset, maxContentOffset)
        collectionView.setContentOffset(CGPoint(x: collectionView.contentOffset.x, y: contentOffset),
                                        animated: false)
    }
}
