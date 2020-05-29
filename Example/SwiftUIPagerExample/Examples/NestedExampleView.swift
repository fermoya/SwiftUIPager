//
//  NestedExampleView.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 27/05/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct NestedExampleView: View {

    @State var page: Int = 0
    @State var nestedPages: [Int] = [0, 0, 0, 0]

    var data = Array(0..<4)
    var nestedData = Array(0..<10)

    var body: some View {
        Pager(page: self.$page,
              data: self.data,
              id: \.self) { page in
                self.nestedPager(page)
        }
        .swipeInteractionArea(.allAvailable)
//        .onAppear {
//            self.page = 0
//        }
        .background(Color.gray.opacity(0.2))
    }

    func nestedPager(_ index: Int) -> some View {
        let binding = Binding<Int>(
            get: {
                self.nestedPages[index]
        }, set: { newValue in
            var newNestedPages = self.nestedPages
            newNestedPages[index] = newValue
            self.nestedPages = newNestedPages
        })

        return VStack {
            Text("Parent page: \(index)")
                .font(.system(size: 22))
                .bold()
                .padding(20)
            Spacer()
            Pager(page: binding,
                  data: self.nestedData,
                  id: \.self) { page in
                    self.pageView(page)
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
