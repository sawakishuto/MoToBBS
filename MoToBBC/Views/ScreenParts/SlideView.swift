//
//  SlideView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/09/05.
//

import SwiftUI

struct SlideView<T: View>: View {
    private let content: () -> T
    init(@ViewBuilder content: @escaping () -> T) {
        let currenTintColor = UIColor.black
            UIPageControl.appearance().currentPageIndicatorTintColor = currenTintColor
            UIPageControl.appearance().pageIndicatorTintColor = currenTintColor.withAlphaComponent(0.2)
        self.content = content
    }
    var body: some View {
        TabView {
            content()
        }
        .tabViewStyle(.page)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
    }
}
