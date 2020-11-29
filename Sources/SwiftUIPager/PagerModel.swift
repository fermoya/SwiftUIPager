//
//  Pager+Helper.swift
//  SwiftUIPager
//
//  Created by Fernando Moya de Rivas on 19/01/2020.
//  Copyright © 2020 Fernando Moya de Rivas. All rights reserved.
//

import SwiftUI

/// Workaround to avoid `Binding` updating after rest of `State` after drag ends
/// More info [here](https://developer.apple.com/forums/thread/667988) and [here](https://developer.apple.com/forums/thread/667720)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
class PagerModel: ObservableObject {

    @Published var page: Int

    init(page: Int) {
        self.page = page
    }

}
