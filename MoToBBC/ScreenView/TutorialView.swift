//
//  TutorialView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/11/12.
//

import SwiftUI

struct TutorialView: View {
    private var PageStr: [String] = ["FirstPage", "SecondPage", "ThirdPage", "ForthPage", "FifthPage"]
    var body: some View {
        SlideView {
            ForEach(0..<PageStr.count) {str in
                Image(PageStr[str])
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .shadow(radius: 10)
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    TutorialView()
}
