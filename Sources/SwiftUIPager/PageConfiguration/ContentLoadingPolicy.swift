//
//  File.swift
//  
//
//  Created by Fernando Moya de Rivas on 05/07/2020.
//

import Foundation

/// Policy to follow when loading content
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public enum ContentLoadingPolicy: Equatable {

    /// Content is loaded on demand by applying a recycling the ratio.
    ///
    /// - Parameter recyclingRatio: Manages the number of items that should be displayed in the screen.
    ///
    /// A ratio of `5`, for instance, will load enough items in memory to fill five times the size of `Pager`.
    /// - Note: `recyclingRatio` must be greather than `0`.
    case lazy(recyclingRatio: UInt)

    /// Choose `eager` to load all items at once
    case eager

    /// Default policy, a.k.a, `lazy(recyclingRatio: 5)`
    static var `default`: ContentLoadingPolicy = .lazy(recyclingRatio: 5)
}

