//
//  ChatMessage.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/12/02.
//

import SwiftUI

struct ChatMessage: View {
    let content: String
    let qestion: Bool
    let username: String
    let timeStamp: String
    var body: some View {
        VStack(alignment:  qestion ? .trailing: .leading) {
            Text(username)
                .font(.system(size: 13))
                .foregroundStyle(Color(red: 0.3, green: 0.3, blue: 0.3))
                .fontWeight(.bold)
            Text(content)
                .padding(13)
                .background(qestion ? Color(red: 0.9, green: 0.9, blue: 0.9): Color(red: 1.0, green: 0.7, blue: 0.7) )
                .fontWeight(qestion ? .light: .bold )
                .cornerRadius(17)
            Text(timeStamp)
                .font(.system(size: 8))
                .foregroundStyle(Color(red: 0.3, green: 0.3, blue: 0.3))
        }
        .frame(width: 250,alignment: qestion ? .trailing: .leading)
    }
}

#Preview {
    ChatMessage(content: "wwwwwwww", qestion: true, username: "しゅうと", timeStamp: "1221/12/12")
}
