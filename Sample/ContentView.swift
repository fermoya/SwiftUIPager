//
//  ContentView.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

extension Int: Identifiable {
    public var id: Int { return self }
}

struct ContentView: View {
    
    @State var pageIndex: Int = 0
    var data: [Int] = Array((0...20))
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Pager(page: self.$pageIndex,
                      data: self.data,
                      content: { index in
                        self.pageView(index)
                })
                    .interactive(0.2)
                    .itemSpacing(10)
                    .padding(30)
                    .pageAspectRatio(0.6)
                    .background(Color.red)
                    .frame(width: min(proxy.size.width,
                                      proxy.size.height),
                           height: min(proxy.size.width,
                                       proxy.size.height))
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
                .border(Color.black)
            Text("Page: \(page)")
                .bold()
                .background(Color.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
