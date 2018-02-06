//
//  CampcotCollectionView.swift
//  CampcotCollectionView
//
//  Created by Vadim Morozov on 1/29/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

public class CampcotCollectionView: UICollectionView {
    private let expandedLayout = ExpandedLayout()
    private let collapsedLayout = CollapsedLayout()
    
    /// A Boolean value that determines whether the sections are expanded.
    public var isExpanded: Bool {
        return self.collectionViewLayout === self.expandedLayout
    }
    
    /// Space between section headers in collapsed state.
    public var minimumSectionSpacing: CGFloat = 0 {
        didSet {
            self.expandedLayout.minimumSectionSpacing = minimumSectionSpacing
            self.collapsedLayout.minimumSectionSpacing = minimumSectionSpacing
        }
    }
    
    /// Layout minimum interitem spaceign.
    public var minimumInteritemSpacing: CGFloat = 0 {
        didSet {
            self.expandedLayout.minimumInteritemSpacing = minimumInteritemSpacing
            self.collapsedLayout.minimumInteritemSpacing = minimumInteritemSpacing
        }
    }
    
    /// Layout minimum line spacing.
    public var minimumLineSpacing: CGFloat = 0 {
        didSet {
            self.expandedLayout.minimumLineSpacing = minimumLineSpacing
            self.collapsedLayout.minimumLineSpacing = minimumLineSpacing
        }
    }
    
    /// Layout section inset.
    public var sectionInset = UIEdgeInsets.zero {
        didSet {
            self.expandedLayout.sectionInset = sectionInset
            self.collapsedLayout.sectionInset = sectionInset
        }
    }
    
    /// Layout section headers pin to visible bounds.
    public var sectionHeadersPinToVisibleBounds = false {
        didSet {
            self.expandedLayout.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
            self.collapsedLayout.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
        }
    }
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: self.expandedLayout)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Expand all sections and pin section from params to top.
    public func expand(from section: Int, offsetCorrection: CGFloat = 0, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard !self.isExpanded else {
            return
        }
        self.expandedLayout.targetSection = section
        self.expandedLayout.offsetCorrection = offsetCorrection
        self.collapsedLayout.targetSection = section
        self.collapsedLayout.offsetCorrection = offsetCorrection
        self.setCollectionViewLayout(self.expandedLayout, animated: animated, completion: { completed in
            DispatchQueue.main.async(execute: {
                completion?(completed)
            })
        })
    }
    
    /// Collapse all sections and pin section from params to top.
    public func collapse(to section: Int, offsetCorrection: CGFloat = 0, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard self.isExpanded else {
            return
        }
        self.expandedLayout.targetSection = section
        self.expandedLayout.offsetCorrection = offsetCorrection
        self.collapsedLayout.targetSection = section
        self.collapsedLayout.offsetCorrection = offsetCorrection
        self.setCollectionViewLayout(self.collapsedLayout, animated: animated, completion: { completed in
            DispatchQueue.main.async(execute: {
                completion?(completed)
            })
        })
    }
    
    /// Change sections mode to opposite.
    public func toggle(to section: Int, offsetCorrection: CGFloat = 0, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        if self.isExpanded {
            self.collapse(to: section, offsetCorrection: offsetCorrection, animated: animated, completion: completion)
        }
        else {
            self.expand(from: section, offsetCorrection: offsetCorrection, animated: animated, completion: completion)
        }
    }
}
