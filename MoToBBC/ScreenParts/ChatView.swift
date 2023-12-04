//
//  ChatView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/12/02.
//

import SwiftUI
import FirebaseFirestore

struct ChatView: View {
    @ObservedObject private var viewModel = ViewModels()
    var db = Firestore.firestore()
    @State var textField: String = ""
    @State private var ChatList: [Chat] = []
    @State private var firstText: String = ""
    let eventid: String
    let username: String = "しゅうと"
    var body: some View {
        ScrollViewReader { proxy in
            GeometryReader {geometory in

                VStack {
                    HStack {
                        Text("Q")
                            .font(.system(size: 45))
                            .fontWeight(.black)
                            .padding(.bottom, 20)
                            .foregroundStyle(.red)
                            .padding(.trailing,0)
                        Text("&")
                            .font(.system(size: 25))
                            .fontWeight(.black)
                            .padding(.bottom, 20)
                            .foregroundStyle(.gray)
                            .padding(.top,18)

                        Text("A")
                            .font(.system(size: 45))
                            .fontWeight(.black)
                            .padding(.bottom, 20)
                            .foregroundStyle(Color(red: 0.4, green: 0.4, blue: 0.4))
                    }

                    ScrollView {
                        ForEach(ChatList) {content in
                            ChatMessage(
                                content: content.content,
                                qestion: content.qestion,
                                username: content.name,
                                timeStamp: content.dateString
                            )
                            .frame(width: geometory.size.width - 30, alignment: content.qestion ? .trailing: .leading)
                            .padding(content.qestion ? .trailing: .leading, 30)
                            .padding(.bottom, 20)
                        }
                    }
                    HStack(spacing: 0) {
                        TextField(firstText, text: $textField)
                            .font(.title3)
                            .padding(.horizontal, 20)
                            .frame(width: 300, height: 38 )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 3)
                            )
                        Button(action: {
                            viewModel.GetUserInfomationAndChat(eventid: eventid, content: textField)
                            firstText = ""
                            textField = ""

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
                .onAppear {
                        viewModel.getChatContent(eventid: eventid) { chatList in
                            ChatList.removeAll()
                            ChatList.append(contentsOf: chatList)


                    }

                }
            }
        }


    }
}

#Preview {
    ChatView(eventid: "")
}
