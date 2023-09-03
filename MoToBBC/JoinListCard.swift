//
//  JoinListView Card.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/05/27.
//

import SwiftUI
struct JoinDisplayContents {
    let eventid: String
    let  whereis: String
    let detail: String
    let title: String
    let dateString: String
    let how: String

}
struct JoinListCard: View {
    @State private var userInfoArray: [[String]] = []
    @State private var isShowSelect = false
    @ObservedObject private var viewModel = ViewModel()
    @State var events: [Events] = []
    @State var alerttitle = "タイトル"
    @State var alertmessage = "メッセ"
    var contents: JoinDisplayContents

    var body: some View {
        ZStack(alignment: .bottom) {
                VStack {
                    ScrollView {
                        Text(contents.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                        Text("集合場所:" + contents.whereis)
                            .frame(height: 30)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .fontWeight(.bold)
                        Text("開催日時:" + contents.dateString + "頃")
                            .frame(height: 30)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .fontWeight(.bold)
                        Text("募集人数:" + contents.how + "人程度")
                            .frame(height: 30)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .fontWeight(.bold)
                        Text(contents.detail)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10 ))
                        Divider()
                            .background(Color.red)
                        Text("参加予定者")
                            .foregroundColor(.red) .fontWeight(.bold)
                        List(userInfoArray, id: \.self) { userInfo in
                            Text("名前: \(userInfo[0])\n車種: \(userInfo[2])\n性別: \(userInfo[1])　")
                                }
                        .fontWeight(.bold)
                        .listStyle(PlainListStyle()) // リストのスタイルをプレーンに設定
                            .background(Color.white)
                            .frame(height: 200)
                            .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing: 0))
                    }
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 80, trailing: 0))
                }
                .frame(width: 330, height: 600)
                .padding()
                .background(.white)
                .cornerRadius(18)
                .clipped()
                .shadow(color: .gray.opacity(0.7), radius: 10)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.red, lineWidth: 4))
            Text("ツーリング終了")
                .zIndex(3)
                .frame(width: 120, height: 50)
                .background(Capsule().fill(Color(red: 50, green: 10 / 255, blue: 10 / 255)))
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 180))
                .onTapGesture {
                    alerttitle = "ツーリング終了"
                    alertmessage = "ツーリングを終了します。お疲れ様でした。"
                    isShowSelect.toggle()
                    self.viewModel.deleteEvent(eventid: contents.eventid)
                    self.viewModel.findAndDeleteAttendee(documentInfo: contents.eventid)
                    self.viewModel.fetchJoinedData { (events) in
                        self.events = events
                    }
                }
            Text("キャンセル")
                .zIndex(3)
                .frame(width: 120, height: 50)
                .background(Capsule().fill(Color.gray))
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                .padding(EdgeInsets(top: 0, leading: 180, bottom: 30, trailing: 0))
                .onTapGesture {
                    alerttitle = "キャンセル"
                    alertmessage = "ツーリングをキャンセルしました。"
                    self.viewModel.findAndDeleteAttendee(documentInfo: contents.eventid)
                    isShowSelect.toggle()
                    self.viewModel.deleteEvent(eventid: contents.eventid)
                    self.viewModel.fetchJoinedData { (events) in
                        self.events = events
                    }
                }
        }
        .onAppear {
            self.viewModel.fetchUserInfoFromAttendList(documentinfo: contents.eventid) { userInfoArray in
                self.userInfoArray = userInfoArray
            }
        }
        .alert(isPresented: $isShowSelect) {
            Alert(title: Text(alerttitle), message: Text(alertmessage))
        }
    }
}

struct JoinListCard_Previews: PreviewProvider {
    static var previews: some View {
        JoinListCard(contents: JoinDisplayContents(eventid: "",
                                                   whereis: "", detail: "",
                                                   title: "",
                                                   dateString: "",
                                                   how: ""))
    }
}
