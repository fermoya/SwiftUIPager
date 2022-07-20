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

        /// Animation used for dragging
        var draggingAnimation: DraggingAnimation = .standard

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

        /// Swiping back is disabled
        var dragForwardOnly: Bool = false

        /// `true` if the pager is horizontal
        var isHorizontal: Bool = true

        /// Shrink ratio that affects the items that aren't focused
        var interactiveScale: CGFloat = 1

        /// Opacity increment applied to unfocused pages
        var opacityIncrement: Double? 

        /// `true` if  `Pager` can be dragged
        var allowsDragging: Bool = true

        /// `true` if  `Pager`interacts with the digital crown
        var allowsDigitalCrownRotation: Bool = true

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

        /// Callback invoked when the user ends dragging and a transition will occur
        var onPageWillTransition: ((Result<PageTransition, PageTransitionError>) -> Void)?

        /// Callback invoked when a new page is set
        var onPageChanged: ((Int) -> Void)?
		
        /// Callback for a dragging began event
        var onDraggingBegan: (() -> Void)?

        /// Callback for a dragging changed event
        var onDraggingChanged: ((Double) -> Void)?

        /// Callback for a dragging ended event
        var onDraggingEnded: (() -> Void)?

        /// Callback for a digital crown rotated event
        var onDigitalCrownRotated: ((Double) -> Void)?

        /*** State and Binding properties ***/

        /// Page index
        @ObservedObject var pagerModel: Page

        #if !os(tvOS)
        /// DragGesture state to indicate whether the gesture was interrupted
        @GestureState var isGestureFinished = true
        #endif

        #if os(watchOS)

        /// Digital Crown offset
        @State var digitalCrownPageOffset: CGFloat = 0

        #endif

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
                                .frame(size: self.pageSize)
                                .scaleEffect(self.scale(for: item))
                                .rotation3DEffect((self.isHorizontal ? .zero : Angle(degrees: -90)) - self.scrollDirectionAngle,
                                                  axis: (0, 0, 1))
                                .rotation3DEffect(self.angle(for: item),
                                                  axis:  self.axis)
                                .opacity(opacity(for: item))
                        }
                    }
                }
                .offset(x: self.xOffset, y : self.yOffset)
            }
            .frame(size: size)

            #if !os(tvOS)
            var wrappedView: AnyView = swipeInteractionArea == .page ? AnyView(stack) : AnyView(stack.contentShape(Rectangle()))
            wrappedView = AnyView(wrappedView.gesture(allowsDragging ? swipeGesture : nil, priority: gesturePriority))
            #else
            let wrappedView = stack
              .focusable()
              .onMoveCommand(perform: self.onMoveCommandSent)
            #endif
          
            #if os(macOS)
            wrappedView = wrappedView
              .focusable()
              .onMoveCommand(perform: self.onMoveCommandSent)
              .eraseToAny()
            #endif

            var resultView = wrappedView
                .rotation3DEffect(
                    (isHorizontal ? .zero : Angle(degrees: 90)) + scrollDirectionAngle,
                    axis: (0, 0, 1)
                ).eraseToAny()

            if #available(iOS 13.2, macOS 10.15, tvOS 13.0, watchOS 6.0, *) {
                resultView = resultView
                    .onAnimationCompleted(for: CGFloat(pagerModel.index), completion: {
                        // #194 AnimatableModifier symbol not found in iOS 13.0 and iOS 13.1

                        if pagerModel.pageIncrement != 0 {
                            pagerModel.pageIncrement = 0
                            onPageChanged?(pagerModel.index)
                        }
                    })
                    .eraseToAny()
            }

            #if !os(tvOS)
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                resultView = resultView
                    .onChange(of: isGestureFinished) { value in
                        if value {
                            onDragGestureEnded()
                        }
                    }
                    .eraseToAny()
            }
            #endif

            #if os(watchOS)
            if #available(watchOS 7.0, *), allowsDigitalCrownRotation {
                resultView = resultView
                    .focusable()
                    .digitalCrownRotation(
                        $digitalCrownPageOffset,
                        from: 0,
                        through: CGFloat(numberOfPages - 1),
                        by: 1,
                        sensitivity: .low
                    )
                    .onChange(of: digitalCrownPageOffset) { newValue in
                        let pageIncrement = min(1, max(-1, Int(newValue - pagerModel.lastDigitalCrownPageOffset)))
                        let offset = (newValue - pagerModel.lastDigitalCrownPageOffset) - CGFloat(pageIncrement)
                        onDigitalCrownRotated?(newValue * pageDistance)
                        let animation = self.draggingAnimation.animation ?? .default
                        guard abs(pageIncrement) > 0 else {
                            withAnimation(animation) {
                                pagerModel.draggingOffset = -offset * pageDistance
                                pagerModel.objectWillChange.send()
                            }
                            return
                        }
                        withAnimation(animation) {
                            pagerModel.lastDigitalCrownPageOffset = newValue - offset
                            pagerModel.draggingOffset = -offset
                            pagerModel.update(.move(increment: pageIncrement))
                        }
                    }
                    .eraseToAny()
            }
            #endif

            return resultView.contentShape(Rectangle())
        }
    }
}

