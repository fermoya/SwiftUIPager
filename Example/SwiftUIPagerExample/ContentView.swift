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
    
    @State var tab: Int = 0
    
    var body: some View {
        TabView {
            SimpleExampleView()
                .tabItem({
                    Text("Basic")
                }).tag(0)
            ColorsExampleView()
                .tabItem({
                    Text("Colors")
                }).tag(1)
            PresentedExampleView()
                .tabItem({
                    Text("Presented")
                }).tag(2)
            BizarreExampleView()
                .tabItem({
                    Text("More")
                }).tag(3)
        }
    }
    
}
