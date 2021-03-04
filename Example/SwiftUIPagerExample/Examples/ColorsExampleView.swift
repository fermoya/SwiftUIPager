//
//  ColorsExampleView.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 02/03/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct ColorsExampleView: View {

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
                    .disableDragging()
                    .itemSpacing(10)
                    .padding(20)
                    .frame(width: min(proxy.size.height, proxy.size.width),
                           height: min(proxy.size.height, proxy.size.width))
                    .background(Color.gray.opacity(0.3))
                    .navigationBarTitle("Color Picker", displayMode: .inline)
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Circle()
                            .fill(self.colors[self.page.index])
                            .frame(width: 80)
                            .overlay(Circle().stroke(self.page.index < 4 ? Color.gray.opacity(0.5) : Color.black, lineWidth: 5))
                        Spacer()
                        Text("\(self.colors[self.page.index].rgb)")
                        Spacer()
                    }

                    Spacer()

                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.page.update(.moveToFirst)
                            }
                        }, label: {
                            VStack(spacing: 4) {
                                Image(systemName: "backward.end.alt.fill")
                                    .padding()
                                Text("Start")
                                    .font(.subheadline)
                            }
                        }).disabled(self.page.index <= 0)
                        Button(action: {
                            withAnimation {
                                self.page.update(.previous)
                            }
                        }, label: {
                            VStack(spacing: 4) {
                                Image(systemName: "backward.end.fill")
                                    .padding()
                                Text("Previous")
                                    .font(.subheadline)
                            }
                        }).disabled(self.page.index <= 0)
                        Spacer()
                        Button(action: {
                            withAnimation {
                                self.page.update(.next)
                            }
                        }, label: {
                            VStack(spacing: 4) {
                                Image(systemName: "forward.end.fill")
                                    .padding()
                                Text("Next")
                                    .font(.subheadline)
                            }
                        }).disabled(self.page.index >= self.colors.count - 1)
                        Button(action: {
                            withAnimation {
                                self.page.update(.moveToLast)
                            }
                        }, label: {
                            VStack(spacing: 4) {
                                Image(systemName: "forward.end.alt.fill")
                                    .padding()
                                Text("End")
                                    .font(.subheadline)
                            }
                        }).disabled(self.page.index >= self.colors.count - 1)
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
