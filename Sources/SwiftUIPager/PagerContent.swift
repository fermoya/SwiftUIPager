//
//  PagerContent.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 23/07/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

///
/// `PagerContent` is the content of `Pager`. This view is needed so that `Pager` wrapps it around a `GeometryReader ` and passes the size in its initializer.
///
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pager {
    struct PagerContent: View {

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

        /// Axis of rotation when should rotate
        let rotationAxis: (x: CGFloat, y: CGFloat, z: CGFloat) = (0, 1, 0)

        /*** Dependencies ***/

        /// Available size to render the content
        let size: CGSize

        /// `ViewBuilder` block to create each page
        let content: (Element) -> PageView

        /// `KeyPath` to data id property
        let id: KeyPath<PageWrapper<Element, ID>, String>

        /// Array of items that will populate each page
        var data: [PageWrapper<Element, ID>]

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

        /// Page index
        @ObservedObject var pagerModel: Page

        /// Initializes a new `Pager`.
        ///
        /// - Parameter size: Available size
        /// - Parameter pagerModel: Wrapper for the current page
        /// - Parameter data: Array of items to populate the content
        /// - Parameter id: KeyPath to identifiable property
        /// - Parameter content: Factory method to build new pages
        init(size: CGSize, pagerModel: Page, data: [Element], id: KeyPath<Element, ID>, @ViewBuilder content: @escaping (Element) -> PageView) {
            self.size = size
            self.pagerModel = pagerModel
            self.data = data.map { PageWrapper(batchId: 1, keyPath: id, element: $0) }
            self.id = \PageWrapper<Element, ID>.id
            self.content = content
        }

        var body: some View {
            let stack = HStack(spacing: interactiveItemSpacing) {
                ForEach(dataDisplayed, id: id) { item in
                    Group {
                        if self.isInifinitePager && self.isEdgePage(item) {
                            EmptyView()
                        } else {
                            self.content(item.element)
                        }
                    }
                    .frame(size: self.pageSize)
                    .scaleEffect(self.scale(for: item))
                    .rotation3DEffect((self.isHorizontal ? .zero : Angle(degrees: -90)) - self.scrollDirectionAngle,
                                      axis: (0, 0, 1))
                    .rotation3DEffect(self.angle(for: item),
                                          axis:  self.axis)
                    .opacity(opacity(for: item))
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
                .onDeactivate(perform: {
                    if self.isDragging {
                        #if !os(tvOS)
                        self.onDragGestureEnded()
                        #endif
                    }
                })
                .onAnimationCompleted(for: CGFloat(pagerModel.index), completion: {
                    // #194 AnimatableModifier symbol not found in iOS 13.0 and iOS 13.1
                    if #available(iOS 13.2, macOS 10.15, tvOS 13.0, watchOS 6.0, *) {
                        if pagerModel.pageIncrement != 0 {
                            onPageChanged?(pagerModel.index)
                        }
                    }
                })
                .contentShape(Rectangle())
        }
    }
}

// MARK: Gestures

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pager.PagerContent {

    /// `DragGesture` customized to work with `Pager`
    #if !os(tvOS)
    var swipeGesture: some Gesture {
        DragGesture(minimumDistance: minimumDistance)
            .onChanged({ value in
                self.onDragChanged(with: value)
            })
            .onEnded({ (value) in
                self.onDragGestureEnded()
            })
    }

    func onDragChanged(with value: DragGesture.Value) {
        withAnimation(.linear(duration: 0.1)) {
            if self.lastDraggingValue == nil {
                onDraggingBegan?()
            }

            let lastLocation = self.lastDraggingValue?.location ?? value.location
            let swipeAngle = (value.location - lastLocation).angle ?? .zero
            // Ignore swipes that aren't on the X-Axis
            guard swipeAngle.isAlongXAxis else {
                self.pagerModel.lastDraggingValue = value
                return
            }

            let side = self.isHorizontal ? self.size.width : self.size.height
            let normalizedRatio = self.allowsMultiplePagination ? 1 : (self.pageDistance / side)
            let offsetIncrement = (value.location.x - lastLocation.x) * normalizedRatio

            // If swipe hasn't started yet, ignore swipes if they didn't start on the X-Axis
            let isTranslationInXAxis = abs(value.translation.width) > abs(value.translation.height)
            guard self.draggingOffset != 0 || isTranslationInXAxis else {
                return
            }

            let timeIncrement = value.time.timeIntervalSince(self.lastDraggingValue?.time ?? value.time)
            if timeIncrement != 0 {
                self.pagerModel.draggingVelocity = Double(offsetIncrement) / timeIncrement
            }

            var newOffset = self.draggingOffset + offsetIncrement
            if !allowsMultiplePagination {
                newOffset = self.direction == .forward ? max(newOffset, self.pageRatio * -self.pageDistance) : min(newOffset, self.pageRatio * self.pageDistance)
            }

            self.pagerModel.draggingOffset = newOffset
            self.pagerModel.lastDraggingValue = value
            self.onDraggingChanged?(Double(-self.draggingOffset / self.pageDistance))
            self.pagerModel.objectWillChange.send()
        }
    }

    func onDragGestureEnded() {
        let draggingResult = self.dragResult
        let newPage = draggingResult.page
        let pageIncrement = draggingResult.increment

        self.onDraggingEnded?()

        var defaultPagingAnimation: PagingAnimation = .standard
        var speed: Double = 1
        if allowsMultiplePagination && pageIncrement > 1 {
            defaultPagingAnimation = .steep
            speed = 1 / min(4, Double(pageIncrement))
        }

        let pagingAnimation = self.pagingAnimation?((page, newPage, draggingOffset, draggingVelocity)) ?? defaultPagingAnimation

        let animation = pagingAnimation.animation.speed(speed)
        if page != newPage {
            onPageWillChange?(newPage)
        }
        withAnimation(animation) {
            self.pagerModel.draggingOffset = 0
            self.pagerModel.pageIncrement = pageIncrement
            self.pagerModel.draggingVelocity = 0
            self.pagerModel.lastDraggingValue = nil
            self.pagerModel.index = newPage
            self.pagerModel.objectWillChange.send()
        }

        // #194 AnimatableModifier symbol not found in iOS 13.0 and iOS 13.1
        if #available(iOS 13.2, macOS 10.15, tvOS 13.0, watchOS 6.0, *) {
            // Do nothing
        } else if page != newPage {
            onPageChanged?(newPage)
        }
    }

    var dragResult: (page: Int, increment: Int) {
        let currentPage = self.currentPage(sensitivity: sensitivity.value)
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

            newPage = max(0, min(self.numberOfPages - 1, newPage))
            return (newPage, newPage != page ? 1 : 0)
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
