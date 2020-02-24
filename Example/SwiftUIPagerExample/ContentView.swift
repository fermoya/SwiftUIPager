//
//  ContentView.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

extension Color {
    var rgb: String { "\(self)".capitalized }
}

struct ContentView: View {

    @State var isPresented: Bool = false
    @State var pageIndex: Int = 0

    var colors: [Color] = [
        .red, .blue, .black, .gray, .purple, .green, .orange, .pink, .yellow, .white
    ]

//    var body: some View {
//        NavigationView {
//            GeometryReader { proxy in
//                VStack {
//                    Pager(data: Array(0..<10),
//                          id: \.self) {
//                            self.pageView($0)
//                    }
//                    .itemSpacing(10)
//                    .itemAspectRatio(0.8, alignment: .end)
//                    .padding(8)
//                    .frame(width: min(proxy.size.height, proxy.size.width),
//                           height: min(proxy.size.height, proxy.size.width))
//                        .background(Color.gray.opacity(0.2))
//                }
//            }.navigationBarTitle("SwiftUIPager", displayMode: .inline)
//        }
//    }
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack {
                    Pager(data: self.colors,
                          id: \.self) {
                            self.pageView($0)
                    }
                    .itemSpacing(10)
                    .padding(20)
                    .onPageChanged({ page in
                        withAnimation {
                            self.pageIndex = page
                        }
                    })
                    .frame(width: min(proxy.size.height, proxy.size.width),
                           height: min(proxy.size.height, proxy.size.width))
                        .background(Color.gray.opacity(0.3))
                        .navigationBarTitle("Color Picker", displayMode: .inline)

                    Spacer()

                    HStack {
                        Spacer()
                        Circle()
                            .fill(self.colors[self.pageIndex])
                            .frame(width: 80)
                            .overlay(Circle().stroke(self.pageIndex < 4 ? Color.gray.opacity(0.5) : Color.black, lineWidth: 5))
                        Spacer()
                        Text("\(self.colors[self.pageIndex].rgb)")
                        Spacer()
                    }
                }
            }
        }
    }

}

extension ContentView {

//    func pageView(_ page: Int) -> some View {
//        ZStack {
//            Rectangle()
//                .fill(Color.yellow)
//            Text("Page: \(page)")
//                .bold()
//        }
//        .cornerRadius(5)
//        .shadow(radius: 5)
//    }

    func pageView(_ color: Color) -> some View {
        Rectangle()
            .fill(color)
            .cornerRadius(5)
            .shadow(radius: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
