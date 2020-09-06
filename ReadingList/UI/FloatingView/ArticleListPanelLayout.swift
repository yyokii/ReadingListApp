//
//  ArticleListPanelLayout.swift
//  ReadingList
//
//  Created by 東原与生 on 2019/08/31.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import FloatingPanel

public class ArticleListPanelLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    public var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .tip]
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 24.0 // from top
        case .half: return 304.0 // from bottom
        case .tip: return 64.0 // from bottom
        default: return nil
        }
    }

    public func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.0
    }
}
