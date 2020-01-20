//
//  Pager.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 05/12/2019.
//  Copyright © 2019 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct Pager<Data, Content>: View  where Content: View, Data: Identifiable & Equatable {

    enum Direction {
        case forward, backward
    }

    /** Constants **/

    /// Should be greather than 1
    let recyclingRatio = 4

    /** Dependencies **/
    
    let content: (Data) -> Content
    var data: [Data]

    /** ViewModified properties **/
    
    var interactiveScale: CGFloat = 1
    var contentOffset: CGFloat = 0
    var shadowColor: Color = .clear
    var onPageChanged: ((Int) -> Void)?
    var verticalInsets: CGFloat = 0
    var itemSpacing: CGFloat = 0
    var pageAspectRatio: CGFloat = 1
    
    /** Dragging offset **/
    
    @State var size: CGSize = .zero
    @State var draggingOffset: CGFloat = 0
    @State var draggingStartTime: Date! = nil
    @Binding var page: Int {
        didSet {
            onPageChanged?(page)
        }
    }

    init(page: Binding<Int>, data: [Data], pageAspectRatio: CGFloat = 1, content: @escaping (Data) -> Content) {
        self._page = page
        self.pageAspectRatio = max(0, pageAspectRatio)
        self.data = data
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: self.interactiveItemSpacing) {
            ForEach(self.dataDisplayed) { item in
                self.content(item)
                    .frame(size: self.pageSize)
                    .scaleEffect(self.scale(for: item))
                    .onTapGesture (perform: {
                        withAnimation(.spring()) {
                            self.scrollToItem(item)
                        }
                    }).shadow(color: self.shadowColor, radius: 5)
                    .transition(.identity)
            }
            .offset(x: self.xOffset, y : 0)
        }
        .clipped()
        .gesture(self.swipeGesture)
        .sizeTrackable($size)
    }
}

// MARK: Gestures

extension Pager {
    
    func scrollToItem(_ item: Data) {
        guard let index = data.firstIndex(of: item) else { return }
        self.page = index
    }

    var swipeGesture: some Gesture {
        DragGesture()
            .onChanged({ value in
                withAnimation {
                    self.draggingStartTime = self.draggingStartTime ?? value.time
                    self.draggingOffset = value.translation.width
                }
            }).onEnded({ (value) in
                let velocity = -Double(value.translation.width) / value.time.timeIntervalSince(self.draggingStartTime ?? Date())
                var newPage = self.currentPage
                if newPage == self.page, abs(velocity) > 1000 {
                    newPage = newPage + Int(velocity / velocity)
                }
                newPage = max(0, min(self.numberOfPages - 1, newPage))
                withAnimation(.easeOut) {
                    self.page = newPage
                    self.draggingOffset = 0
                    self.draggingStartTime = nil
                }
            }
        )
    }

}
