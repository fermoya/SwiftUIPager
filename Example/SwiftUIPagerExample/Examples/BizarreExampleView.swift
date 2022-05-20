//
//  VerticalExampleView.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 02/03/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct BizarreExampleView: View {
    @StateObject var page1: Page = .first()
    @StateObject var page2: Page = .first()
    var data = Array(0..<10)

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 10) {
                Text("Vertical, alignment start").bold()
                Pager(page: self.page1,
                      data: self.data,
                      id: \.self) {
                        self.pageView($0)
                }
                .vertical()
                .alignment(.start)
                .itemSpacing(10)
                .itemAspectRatio(1.3)
                .background(Color.gray.opacity(0.2))

                Spacer()

                Text("Start to End, interactive").bold()
                Pager(page: self.page2,
                      data: self.data,
                      id: \.self) {
                        self.pageView($0)
                }
                .itemSpacing(10)
                .horizontal(.endToStart)
                .interactive(scale: 0.8)
                .itemAspectRatio(0.7)
                .background(Color.gray.opacity(0.5))
            }
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
