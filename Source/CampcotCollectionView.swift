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
        return collectionViewLayout === expandedLayout
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
            expandedLayout.sectionInset = sectionInset
            collapsedLayout.sectionInset = sectionInset
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
            expandedLayout.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
            collapsedLayout.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
        }
    }

    /// Content size calculation rules.
    public var contentSizeAdjustmentBehavior: ContentSizeAdjustmentBehavior = .normal {
        didSet {
            expandedLayout.contentSizeAdjustmentBehavior = contentSizeAdjustmentBehavior
            collapsedLayout.contentSizeAdjustmentBehavior = contentSizeAdjustmentBehavior
        }
    }

    public init() {
        expandedLayout = ExpandedLayout()
        collapsedLayout = CollapsedLayout()
        super.init(frame: .zero, collectionViewLayout: expandedLayout)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let expandedLayout = collectionViewLayout as? ExpandedLayout {
            /// When collectionViewLayout is expanded
            self.expandedLayout = expandedLayout
            collapsedLayout = CollapsedLayout()
        } else if let collapsedLayout = collectionViewLayout as? CollapsedLayout {
            /// When collectionViewLayout is collapsed
            expandedLayout = ExpandedLayout()
            self.collapsedLayout = collapsedLayout
        } else {
            /// By default, if collectionViewLayout was not set neither expanded nor collapsed
            expandedLayout = ExpandedLayout()
            collapsedLayout = CollapsedLayout()

            collectionViewLayout = expandedLayout /// Default layout
        }
    }

    /// Expand all sections and pin section from params to top.
    public func expand(
        from section: Int,
        offsetCorrection: CGFloat = 0,
        animated: Bool,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard !isExpanded else {
            return
        }
        expandedLayout.targetSection = section
        expandedLayout.offsetCorrection = offsetCorrection
        collapsedLayout.targetSection = section
        collapsedLayout.offsetCorrection = offsetCorrection
        setCollectionViewLayout(expandedLayout, animated: animated, completion: { completed in
            DispatchQueue.main.async(execute: {
                completion?(completed)
            })
        })
    }

    /// Collapse all sections and pin section from params to top.
    public func collapse(
        to section: Int,
        offsetCorrection: CGFloat = 0,
        animated: Bool,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard isExpanded else {
            return
        }
        expandedLayout.targetSection = section
        expandedLayout.offsetCorrection = offsetCorrection
        collapsedLayout.targetSection = section
        collapsedLayout.offsetCorrection = offsetCorrection
        setCollectionViewLayout(collapsedLayout, animated: animated, completion: { completed in
            DispatchQueue.main.async(execute: {
                completion?(completed)
            })
        })
    }

    /// Change sections mode to opposite.
    public func toggle(
        to section: Int,
        offsetCorrection: CGFloat = 0,
        animated: Bool,
        completion: ((Bool) -> Void)? = nil
    ) {
        if isExpanded {
            collapse(
                to: section,
                offsetCorrection: offsetCorrection,
                animated: animated,
                completion: completion
            )
        } else {
            expand(
                from: section,
                offsetCorrection: offsetCorrection,
                animated: animated,
                completion: completion
            )
        }
    }
}
