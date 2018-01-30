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
    
    /// Layout section inset
    public var sectionInset = UIEdgeInsets.zero {
        didSet {
            self.expandedLayout.sectionInset = sectionInset
            self.collapsedLayout.sectionInset = sectionInset
        }
    }
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: self.expandedLayout)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func expand(from section: Int, offsetCorrection: CGFloat = 0, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard !self.isExpanded else {
            return
        }
        self.expandedLayout.targetSection = section
        self.expandedLayout.offsetCorrection = offsetCorrection
        self.setCollectionViewLayout(self.expandedLayout, animated: animated, completion: completion)
    }
    
    public func collapse(to section: Int, offsetCorrection: CGFloat = 0, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard self.isExpanded else {
            return
        }
        self.collapsedLayout.targetSection = section
        self.collapsedLayout.offsetCorrection = offsetCorrection
        self.expandedLayout.targetSection = section
        self.setCollectionViewLayout(self.collapsedLayout, animated: animated, completion: completion)
    }
}
