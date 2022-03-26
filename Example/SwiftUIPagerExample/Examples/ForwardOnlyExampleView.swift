//  ForwardOnlyExampleView.swift
//  SwiftUIPagerExample
//
//  Created by  Fred Bowker on 26/03/2022..
import SwiftUI

struct ForwardOnlyExampleView: View {
    
    @StateObject var page: Page = .first()
    
    var colors: [Color] = [
        .red, .blue, .black, .gray, .purple, .green, .orange, .pink, .yellow, .white
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack(spacing: 10) {
                    Pager(page: self.page,
                          data: self.colors,
                          id: \.self) {
                        self.pageView($0)
                    }
                          .contentLoadingPolicy(.eager)
                          .itemSpacing(10)
                          .padding(20)
                          .forwardOnly(true)
                          .frame(width: min(proxy.size.height, proxy.size.width),
                                 height: min(proxy.size.height, proxy.size.width))
                          .background(Color.gray.opacity(0.3))
                          .navigationBarTitle("Move Forward Only", displayMode: .inline)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func pageView(_ color: Color) -> some View {
        Rectangle()
            .fill(color)
            .cornerRadius(5)
            .shadow(radius: 5)
    }
}
