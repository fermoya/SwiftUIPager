//
//  Pager.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 05/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

///
/// `Pager` is a view built on top of native SwiftUI components. Given a `ViewBuilder` and some `Identifiable` and `Equatable` data,
/// this view will create a scrollable container to display a handful of pages. The pages are recycled on scroll. `Pager` is easily customizable through a number
/// of view-modifier functions.  You can change the vertical insets, spacing between items, ... You can also make the pages size interactive.
///
/// # Example #
///
///     Pager(page: $page
///           data: data,
///           content: { index in
///               self.pageView(index)
///     }).interactive(0.8)
///         .itemSpacing(10)
///         .padding(30)
///         .itemAspectRatio(0.6)
///
/// This snippet creates a pager with:
/// - 10 px beetween pages
/// - 30 px of vertical insets
/// - 0.6 shrink ratio for items that aren't focused.
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Pager<Element, ID, PageView>: View  where PageView: View, Element: Equatable, ID: Hashable {

    /// `Direction` determines the direction of the swipe gesture
    enum Direction {
        /// Swiping  from left to right
        case forward
        /// Swiping from right to left
        case backward
    }

    /*** Constants ***/

    /// Angle of rotation when should rotate
    let rotationDegrees: Double = 20

    /// Angle of rotation when should rotate
    let rotationInteractiveScale: CGFloat = 0.7

    /// Axis of rotation when should rotate
    let rotationAxis: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 1, 0)

    /*** Dependencies ***/

    /// `ViewBuilder` block to create each page
    let content: (Element) -> PageView

    /// `KeyPath` to data id property
    let id: KeyPath<Element, ID>

    /// Array of items that will populate each page
    var data: [Element]

    /*** ViewModified properties ***/

    /// Whether `Pager` should bounce or not
    var bounces: Bool = true

    /// Max relative item size that `Pager` will scroll before determining whether to move to the next page
    var pageRatio: CGFloat = 1

    /// Animation to be applied when the user stops dragging
    var pagingAnimation: ((DragResult) -> PagingAnimation)?

    /// Sensitivity used to determine whether or not to swipe the page
    var sensitivity: PaginationSensitivity = .default

    /// Policy to be applied when loading content
    var contentLoadingPolicy: ContentLoadingPolicy = .default

    /// Swipe direction for horizontal `Pager`
    var horizontalSwipeDirection: HorizontalSwipeDirection = .leftToRight

    /// Swipe direction for vertical `Pager`
    var verticalSwipeDirection: VerticalSwipeDirection = .topToBottom

    /// Hittable area
    var swipeInteractionArea: SwipeInteractionArea = .page

    /// Item alignment inside `Pager`
    var itemAlignment: PositionAlignment = .center

    /// The elements alignment relative to the container
    var alignment: PositionAlignment = .center

    /// `true` if the pager is horizontal
    var isHorizontal: Bool = true

    /// Shrink ratio that affects the items that aren't focused
    var interactiveScale: CGFloat = 1

    /// Opacity increment applied to unfocused pages
    var opacityIncrement: Double?

    /// `true` if  `Pager` can be dragged
    var allowsDragging: Bool = true

    /// `true` if pages should have a 3D rotation effect
    var shouldRotate: Bool = false

    /// Used to modify `Pager` offset outside this view
    var pageOffset: Double = 0

    /// Vertical padding
    var sideInsets: CGFloat = 0

    /// Space between pages
    var itemSpacing: CGFloat = 0

    /// Whether the `Pager` loops endlessly
    var isInifinitePager: Bool = false

    /// Number of times the input data should be repeated in a looping `Pager`
    var loopingCount: UInt = 1

    /// Whether `Pager` should page multiple pages at once
    var allowsMultiplePagination: Bool = false

    /// Wheter `Pager` delays gesture recognition
    var delaysTouches: Bool = true

    /// Priority selected to add `swipeGesture`
    var gesturePriority: GesturePriority = .default

    /// Will apply this ratio to each page item. The aspect ratio follows the formula _width / height_
    var itemAspectRatio: CGFloat?

    /// Will try to have the items fit this size
    var preferredItemSize: CGSize?

    /// Callback invoked when a new page will be set
    var onPageWillChange: ((Int) -> Void)?

    /// Callback invoked when a new page is set
    var onPageChanged: ((Int) -> Void)?
	
	/// Callback for when dragging begins
	var onDraggingBegan: (() -> Void)?

    /// Callback for when dragging changes
    var onDraggingChanged: ((Double) -> Void)?

    /// Callback for when dragging ends
    var onDraggingEnded: (() -> Void)?

    /*** State and Binding properties ***/

    let pagerModel: Page
    
    /// Initializes a new `Pager`.
    ///
    /// - Parameter page: Current page index
    /// - Parameter data: Collection of items to populate the content
    /// - Parameter id: KeyPath to identifiable property
    /// - Parameter content: Factory method to build new pages
    public init<Data: RandomAccessCollection>(page: Page, data: Data, id: KeyPath<Element, ID>, @ViewBuilder content: @escaping (Element) -> PageView) where Data.Index == Int, Data.Element == Element {
        self.pagerModel = page
        self.data = Array(data)
        self.id = id
        self.content = content
        self.pagerModel.totalPages = data.count
    }

    public var body: some View {
        GeometryReader { proxy in
            self.content(for: proxy.size)
        }
        .clipped()
    }

    func content(for size: CGSize) -> PagerContent {
        var pagerContent =
            PagerContent(size: size,
                         pagerModel: pagerModel,
                         data: data,
                         id: id,
                         content: content)
                .contentLoadingPolicy(contentLoadingPolicy)
                .loopPages(isInifinitePager, repeating: loopingCount)
                .alignment(alignment)
                .interactive(interactiveScale)
                .faded(opacityIncrement)
                .pageOffset(pageOffset)
                .itemSpacing(itemSpacing)
                .itemAspectRatio(itemAspectRatio, alignment: itemAlignment)
                .onPageChanged(onPageChanged)
                .onPageWillChange(onPageWillChange)
                .padding(sideInsets)
                .pagingAnimation(pagingAnimation)
                .partialPagination(pageRatio)

        #if !os(tvOS)
          pagerContent = pagerContent
            .swipeInteractionArea(swipeInteractionArea)
            .allowsDragging(allowsDragging)
            .pagingPriority(gesturePriority)
            .delaysTouches(delaysTouches)
            .sensitivity(sensitivity)
            .onDraggingBegan(onDraggingBegan)
            .onDraggingChanged(onDraggingChanged)
            .onDraggingEnded(onDraggingEnded)
            .bounces(bounces)
          #endif

        pagerContent = allowsMultiplePagination ? pagerContent.multiplePagination() : pagerContent
        pagerContent = isHorizontal ? pagerContent.horizontal(horizontalSwipeDirection) : pagerContent.vertical(verticalSwipeDirection)
        pagerContent = shouldRotate ? pagerContent.rotation3D() : pagerContent

        if let preferredItemSize = preferredItemSize {
            pagerContent = pagerContent.preferredItemSize(preferredItemSize)
        }

        return pagerContent
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pager where ID == Element.ID, Element : Identifiable {
    
    /// Initializes a new Pager.
    ///
    /// - Parameter page: Current page index
    /// - Parameter data: Collection of items to populate the content
    /// - Parameter content: Factory method to build new pages
    public init<Data: RandomAccessCollection>(page: Page, data: Data, @ViewBuilder content: @escaping (Element) -> PageView) where Data.Index == Int, Data.Element == Element {
        self.init(page: page, data: Array(data), id: \Element.id, content: content)
    }

}
