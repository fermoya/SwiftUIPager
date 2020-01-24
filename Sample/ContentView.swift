//
//  ContentView.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI
import SwiftUIPager

struct ContentView: View {

    @State var isPresented: Bool = false
    @State var pageIndex: Int = 0
    var data: [Int] = Array((0...5))
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Pager(page: self.$pageIndex,
                      data: self.data,
                      id: \.self,
                      content: { index in
                        self.pageView(index)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                })
                    .itemSpacing(10)
                    .alignment(.start)
                    .horizontal(.rightToLeft)
                    .itemAspectRatio(0.6)
                    .frame(width: min(proxy.size.width,
                                      proxy.size.height),
                           height: min(proxy.size.width,
                                       proxy.size.height))
                    .border(Color.red, width: 2)
                Spacer()
                Text("Page: \(self.pageIndex)")
                    .bold()
                Spacer()
            }
        }
    }

}

extension ContentView {
    func pageView(_ page: Int) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.yellow)
            Text("Page: \(page)")
                .bold()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
