//
//  detail.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/21.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseAuth

struct Detail: View {
    // swiftlint:disable line_length
    @Environment(\.dismiss) var dismiss
    @State  var image: UIImage? = nil
    @State private var userInfoArray: [[String]] = []
    @State var isGood = false
    @State var goodAlert = false
    @State var messa = "参加する！"
    @ObservedObject private var viewModel = ViewModel()
    @State  var datamodel = ViewModel().datamodel
    @State var isgo = false
    @State var uid: String = ""
    @State var documentId = ""
    let username: String
    let usercomment: String
    let bikename: String
    let userid: String
    let documentinfo: String
    let eventid: String
    let  whereis: String
    let detail: String
    let title: String
    let dateString: String
    let how: String
    init(eventid: String,
         whereis: String,
         detail: String,
         title: String,
         dateStrig: String,
         how: String,
         documentinfo: String,
         username: String,
         usercomment: String,
         bikename: String,
         userid: String) {
        self.eventid = eventid
        self.whereis = whereis
        self.detail = detail
        self.title = title
        self.dateString = dateStrig
        self.how = how
        self.username = username
        self.usercomment = usercomment
        self.bikename = bikename
        self.userid = userid
        self.documentinfo = documentinfo
    }
    var body: some View {
        ZStack {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    ScrollView {
                        Text(title).font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal, 5)
                        Rectangle()
                            .frame(height: 5)
                            .foregroundColor(Color.red)
                            .cornerRadius(40)
                            .opacity(0.5)
                            .padding(.horizontal, 3)
                        Spacer()
                        VStack(alignment: .leading) {
                            HStack {
                                Capsule()
                                    .frame(width: 80)
                                    .overlay {
                                        Text("集合場所")
                                            .foregroundStyle(.white
                                            )
                                    }
                                Text(whereis)
                            }
                            .frame(height: 20)
                            .fontWeight(.bold)
                            Rectangle()
                                .frame(height: 5)
                                .foregroundColor(Color.red)
                                .cornerRadius(40)
                                .opacity(0.5)
                                .padding(.horizontal, 8)
                            HStack {
                                Capsule()
                                    .frame(width: 80)
                                    .overlay {
                                        Text("開催日時")
                                            .foregroundStyle(.white)
                                    }
                                Text(dateString)
                            }
                            .frame(height: 20)
                            .fontWeight(.bold)
                            Rectangle()
                                .frame(height: 5)
                                .foregroundColor(Color.red)
                                .cornerRadius(40)
                                .opacity(0.5)
                                .padding(.horizontal, 8)
                            HStack {
                                HStack {
                                    Capsule()
                                        .frame(width: 80)
                                        .overlay {
                                            Text("募集人数")
                                                .foregroundStyle(.white)
                                        }
                                    Text(how + "人程度")
                                }
                                .frame(height: 20)
                                .fontWeight(.bold)
                                Rectangle()
                                    .frame(width: 5, height: 30)
                                    .foregroundColor(Color.red)
                                    .cornerRadius(40)
                                    .opacity(0.5)
                                    .padding(.horizontal, 3)
                                Text("現在" + String(userInfoArray.count) + "人")
                                    .foregroundStyle(.green)
                                    .fontWeight(.bold)
                            }
                            Rectangle()
                                .frame(height: 5)
                                .foregroundColor(Color.red)
                                .cornerRadius(40)
                                .opacity(0.5)
                                .padding(.horizontal, 40)
                        }
                        .padding(.leading, 18)
                        Text("詳細:" + detail)
                            .padding(.horizontal, 18)
                        Rectangle()
                            .frame(height: 5)
                            .foregroundColor(Color.red)
                            .cornerRadius(40)
                            .opacity(0.5)
                            .padding(.horizontal, 8)
                        if let image = image {
                            Image(uiImage: image).resizable()
                                .frame(width: 330, height: 180)
                                .cornerRadius(40)
                                .overlay(RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color.red, lineWidth: 3))
                        }
                    }
                }

                Text("参加予定者").foregroundColor(.red)
                    .fontWeight(.bold)
                List(userInfoArray, id: \.self) { userInfo in
                    Text("\(userInfo[0])\n車種: \(userInfo[2])\n性別: \(userInfo[1])　")
                }
                .fontWeight(.bold)
                .listStyle(PlainListStyle()) // リストのスタイルをプレーンに設定
                .background(Color.white)
                .frame(height: 150)
                .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing: 0))
                Spacer()
                Text(messa)
                    .fontWeight(.bold)
                    .frame(width: 190, height: 60)
                    .background(Capsule().fill(Color.red))
                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
                    .padding(EdgeInsets(top: 0, leading: 18, bottom: 20, trailing: 0))
                    .onTapGesture { goodAlert = true }
                    .alert(isPresented: $goodAlert, content: {
                        Alert(
                            title: Text("このイベントに参加しますか？"),
                            message: Text(""),
                            primaryButton: .destructive(Text("いいえ"),
                                                        action: {isgo = false}),
                            secondaryButton: .default(Text("はい"),
                                                      action: {isgo = true
                                                          if isgo == true {
                                                              messa = "エントリー完了"
                                                              self.viewModel.addattend(eventid: self.eventid)
                                                              self.viewModel.GetUserInfoAndSet(
                                                                userid: self.userid,
                                                                username: self.username,
                                                                usercomment: self.usercomment,
                                                                bikename: self.bikename,
                                                                documentinfo: self.documentinfo
                                                              )
                                                          }
                                                      }
                                                     )
                        )
                    })

            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss()})
                {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 17, weight: .medium))
                        Text("戻る")
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            self.viewModel.fetchUserInfoFromAttendList(documentinfo: self.eventid) { userInfoArray in
                self.userInfoArray = userInfoArray
            }
            self.viewModel.fetchData()
            self.viewModel.getImage(eventid: self.eventid) { image in
                if let image = image {
                    // 取得した画像をStateにセットしてUIに反映する
                    self.image = image
                } else {
                    print("画像の取得に失敗しました")
                }
            }
        }
    }
}
struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        Detail(eventid: "", whereis: "", detail: "", title: "", dateStrig: "", how: "", documentinfo: "", username: "", usercomment: "", bikename: "", userid: "")}
}
