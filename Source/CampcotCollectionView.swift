//
//  CampcotCollectionView.swift
//  CampcotCollectionView
//
//  Created by Vadim Morozov on 1/29/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

public class CampcotCollectionView: UICollectionView {
    private var expandedLayout: ExpandedLayout!
    private var collapsedLayout: CollapsedLayout!

    /// A Boolean value that determines whether the sections are expanded.
    public var isExpanded: Bool {
        return self.collectionViewLayout === self.expandedLayout
    }
    
    /// Space between section headers in collapsed state.
    @IBInspectable
    public var minimumSectionSpacing: CGFloat = 0 {
        didSet {
            self.expandedLayout.minimumSectionSpacing = minimumSectionSpacing
            self.collapsedLayout.minimumSectionSpacing = minimumSectionSpacing
        }
    }
    
    /// Layout minimum interitem spaceign.
    @IBInspectable
    public var minimumInteritemSpacing: CGFloat = 0 {
        didSet {
            self.expandedLayout.minimumInteritemSpacing = minimumInteritemSpacing
            self.collapsedLayout.minimumInteritemSpacing = minimumInteritemSpacing
        }
    }
    
    /// Layout minimum line spacing.
    @IBInspectable
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

    @IBInspectable
    private var topInset: CGFloat = 0 {
        didSet {
            sectionInset.top = topInset
        }
    }

    @IBInspectable
    private var bottomInset: CGFloat = 0 {
        didSet {
            sectionInset.bottom = bottomInset
        }
    }

    @IBInspectable
    private var leftInset: CGFloat = 0 {
        didSet {
            sectionInset.left = leftInset
        }
    }

    @IBInspectable
    private var rightInset: CGFloat = 0 {
        didSet {
            sectionInset.right = rightInset
        }
    }

    /// Layout section headers pin to visible bounds.
    @IBInspectable
    public var sectionHeadersPinToVisibleBounds: Bool = false {
        didSet {
            self.expandedLayout.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
            self.collapsedLayout.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
        }
    }

    /// Content size calculation rules.
    public var contentSizeAdjustmentBehavior: ContentSizeAdjustmentBehavior = .normal {
        didSet {
            self.expandedLayout.contentSizeAdjustmentBehavior = contentSizeAdjustmentBehavior
            self.collapsedLayout.contentSizeAdjustmentBehavior = contentSizeAdjustmentBehavior
        }
    }
    
    public init() {
        expandedLayout = ExpandedLayout()
        collapsedLayout = CollapsedLayout()
        super.init(frame: .zero, collectionViewLayout: self.expandedLayout)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let expandedLayout = self.collectionViewLayout as? ExpandedLayout {
            /// When collectionViewLayout is expanded
            self.expandedLayout = expandedLayout
            self.collapsedLayout = CollapsedLayout()
        } else if let collapsedLayout = self.collectionViewLayout as? CollapsedLayout {
            /// When collectionViewLayout is collapsed
            self.expandedLayout = ExpandedLayout()
            self.collapsedLayout = collapsedLayout
        } else {
            /// By default, if collectionViewLayout was not set neither expanded nor collapsed
            self.expandedLayout = ExpandedLayout()
            self.collapsedLayout = CollapsedLayout()

            self.collectionViewLayout = self.expandedLayout /// Default layout
        }
    }
    
    /// Expand all sections and pin section from params to top.
    public func expand(from section: Int,
                       offsetCorrection: CGFloat = 0,
                       animated: Bool,
                       completion: ((Bool) -> Void)? = nil) {
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
    public func collapse(to section: Int,
                         offsetCorrection: CGFloat = 0,
                         animated: Bool,
                         completion: ((Bool) -> Void)? = nil) {
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
    public func toggle(to section: Int,
                       offsetCorrection: CGFloat = 0,
                       animated: Bool,
                       completion: ((Bool) -> Void)? = nil) {
        if self.isExpanded {
            self.collapse(to: section,
                          offsetCorrection: offsetCorrection,
                          animated: animated,
                          completion: completion)
        }
        else {
            self.expand(from: section,
                        offsetCorrection: offsetCorrection,
                        animated: animated,
                        completion: completion)
        }
    }
}
