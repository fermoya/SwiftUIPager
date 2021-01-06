//
//  InfiniteExampleView.swift
//  SwiftUIPagerExample
//
//  Created by Fernando Moya de Rivas on 02/03/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

struct InfiniteExampleView: View {

    @StateObject var page1 = PagerModel(page: 0)
    @StateObject var page2 = PagerModel(page: 0)
    @State var data1 = Array(0..<20)
    @State var isPresented: Bool = false
    var data2 = Array(0..<20)

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                VStack(spacing: 10) {
                    Text("Appending on the fly")
                        .bold()
                        .padding(.top)
                    Pager(page: self.page1,
                          data: self.data1,
                          id: \.self) {
                            self.pageView($0)
                    }
                    .singlePagination(ratio: 0.5, sensitivity: .high)
                    .onPageChanged({ page in
                        guard page == self.data1.count - 2 else { return }
                        guard let last = self.data1.last else { return }
                        let newData = (1...5).map { last + $0 }
                        withAnimation {
                            self.isPresented.toggle()
                            self.data1.append(contentsOf: newData)
                        }
                    })
                    .pagingPriority(.simultaneous)
                    .preferredItemSize(CGSize(width: 200, height: 100))
                    .itemSpacing(10)
                    .background(Color.gray.opacity(0.2))
                    .alert(isPresented: self.$isPresented, content: {
                        Alert(title: Text("Congratulations!"),
                              message: Text("Five more elements were appended to your Pager"),
                              dismissButton: .default(Text("Okay!")))
                    })

                    Spacer()

                    Text("Looping Pager")
                        .bold()
                    Pager(page: self.page2,
                          data: self.data2,
                          id: \.self) {
                            self.pageView($0)
                    }
                    .pagingPriority(.simultaneous)
                    .loopPages()
                    .sensitivity(.high)
                    .itemSpacing(10)
                    .itemAspectRatio(1.3, alignment: .start)
                    .padding(20)
                    .background(Color.gray.opacity(0.2))
                }
                .navigationBarTitle("Infinite Pagers", displayMode: .inline)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }

    func pageView(_ page: Int) -> some View {
        ZStack {
            Rectangle()
                .fill(Color.yellow)
            NavigationLink(destination: Text("Page \(page)")) {
                Text("Page \(page)")
            }
        }
        .cornerRadius(5)
        .shadow(radius: 5)
    }

}


struct InfiniteExampleView_Previews: PreviewProvider {
    static var previews: some View {
        InfiniteExampleView()
    }
}
