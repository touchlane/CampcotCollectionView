//
//  ContentSizeAdjustmentBehavior.swift
//  CampcotCollectionView
//
//  Created by Vadim Morozov on 10/30/19.
//  Copyright © 2019 Touchlane LLC. All rights reserved.
//

public enum ContentSizeAdjustmentBehavior {
    public struct Inset: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let top = Inset(rawValue: 1 << 0)
        public static let bottom = Inset(rawValue: 1 << 1)

        public static let none: Inset = []
        public static let all: Inset = [.top, .bottom]
    }

    /// Content size depends only on content.
    case normal

    /// Content size can't be less than collection view frame without adjust insets.
    case fitHeight(adjustInsets: Inset)
}
