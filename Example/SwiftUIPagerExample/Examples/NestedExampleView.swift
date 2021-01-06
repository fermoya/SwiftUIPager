//
//  NestedExampleView.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 27/05/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct NestedExampleView: View {

    @StateObject var pagerModel = PagerModel(page: 0)
    @State var pageOffset: Double = 0
    @State var nestedPagerModels: [PagerModel] = [
        PagerModel(page: 0),
        PagerModel(page: 0),
        PagerModel(page: 0),
        PagerModel(page: 0)
    ]

    var data = Array(0..<4)
    var nestedData = Array(0..<10)

    var body: some View {
        Pager(page: self.pagerModel,
              data: self.data,
              id: \.self) { page in
                self.nestedPager(page)
        }
        .pageOffset(pageOffset)
        .swipeInteractionArea(.allAvailable)
        .background(Color.gray.opacity(0.2))
    }

    func nestedPager(_ index: Int) -> some View {
        let nestedPagerModel = nestedPagerModels[index]
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
                    if nestedPagerModel.page == self.nestedData.count - 1, increment > 0 {
                        pageOffset = increment
                    } else if nestedPagerModel.page == 0, increment < 0 {
                        pageOffset = increment
                    }
                }
            }
            .onDraggingEnded { increment in
                guard pageOffset != 0 else { return }
                withAnimation {
                    pageOffset = 0
                    pagerModel.page += Int(increment.rounded())
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
