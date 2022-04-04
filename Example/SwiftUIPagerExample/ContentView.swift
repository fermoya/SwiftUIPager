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

    var body: some View {
        TabView {
            InfiniteExampleView()
                .tabItem({
                    Image(systemName: "goforward")
                    Text("Infinite")
                }).tag(0)
            ColorsExampleView()
                .tabItem({
                    Image(systemName: "forward.fill")
                    Text("Manual")
                }).tag(1)
            EmbeddedExampleView()
                .tabItem({
                    Image(systemName: "flowchart.fill")
                    Text("In ScrollView")
                }).tag(2)
            NestedExampleView()
                .tabItem({
                    Image(systemName: "rectangle.on.rectangle")
                    Text("Nested")
                }).tag(3)
            BizarreExampleView()
                .tabItem({
                    Image(systemName: "smiley")
                    Text("Bizarre")
                }).tag(4)
        }
    }

}
