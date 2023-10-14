import SwiftUI
import FirebaseAuth
// swiftlint:disable line_length
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
    @State private var male: Bool = false
    @State private var female: Bool = false
    @State private var andSoOn: Bool = false
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
                                .background(errorhandle ? Color(red: 0.8, green: 0.8, blue: 0.8): Color.white)
                                .cornerRadius(10)
                                .padding()
                            // パスワード
                            SecureField(passname, text: $password)
                                .frame(height: 60)
                                .textFieldStyle(PlainTextFieldStyle())
                                .background(errorhandle ? Color(red: 0.8, green: 0.8, blue: 0.8): Color.white)
                                .cornerRadius(10)
                                .padding()
                            // 認証
                            Button(
                                action: {
                                    if self.mail.isEmpty {
                                        mail = ""
                                        password = ""
                                        self.mailname = " メールアドレスが入力されていません"
                                    } else if self.password.isEmpty {
                                        self.passname = " パスワードが入力されていません"
                                        mail = ""
                                        password = ""
                                    } else {
                                        Auth.auth().signIn(withEmail: self.mail, password: self.password) { authResult, error in
                                            if authResult?.user != nil {
                                                allview = true
                                            } else {
                                                errorhandle = true
                                                mailname = "　メールアドレスまたはパスワードが違います"
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

                                    TextField(mailname, text: $mail)
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
                                    SecureField(passname, text: $password)
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
                                Button(
                                    action: {
                                        if self.mail.isEmpty {
                                            self.mailname = " メールアドレスが未入力です。"
                                        } else if self.password.isEmpty {
                                            self.passname = " パスワードが入力されていません"
                                        } else if(self.showconfine != true) {
                                            errorMessage = "利用規約に同意していません"} else if self.password.count < 6{
                                                    passname = "パスワードが６桁未満です"
                                                password = ""
                                                }
                                        else {
                                            Auth.auth().createUser(withEmail: self.mail, password: self.password) { authResult, error in
                                                mail = "エラー"
                                                viewModel.adduser(
                                                    usersname: usersname,
                                                    bikename: bikename,
                                                    usercomment: usercomment,
                                                    users: authResult?.user.uid
                                                )

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