// MARK: Gestures

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pager.PagerContent {
  
    #if os(tvOS) || os(macOS)
    func onMoveCommandSent(_ command: MoveCommandDirection) {
      let animation = self.draggingAnimation.animation ?? .default
        switch (command, isHorizontal) {
        case (.left, true):
            guard !dragForwardOnly else { return }
            withAnimation(animation) { self.pagerModel.update(.previous) }
        case (.right, true):
            withAnimation(animation) { self.pagerModel.update(.next) }
        case (.up, false):
            guard !dragForwardOnly else { return }
            withAnimation(animation) { self.pagerModel.update(.previous) }
        case (.down, false):
            withAnimation(animation) { self.pagerModel.update(.next) }
        case (.down, true), (.up, true), (.left, false), (.right, false):
            break
        @unknown default:
            break
        }
    }
    #endif

    /// `DragGesture` customized to work with `Pager`
    #if !os(tvOS)
    var swipeGesture: some Gesture {
        DragGesture(minimumDistance: minimumDistance, coordinateSpace: .global)
            .updating($isGestureFinished) { _, state, _ in
                state = false
            }
            .onChanged({ value in
                if !dragForwardOnly || dragTranslation(for: value).width < 0 {
                    self.onDragChanged(with: value)
                }
            })
    }

    func onDragChanged(with value: DragGesture.Value) {
        let animation = draggingAnimation.animation
        withAnimation(animation) {
            if self.lastDraggingValue == nil {
                onDraggingBegan?()
            }

            let currentLocation = dragLocation(for: value)
            let currentTranslation = dragTranslation(for: value)
            let lastLocation = self.lastDraggingValue.flatMap(dragLocation) ?? currentLocation
            let swipeAngle = (currentLocation - lastLocation).angle ?? .zero
            // Ignore swipes that aren't on the X-Axis
            guard swipeAngle.isAlongXAxis else {
                self.pagerModel.lastDraggingValue = value
                return
            }

            let side = self.isHorizontal ? self.size.width : self.size.height
            let normalizedRatio = self.allowsMultiplePagination ? 1 : (self.pageDistance / side)
            let offsetIncrement = (currentLocation.x - lastLocation.x) * normalizedRatio

            // If swipe hasn't started yet, ignore swipes if they didn't start on the X-Axis
            let isTranslationInXAxis = abs(currentTranslation.width) > abs(currentTranslation.height)
            guard self.draggingOffset != 0 || isTranslationInXAxis else {
                return
            }

            let timeIncrement = value.time.timeIntervalSince(self.lastDraggingValue?.time ?? value.time)
            if timeIncrement != 0 {
                self.pagerModel.draggingVelocity = Double(offsetIncrement) / timeIncrement
            }

            var newOffset = self.draggingOffset + offsetIncrement * (Locale.current.isRightToLeft ? -1 : 1)
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

        let animation = pagingAnimation.animation?.speed(speed)
        if page != newPage {
            onPageWillChange?(newPage)
            onPageWillTransition?(.success(.init(currentPage: page, nextPage: newPage, pageIncrement: pageIncrement)))
        } else {
            onPageWillTransition?(.failure(.draggingStopped))
        }
        withAnimation(animation) {
            self.pagerModel.draggingOffset = 0
            self.pagerModel.pageIncrement = pageIncrement
            self.pagerModel.draggingVelocity = 0
            self.pagerModel.lastDraggingValue = nil
            self.pagerModel.index = newPage
            self.pagerModel.lastDigitalCrownPageOffset = CGFloat(pagerModel.index)
            self.pagerModel.objectWillChange.send()
            #if os(watchOS)
            digitalCrownPageOffset = CGFloat(pagerModel.index)
            #endif
        }

        // #194 AnimatableModifier symbol not found in iOS 13.0 and iOS 13.1
        if #available(iOS 13.2, macOS 10.15, tvOS 13.0, watchOS 6.0, *) {
            // Do nothing
        } else if page != newPage {
            self.pagerModel.pageIncrement = 0
            onPageChanged?(newPage)
        }
    }

    var dragResult: (page: Int, increment: Int) {
        let currentPage = self.currentPage(sensitivity: sensitivity.value)
        let velocity = -self.draggingVelocity * (Locale.current.isRightToLeft ? -1 : 1)

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

    private func dragTranslation(for value: DragGesture.Value) -> CGSize {
        let multiplier: CGFloat = scrollDirectionAngle == .zero ? 1 : -1
        if isHorizontal {
            return CGSize(
                width: value.translation.width * multiplier,
                height: value.translation.height * multiplier
            )
        } else {
            return CGSize(
                width: value.translation.height * multiplier,
                height: value.translation.width * multiplier
            )
        }
    }

    private func dragLocation(for value: DragGesture.Value) -> CGPoint {
        let multiplier: CGFloat = scrollDirectionAngle == .zero ? 1 : -1
        if isHorizontal {
            return CGPoint(
                x: value.location.x * multiplier,
                y: value.location.y * multiplier
            )
        } else {
            return CGPoint(
                x: value.location.y * multiplier,
                y: value.location.x * multiplier
            )
        }
    }
    #endif

}
