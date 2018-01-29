//
//  CampcotCollectionView.swift
//  CampcotCollectionView
//
//  Created by Vadim Morozov on 1/29/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

public class CampcotCollectionView: UICollectionView {
    let expandedLayout = ExpandedLayout()
    let collapsedLayout = CollapsedLayout()
    
    public var isExpanded: Bool {
        return self.collectionViewLayout === self.expandedLayout
    }
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: self.expandedLayout)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func expand(from section: Int, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard !self.isExpanded else {
            return
        }
        self.expandedLayout.targetSection = section
        self.setCollectionViewLayout(self.expandedLayout, animated: animated, completion: completion)
    }
    
    public func collapse(to section: Int, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard self.isExpanded else {
            return
        }
        self.collapsedLayout.targetSection = section
        self.expandedLayout.targetSection = section
        self.expandedLayout.collapseHiddenSections = true
        self.setCollectionViewLayout(self.collapsedLayout, animated: animated, completion: { completed in
            self.expandedLayout.collapseHiddenSections = false
            self.expandedLayout.invalidateLayout()
            completion?(completed)
        })
    }
}
