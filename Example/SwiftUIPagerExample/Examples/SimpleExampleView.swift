//
//  SimpleExampleView.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 02/03/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct InfiniteExampleView: View {

    @State var page: Int = 0
    @State var data = Array(0..<10)

    var body: some View {
        GeometryReader { proxy in
            Pager(page: self.$page,
                  data: self.data,
                  id: \.self) {
                    self.pageView($0)
            }
            .onPageChanged({ page in
                guard page == self.data.count - 2 else { return }
                guard let last = self.data.last else { return }
                let newData = (1...10).map { last + $0 }
                self.data.append(contentsOf: newData)
            })
            .itemSpacing(10)
            .itemAspectRatio(1.3, alignment: .end)
            .padding(20)
            .frame(width: min(proxy.size.height, proxy.size.width),
                   height: min(proxy.size.height, proxy.size.width))
                .background(Color.gray.opacity(0.2))
        }
    }

    func pageView(_ page: Int) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.yellow)
            Text("Page: \(page)")
                .bold()
        }
        .cornerRadius(5)
        .shadow(radius: 5)
    }

}
