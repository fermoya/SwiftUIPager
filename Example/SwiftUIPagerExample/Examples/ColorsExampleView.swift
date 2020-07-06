//
//  ColorsExampleView.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 02/03/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct ColorsExampleView: View {

    @State var pageIndex = 0

    var colors: [Color] = [
        .red, .blue, .black, .gray, .purple, .green, .orange, .pink, .yellow, .white
    ]

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack(spacing: 10) {
                    Pager(page: self.$pageIndex,
                          data: self.colors,
                          id: \.self) {
                            self.pageView($0)
                    }
                    .contentLoadingPolicy(.eager)
                    .disableDragging()
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

                    Spacer()

                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.pageIndex = 0
                            }
                        }, label: {
                            VStack(spacing: 4) {
                                Image(systemName: "backward.end.alt.fill")
                                    .padding()
                                Text("Start")
                                    .font(.subheadline)
                            }
                        }).disabled(self.pageIndex <= 0)
                        Button(action: {
                            withAnimation {
                                self.pageIndex = max(0, self.pageIndex - 1)
                            }
                        }, label: {
                            VStack(spacing: 4) {
                                Image(systemName: "backward.end.fill")
                                    .padding()
                                Text("Previous")
                                    .font(.subheadline)
                            }
                        }).disabled(self.pageIndex <= 0)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.pageIndex = min(self.colors.count - 1, self.pageIndex + 1)
                            }
                        }, label: {
                            VStack(spacing: 4) {
                                Image(systemName: "forward.end.fill")
                                    .padding()
                                Text("Next")
                                    .font(.subheadline)
                            }
                        }).disabled(self.pageIndex >= self.colors.count - 1)
                        Button(action: {
                            withAnimation {
                                self.pageIndex = self.colors.count - 1
                            }
                        }, label: {
                            VStack(spacing: 4) {
                                Image(systemName: "forward.end.alt.fill")
                                    .padding()
                                Text("End")
                                    .font(.subheadline)
                            }
                        }).disabled(self.pageIndex >= self.colors.count - 1)
                        Spacer()
                    }

                    Spacer()
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
