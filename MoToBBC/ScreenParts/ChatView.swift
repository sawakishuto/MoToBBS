//
//  ChatView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/12/02.
//

import SwiftUI

struct ChatView: View {
    @State var textField: String = ""
    let messageTest : [Chat] = [
        Chat(id: "0", name: "しゅうと", content: "今日のご飯は！", timeStampString: Date(), qestion: true)
        ,Chat(id: "1", name: "ひろむ", content: "ホットドッグ！", timeStampString: Date(), qestion: false)
        ,Chat(id: "2", name: "かぶたん", content: "どこの！", timeStampString: Date(), qestion: true)
        ,Chat(id: "3", name: "ひろむ", content: "バロー！", timeStampString: Date(), qestion: false)
    ]
    let username: String = "しゅうと"

    var body: some View {
        GeometryReader {geometory in
            VStack {
                Text("Q&A")
                    .font(.system(size: 45))
                    .fontWeight(.black)
                    .padding(.bottom, 20)
                    .foregroundStyle(.red)
                ScrollView {
                    ForEach(messageTest) {content in
                        ChatMessage(content: content.content, qestion: content.qestion, username: content.name, timeStamp: content.dateString)
                            .frame(width: geometory.size.width - 30, alignment: content.qestion ? .trailing: .leading)
                            .padding(content.qestion ? .trailing: .leading, 30)
                    }
                }
                HStack(spacing: 0) {
                    TextField("雨天中止ですか？", text: $textField)
                        .font(.title3)
                        .padding(.horizontal, 20)
                        .frame(width: 300, height: 38 )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 3)
                        )
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "paperplane")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .padding(.leading, 20)
                            .foregroundStyle(.blue)
                    })
                }
                        .padding(.bottom, 30)
            }

        }
    }
}

#Preview {
    ChatView()
}
