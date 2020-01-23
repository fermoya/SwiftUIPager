//
//  ContentView.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI
import SwiftUIPager

extension Int: Identifiable {
    public var id: Int { return self }
}

struct ContentView: View {

    @State var isPresented: Bool = false
    @State var pageIndex: Int = 0
    var data: [Int] = Array((0...20))
    
    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }, label: {
            Text("Tap me")
        }).sheet(isPresented: $isPresented, content: {
            self.presentedView
        })
    }

    var presentedView: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    Pager(page: self.$pageIndex,
                          data: self.data,
                          content: { index in
                            self.pageView(index)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                    })
                        .interactive(0.8)
                        .itemSpacing(10)
                        .padding(8)
                        .itemAspectRatio(0.8)
                        .itemTappable(true)
                        .frame(width: min(proxy.size.width,
                                          proxy.size.height),
                               height: min(proxy.size.width,
                                           proxy.size.height))
                        .border(Color.red, width: 2)
                    ForEach(self.data) { i in
                        Text("Page: \(i)")
                            .bold()
                            .padding()
                    }
                }
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
