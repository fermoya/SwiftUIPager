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
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct Pager<Element, ID, PageView>: View  where PageView: View, Element: Equatable, ID: Hashable {

    /// `Direction` determines the direction of the swipe gesture
    enum Direction {
        /// Swiping  from left to right
        case forward
        /// Swiping from right to left
        case backward
    }

    /*** Constants ***/

    /// Policy to be applied when loading content
    var contentLoadingPolicy: ContentLoadingPolicy = .default

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
    let id: KeyPath<PageWrapper<Element, ID>, String>

    /// Array of items that will populate each page
    var data: [PageWrapper<Element, ID>]

    /*** ViewModified properties ***/

    /// Angle to dermine the direction of the scroll
    var scrollDirectionAngle: Angle = .zero

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

    /// Whether the `Pager` should page multiple pages at once
    var allowsMultiplePagination: Bool = false

    /// Minimum distance for `Pager` to start scrolling
    var minimumDistance: CGFloat = 15

    /// Priority selected to add `swipeGesture`
    var gesturePriority: GesturePriority = .default

    /// Will apply this ratio to each page item. The aspect ratio follows the formula _width / height_
    var itemAspectRatio: CGFloat?

    /// Will try to have the items fit this size
    var preferredItemSize: CGSize?

    /// Callback for every new page
    var onPageChanged: ((Int) -> Void)?

    /*** State and Binding properties ***/

    /// Size of the view
    @State var size: CGSize = .zero

    /// `swipeGesture` translation on the X-Axis
    @State var draggingOffset: CGFloat = 0

    /// `swipeGesture` last translation on the X-Axis
    @State var lastDraggingValue: DragGesture.Value?

    /// `swipeGesture` velocity on the X-Axis
    @State var draggingVelocity: Double = 0

    /// Increment resulting from the last swipe
    @State var pageIncrement = 1

    /// Page index
    @Binding var pageIndex: Int {
        didSet {
            onPageChanged?(page)
        }
    }

    /// Initializes a new `Pager`.
    ///
    /// - Parameter page: Binding to the page index
    /// - Parameter data: Array of items to populate the content
    /// - Parameter id: KeyPath to identifiable property
    /// - Parameter content: Factory method to build new pages
    public init(page: Binding<Int>, data: [Element], id: KeyPath<Element, ID>, @ViewBuilder content: @escaping (Element) -> PageView) {
        self._pageIndex = page
        self.data = data.map { PageWrapper(batchId: 1, keyPath: id, element: $0) }
        self.id = \PageWrapper<Element, ID>.id
        self.content = content
    }

    public var body: some View {
        let stack = HStack(spacing: interactiveItemSpacing) {
            ForEach(dataDisplayed, id: id) { item in
                self.content(item.element)
                    .opacity(self.isInifinitePager && self.isEdgePage(item) ? 0 : 1)
                    .animation(nil) // disable animation for opacity
                    .frame(size: self.pageSize)
                    .scaleEffect(self.scale(for: item))
                    .rotation3DEffect((self.isHorizontal ? .zero : Angle(degrees: -90)) - self.scrollDirectionAngle,
                                      axis: (0, 0, 1))
                    .rotation3DEffect(self.angle(for: item),
                                      axis: self.axis(for: item))
            }
            .offset(x: self.xOffset, y : self.yOffset)
        }
        .frame(size: size)

        #if !os(tvOS)
        var wrappedView: AnyView = swipeInteractionArea == .page ? AnyView(stack) : AnyView(stack.contentShape(Rectangle()))
        wrappedView = AnyView(wrappedView.gesture(allowsDragging ? swipeGesture : nil, priority: gesturePriority))
        #else
        let wrappedView = stack
        #endif

        return wrappedView
            .rotation3DEffect((isHorizontal ? .zero : Angle(degrees: 90)) + scrollDirectionAngle,
                              axis: (0, 0, 1))
            .sizeTrackable($size)
            .onAppear(perform: {
                self.onPageChanged?(self.page)
            })
            .onDeactivate(perform: {
                if self.isDragging {
                    #if !os(tvOS)
                    self.onDragGestureEnded()
                    #endif
                }
            })
    }

}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pager where ID == Element.ID, Element : Identifiable {

    /// Initializes a new Pager.
    ///
    /// - Parameter data: Array of items to populate the content
    /// - Parameter content: Factory method to build new pages
    public init(page: Binding<Int>, data: [Element], @ViewBuilder content: @escaping (Element) -> PageView) {
        self.init(page: page, data: data, id: \Element.id, content: content)
    }

}

