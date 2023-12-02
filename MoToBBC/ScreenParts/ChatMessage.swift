//
//  ChatMessage.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/12/02.
//

import SwiftUI

struct ChatMessage: View {
    let content: String = "こんにちはこんにちはこんにちはこんにちはこんにちはこんにちはこんにちはこんにちはこんにちは"
    let qestion: Bool = false
    let username: String = "しゅうと"
    var body: some View {
        VStack(alignment: .leading) {
            Text(username)
                .font(.system(size: 13))
                .foregroundStyle(Color(red: 0.3, green: 0.3, blue: 0.3))
                .fontWeight(.bold)
            Text(content)
                .padding(13)
                .background(qestion ? Color(red: 0.9, green: 0.9, blue: 0.9): Color(red: 1.0, green: 0.7, blue: 0.7) )
                .fontWeight(qestion ? .light: .bold )
                .cornerRadius(17)
        }
        .frame(width: 250)
    }
}

#Preview {
    ChatMessage()
}
