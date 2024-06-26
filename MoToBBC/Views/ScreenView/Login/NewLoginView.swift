//
//  NewLoginView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/11/10.
//

import SwiftUI
import FirebaseAuth
import CoreData

struct NewLoginView: View {
    @ObservedObject private var loginModel = LoginModel()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: LoginInfo.entity(),
        sortDescriptors: [NSSortDescriptor(key: "pass", ascending: false)],
        animation: .default
    ) var fetchedInfo: FetchedResults<LoginInfo>
    @State var tutorialOpen = false
    @State private var checkerror: Bool = false
    @State var showsheet = false
    @State var showconfine = false
    @State public var usersname: String = ""
    @State public var bikename: String = ""
    @State public var usercomment: String = ""
    @Binding var logingo: Bool
    @State var eventid: String = ""
    @State var userid: String = ""
    @State public var mail: String = ""
    @State public var password: String = ""
    @State public var errorMessage: String = ""
    @State var profile = false
    @State  var checkms = false
    @Binding var allview: Bool
    @State var checkname = "checkmark.circle"
    @State private var male: Bool = false
    @State private var female: Bool = false
    @State private var andSoOn: Bool = false
    @State private var mailnames: String = "MoToBBS@email.com"
    @State private var passnames: String = "123456"
    @State private var authState:String = ""
    @State private var progresState:String = "新規登録"
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.red, Color(red: 0.6, green: 0, blue: 0)]), startPoint: .center, endPoint: .bottom)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 30) {
                    // メールアドレス
                    VStack(alignment: .leading) {
                        Text("メールアドレス")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))

                        TextField(mailnames, text: $mail)
                            .frame(height: 60)
                            .textFieldStyle(PlainTextFieldStyle())
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    VStack(alignment: .leading) {
                        Text("パスワード(数字6桁以上)")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))

                        // パスワード
                        SecureField(passnames, text: $password)
                            .frame(height: 60)
                            .textFieldStyle(PlainTextFieldStyle())
                            .background(Color.white)
                            .cornerRadius(10)
                            .keyboardType(.numberPad)
                            .padding()
                    }
                    VStack(alignment: .leading) {
                        Text("ユーザーネーム(変更不可)")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        TextField("タロー,モトさん", text: $usersname)
                            .frame(height: 60)
                            .textFieldStyle(PlainTextFieldStyle())
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    VStack(alignment: .leading) {
                        Text("乗っているバイクの車種")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                        TextField("  ドラッグスタークラシック400　YZF-R15", text: $bikename)
                            .frame(height: 60)
                            .textFieldStyle(PlainTextFieldStyle())
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    VStack {
                        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) {
                            Text("男性")
                                .foregroundStyle(male ? .black : .white)
                                .fontWeight(male ? .black : .regular)
                                .onTapGesture {
                                    male = true
                                    female = false
                                    andSoOn = false
                                    usercomment = "男性"
                                }
                            Text("女性")
                                .foregroundStyle(female ? .black : .white)
                                .fontWeight(female ? .black : .regular)
                                .onTapGesture {
                                    male = false
                                    female = true
                                    andSoOn = false
                                    usercomment = "女性"
                                }
                            Text("その他")
                                .foregroundStyle(andSoOn ? .black : .white)
                                .fontWeight(andSoOn ? .black : .regular)
                                .onTapGesture {
                                    male = false
                                    female = false
                                    andSoOn = true
                                    usercomment = "その他"
                                }
                        }
                    }
                    // 認証

                    HStack {
                        Button("利用規約") {
                            self.showsheet = true
                        }.foregroundColor(.white)
                            .sheet(isPresented: $showsheet) {  TermsOfService()}
                        Image(systemName: checkname)
                            .onTapGesture {
                                self.checkms.toggle()
                                self.showconfine.toggle()
                                if self.checkms == true {
                                    self.checkname = "checkmark.circle.fill"
                                } else {
                                    self.checkname = "checkmark.circle"
                                }
                            }
                    }
                    if checkerror {Text("利用規約に同意してください。")
                        .foregroundStyle(.white)}
                    if authState != "" {
                        Text("入力された情報が不適切です")
                            .foregroundStyle(.white)
                    }
                    Button(
                        action: {
                            if self.mail.isEmpty {
                                self.mailnames = " メールアドレスが未入力です。"
                            } else if self.password.isEmpty {
                                self.passnames = " パスワードが入力されていません"
                            } else if(self.showconfine != true) {
                                checkerror = true
                                errorMessage = "利用規約に同意していません"} else if self.password.count < 6{
                                    passnames = "パスワードが６桁未満です"
                                    password = ""
                                }
                            else {
                                progresState = "新規登録中"
                                Auth.auth().createUser(withEmail: self.mail, password: self.password) { authResult, error in
                                    if let error = error {
                                        authState = "新規登録失敗"
                                        progresState = "新規登録"
                                        print(error)
                                    } else {
                                        DispatchQueue.global().async {
                                            addLoginInfo(mail: mail, pass: password)
                                            loginModel.adduser(
                                                usersname: usersname,
                                                bikename: bikename,
                                                usercomment: usercomment,
                                                users: authResult?.user.uid
                                            )
                                        }
                                        DispatchQueue.main.async {
                                            allview.toggle()
                                        }

                                    }
                                }
                            }
                        }, label: {
                            Text(progresState).frame(width: 200, height: 50) .foregroundColor(.black)
                                .fontWeight(.bold)
                                .background(Color(.white))
                                .cornerRadius(10)
                        }
                    )
                    Button(action: {logingo = true}, label: {
                        Text("ログイン")
                            .foregroundColor(.white)
                            .padding(.init(top: 20, leading: 0, bottom: 0, trailing: 0))
                    })
                }
            }
        }
    }
    private func addLoginInfo(mail: String, pass: String) {
        let info = LoginInfo(context: viewContext)
        info.mail = mail
        info.pass = pass
        try? viewContext.save()
        print("保存成功")
        print(mail)
        print(pass)

    }
}

#Preview {
    NewLoginView(logingo: .constant(true), allview: .constant(false))
}