// MARK: Gestures

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pager {

    /// `DragGesture` customized to work with `Pager`
    #if !os(tvOS)
    var swipeGesture: some Gesture {
        DragGesture(minimumDistance: minimumDistance)
            .onChanged({ value in
                withAnimation {
                    let lastLocation = self.lastDraggingValue?.location ?? value.location
                    let swipeAngle = (value.location - lastLocation).angle.degrees

                    // Keeping swipe only if along the X-Axis ± 30 degrees
                    let isInBounds = swipeAngle > 330 || swipeAngle < 30 || (swipeAngle > 150 && swipeAngle < 210)
                    guard isInBounds else {
                        self.lastDraggingValue = value
                        return
                    }

                    let side = self.isHorizontal ? self.size.width : self.size.height
                    let normalizedRatio = self.allowsMultiplePagination ? 1 : (self.pageDistance / side)
                    let offsetIncrement = (value.location.x - lastLocation.x) * normalizedRatio

                    let timeIncrement = value.time.timeIntervalSince(self.lastDraggingValue?.time ?? value.time)
                    if timeIncrement != 0 {
                        self.draggingVelocity = Double(offsetIncrement) / timeIncrement
                    }

                    self.draggingOffset += offsetIncrement
                    self.lastDraggingValue = value
                }
            })
            .onEnded({ (value) in
                self.onDragGestureEnded()
            })
    }

    private func onDragGestureEnded() {
        let draggingResult = self.draggingResult
        let newPage = draggingResult.page
        let pageIncrement = draggingResult.increment

        var duration = Double(max(1, (pageIncrement + self.numberOfPages) % self.numberOfPages)) * 0.2
        duration = min(0.8, duration)
        let animation = self.allowsMultiplePagination && pageIncrement > 1 ? Animation.timingCurve(0.2, 1, 0.9, 1, duration: duration) : Animation.easeOut
        withAnimation(animation) {
            self.draggingOffset = 0
            self.pageIncrement = pageIncrement
            self.pageIndex = newPage
            self.draggingVelocity = 0
            self.lastDraggingValue = nil
        }
    }

    private var draggingResult: (page: Int, increment: Int) {
        let currentPage = self.currentPage
        let velocity = -self.draggingVelocity

        guard allowsMultiplePagination else {
            var newPage = currentPage
            if currentPage == self.page, abs(velocity) > 500 {
                if isInifinitePager {
                    newPage = (newPage + Int(velocity / abs(velocity)) + self.numberOfPages) % self.numberOfPages
                } else {
                    newPage = newPage + Int(velocity / abs(velocity))
                }
            }
            return (newPage, 1)
        }

        let side = self.isHorizontal ? self.size.width : self.size.height
        let maxIncrement = Int((Double(numberOfPages) * 0.25).rounded(.up))
        let velocityPageIncrement = Int(CGFloat(abs(velocity)) / (side / self.pageDistance) / 500)

        var offsetPageIncrement = self.direction == .forward ? currentPage - self.page : self.page - currentPage
        if self.isInifinitePager {
            offsetPageIncrement = (offsetPageIncrement + self.numberOfPages) % self.numberOfPages
        }

        let pageIncrement = min(velocityPageIncrement + offsetPageIncrement, maxIncrement)
        var newPage = self.direction == .forward ? self.page + pageIncrement : self.page - pageIncrement
        if isInifinitePager {
            newPage = (newPage + self.numberOfPages) % self.numberOfPages
        }

        newPage = max(0, min(self.numberOfPages - 1, newPage))
        return (newPage, pageIncrement)
    }
    #endif

}
