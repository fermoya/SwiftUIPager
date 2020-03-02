//
//  PresentedExampleView.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 02/03/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct PresentedExampleView: View {
    @State var isPresented: Bool = false
    @State var page: Int = 0
    @State var data = Array(0..<10)

    var colors: [Color] = [
        .red, .blue, .black, .gray, .purple, .green, .orange, .pink, .yellow, .white
    ]

    var body: some View {
        Button(action: {
            self.isPresented.toggle()
        }, label: {
            Text("Tap me to present")
        }).sheet(isPresented: $isPresented) {
            self.presented
        }
    }

    var presented: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView {
                    VStack {
                        Pager(page: self.$page,
                              data: self.data,
                              id: \.self) { page in
                                NavigationLink(destination: Text("Page \(page) tapped"), label: {
                                    self.pageView(page)
                                })
                        }
                        .rotation3D()
                        .itemSpacing(10)
                        .itemAspectRatio(0.8, alignment: .end)
                        .padding(8)
                        .frame(width: min(proxy.size.height, proxy.size.width),
                               height: min(proxy.size.height, proxy.size.width))
                            .background(Color.gray.opacity(0.2))

                        ForEach(self.colors, id: \.self) { color in
                            Text("Some View")
                                .foregroundColor(color)
                                .padding()
                        }
                    }
                }
            }.navigationBarTitle("SwiftUIPager", displayMode: .inline)
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
