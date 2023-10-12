//
//  MytoringView.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/05/16.
//

// swiftlint:disable line_length
import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseAuth

struct MytoringView: View {
    @Environment(\.dismiss) var dismiss
    @State  var image: UIImage? = nil
    @State var goodAlert = false
    @State private var showlist = false
    @State private var userInfoArray: [[String]] = []
    @State var messa = "ツーリング終了！"
    @ObservedObject private var viewModel = ViewModel()
    @State  var datamodel = ViewModel().datamodel
    @State var isgo = false
    @State var uid: String = ""
    @State var documentId = ""
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
         how: String) {
        self.eventid = eventid
        self.whereis = whereis
        self.detail = detail
        self.title = title
        self.dateString = dateStrig
        self.how = how
    }
    var body: some View {
        VStack(spacing: 8) {
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
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Capsule()
                                .frame(width: 80, height: 30)
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
                                .frame(width: 80, height: 30)
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
                                    .frame(width: 80, height: 30)
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
                 else {Text("画像を読み込んでいます...")}
                }
                .frame(alignment: .bottom)
                Spacer()
                VStack {
                    Button("参加予定者一覧") {  self.showlist.toggle()}
                           .sheet(isPresented: $showlist) {
                               JoinPersonList(eventid: self.eventid,
                                              whereis: self.whereis,
                                              detail: self.detail,
                                              title: self.title,
                                              dateStrig: self.dateString,
                                              how: self.how)
                        }
                }
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                Text(messa)
                    .frame(width: 190, height: 60)
                    .background(Capsule().fill( Color(red: 50, green: 10 / 255, blue: 10 / 255)))
                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
                    .padding(.bottom, 60)
                    .onTapGesture { goodAlert.toggle() }
                    .alert(isPresented: $goodAlert, content: {
                        Alert(
                            title: Text("イベントを終了しますか？"),
                            message: Text(""),
                            primaryButton: .destructive(
                                Text("いいえ"),
                                action: { isgo = false }),
                            secondaryButton: .default(Text("はい"), action: {
                                                         isgo = true
                                                         if isgo == true {
                                                             messa = "お疲れ様でした！"
                                                             self.viewModel.deleteImage()
                                                             self.viewModel.deleteDocument()
                                                             self.viewModel.AttendListclear(eventid: self.eventid)
                                                             self.viewModel.getUser()
                                                             dismiss()
                                                         }
                                                     })
                        )
                    })
            }
            .frame(alignment: .bottom)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    })
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
                self.viewModel.getUser()
                self.viewModel.getImage(eventid: self.eventid) { image in
                    if let image = image {
                        // 取得した画像をStateにセットしてUIに反映する
                        self.image = image
                    } else { print("画像の取得に失敗しました") }
                }
            }
        }
        }

struct MytoringView_Previews: PreviewProvider {
    static var previews: some View {
       MytoringView(eventid: "現在募集中のツーリングはありません", whereis: "1", detail: "", title: "", dateStrig: "", how: "")
    }
}
