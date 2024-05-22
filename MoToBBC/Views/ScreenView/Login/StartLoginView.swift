//
//  StartLoginView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/11/10.
//

import SwiftUI
import FirebaseAuth
import CoreData
struct StartLoginView: View {
    @FetchRequest(
        entity: LoginInfo.entity(),
        sortDescriptors: [NSSortDescriptor(key: "pass", ascending: false)],
        animation: .default
    ) var fetchedInfo: FetchedResults<LoginInfo>
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
    @State private var errorhandle: Bool = false
    @State private var mailname: String = " MoToBBS@gmail.com"
    @State private var passname: String = " 123456"
    @State private var isLoading = true
    var body: some View {
        if !isLoading {
            GeometryReader  {
                geometory in

                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.red, Color(
                            red: 0.6,
                            green: 0,
                            blue: 0
                        )]),
                        startPoint: .center,
                        endPoint: .bottom)
                    .ignoresSafeArea()
                    // メールアドレス
                    VStack(alignment: .center) {
                        Image("image 3")
                            .resizable()
                            .scaleEffect(0.8)
                            .scaledToFit()
                            .padding(EdgeInsets(top: geometory.size.height * -0.1, leading: 0, bottom: 5, trailing: 0))

                        TextField(mailname, text: $mail)
                            .frame(width: geometory.size.width * 0.96, height: 60)
                            .textFieldStyle(PlainTextFieldStyle())
                            .background(errorhandle ? Color(red: 0.8, green: 0.8, blue: 0.8): Color.white)
                            .cornerRadius(10)
                            .padding(.bottom, 20)

                        // パスワード
                        SecureField(passname, text: $password)
                            .frame(width: geometory.size.width * 0.96, height: 60)
                            .textFieldStyle(PlainTextFieldStyle())
                            .background(errorhandle ? Color(red: 0.8, green: 0.8, blue: 0.8): Color.white)
                            .cornerRadius(10)
                            .keyboardType(.numberPad)
                            .padding(.bottom, 20)
                        // 認証
                        Button(
                            action: {
                                if self.mail.isEmpty {
                                    mail = ""
                                    password = ""
                                    self.mailname = "メールアドレスが入力されていません"
                                } else if self.password.isEmpty {
                                    self.passname = "パスワードが入力されていません"
                                    mail = ""
                                    password = ""
                                } else {
                                    Auth.auth().signIn(withEmail: self.mail, password: self.password) { authResult, error in
                                        if authResult?.user != nil {
                                            allview = true
                                        } else {
                                            errorhandle = true
                                            mailname = "メールアドレスまたはパスワードが違います"
                                            mail = ""
                                            password = ""
                                        }
                                    }
                                }
                            }, label: {
                                Text("ログイン").frame(width: 200, height: 50)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .background(Color(red: 1, green: 1, blue: 1))
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                            })
                        Text("新規登録")
                            .foregroundColor(.white)
                            .padding(.init(top: 20, leading: 0, bottom: 0, trailing: 0))
                            .onTapGesture {
                                logingo = false
                            }

                    }
                    .padding(.top, -150)
                    .onAppear {
                        mail = fetchedInfo.first?.mail ?? ""
                        password = fetchedInfo.first?.pass ?? ""

                    }

                }

            }
        } else {
            ProgressView()
                .onAppear {
                    mail = fetchedInfo.first?.mail ?? ""
                    password = fetchedInfo.first?.pass ?? ""

                    Auth.auth().signIn(withEmail: self.mail, password: self.password) { authResult, error in
                        if authResult?.user != nil {
                            isLoading = false
                            allview = true
                        } else {
                            isLoading = false

                        }
                    }
                }
        }
    }
}

#Preview {
    StartLoginView(logingo: .constant(true), allview: .constant(false))
}
