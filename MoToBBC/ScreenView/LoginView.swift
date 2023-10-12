import SwiftUI
import FirebaseAuth
import FirebaseFirestore
// swiftlint:disable line_length
// swiftlint:disable control_statement
struct LoginView: View {
    @ObservedObject private var viewModel = LoginViewModel()
    @State var showsheet = false
    @State var showconfine = false
    @State public var usersname: String = ""
    @State public var bikename: String = ""
    @State public var usercomment: String = ""
    @State var logingo = true
    @State var eventid: String = ""
    @State var loginshow = false
    @State var allview = false
    @State var userid: String = ""
    @State public var mail: String = ""
    @State public var password: String = ""
    @State public var errorMessage: String = ""
    @State var profile = false
    @State var check = false
    @State  var checkms = false
    @State private var errorhandle: Bool = false
    @State var checkname = "checkmark.circle"
    @State private var mailname: String = " MoToBBS@gmail.com"
    @State private var passname: String = " 123456"
    var body: some View {
        if loginshow == false {
            if allview == false {
                if logingo == true {
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
                        VStack {
                            Image("image 3").padding(EdgeInsets(top: -200, leading: 0, bottom: 5, trailing: 0))
                            TextField(mailname, text: $mail)
                                .frame(height: 60)
                                .textFieldStyle(PlainTextFieldStyle())
                                .background(errorhandle ? Color.gray: Color.white)
                                .cornerRadius(10)
                                .padding()
                            // パスワード
                            SecureField(passname, text: $password)
                                .frame(height: 60)
                                .textFieldStyle(PlainTextFieldStyle())
                                .background(errorhandle ? Color.gray: Color.white)
                                .cornerRadius(10)
                                .padding()
                            // 認証
                            Button(
                                action: {
                                    if self.mail.isEmpty {
                                        self.mailname = " メールアドレスが入力されていません"
                                    } else if self.password.isEmpty {
                                        self.passname = "パスワードが入力されていません"
                                    } else {
                                        Auth.auth().signIn(withEmail: self.mail, password: self.password) { authResult, error in
                                            if authResult?.user != nil {
                                                allview = true
                                            } else {
                                                errorhandle = true
                                                mailname = "　　　メールアドレスまたはパスワードが違います"
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
                    }
                }
                else if(logingo == false) {
                    ZStack {
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
                                    
                                    TextField("　MotoBBS@gmail.com", text: $mail)
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
                                    SecureField("　1234567", text: $password)
                                        .frame(height: 60)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .keyboardType(.numberPad)
                                        .padding()
                                }
                                VStack(alignment: .leading) {
                                    Text("氏名")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                    TextField("　本山太郎", text: $usersname)
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
                                VStack(alignment: .leading) {
                                    Text("性別")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.white)
                                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                                    TextField("　男　女　その他", text: $usercomment)
                                        .frame(height: 60)
                                        .textFieldStyle(PlainTextFieldStyle())
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .padding()
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
                                Button(
                                    action: {
                                        if self.mail.isEmpty {
                                            self.mail = "　　　　　メールアドレスが未入力です。"
                                        } else if self.password.isEmpty {
                                            self.errorMessage = "パスワードが入力されていません"
                                        } else if(self.showconfine != true) {
                                            errorMessage = "利用規約に同意していません"} else {
                                                Auth.auth().createUser(withEmail: self.mail, password: self.password) { authResult, error in
                                                    if let authResult = authResult {
                                                        print(authResult)
                                                        print(authResult.user.uid + "😏")
                                                        if authResult.user.uid != nil {
                                                            viewModel.adduser(
                                                                usersname: usersname,
                                                                bikename: bikename,
                                                                usercomment: usercomment,
                                                                userid: userid,
                                                                users: (authResult.user.uid)
                                                            )
                                                            viewModel.addattendfirst()
                                                        } else {
                                                            print("UIDがnilです。")
                                                        }
                                                    } else if let error = error {
                                                        print("ユーザーアカウントの作成に失敗しました。エラー: \(error.localizedDescription)")
                                                    }
                                                }
                                            allview = true
                                        }
                                    }, label: {
                                        Text("新規登録").frame(width: 200, height: 50) .foregroundColor(.black)
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
            }
            else if allview == true {
                HomeView()
            }
        }
    }
}

struct Loginview_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
