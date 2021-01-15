//
//  NestedExampleView.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 27/05/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct NestedExampleView: View {

    @StateObject var page: Page = .first()
    @State var pageOffset: Double = 0
    @State var nestedPages: [Page] = [
        .first(),
        .first(),
        .first(),
        .first()
    ]

    var data = Array(0..<3)
    var nestedData = Array(0..<3)

    var body: some View {
        Pager(page: self.page,
              data: self.data,
              id: \.self) { page in
                self.nestedPager(page)
        }
        .pageOffset(pageOffset)
        .swipeInteractionArea(.allAvailable)
        .background(Color.gray.opacity(0.2))
    }

    func nestedPager(_ index: Int) -> some View {
        let nestedPagerModel = nestedPages[index]
        return VStack {
            Text("Parent page: \(index)")
                .font(.system(size: 22))
                .bold()
                .padding(20)
            Spacer()
            Pager(page: nestedPagerModel,
                  data: self.nestedData,
                  id: \.self) { page in
                    self.pageView(page)
            }
            .bounces(false)
			.onDraggingBegan({
				print("Dragging Began")
			})
            .onDraggingChanged { increment in
                withAnimation {
                    if nestedPagerModel.index == self.nestedData.count - 1, increment > 0 {
                        pageOffset = increment
                    } else if nestedPagerModel.index == 0, increment < 0 {
                        pageOffset = increment
                    }
                }
            }
            .onDraggingEnded {
                guard pageOffset != 0 else { return }
                let sign = Int(pageOffset/abs(pageOffset))
                let increment: Int = (abs(pageOffset) > 0.33 ? 1 : 0) * sign
                withAnimation {
                    pageOffset = 0
                    let newIndex = page.index + increment
                    page.update(.new(index: newIndex))
                }
            }
            .itemSpacing(10)
            .itemAspectRatio(0.8, alignment: .end)
            .padding(8)
        }
    }

    func pageView(_ page: Int) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.yellow)
            Text("Nested page: \(page)")
                .bold()
        }
        .cornerRadius(5)
        .shadow(radius: 5)
    }

}
