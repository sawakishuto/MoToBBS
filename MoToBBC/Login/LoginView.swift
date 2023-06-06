import SwiftUI
import FirebaseAuth
struct LoginView: View {
    @ObservedObject private var viewModel = LoginViewModel()
    @State var showsheet = false
    @State public var usersname:String = ""
    @State public var bikename:String = ""
    @State public var usercomment:String = ""
    @State var logingo = true
    @State var eventid:String = ""
    @State var loginshow = false
    @State var allview = false
    @State var userid:String = ""
    @State public var mail:String = ""
    @State public var password:String = ""
    @State public var errorMessage:String = ""
    @State var profile = false
    
    var body: some View {
        if loginshow == false{
            if allview == false{
                if logingo == true{
                    ZStack{
                        LinearGradient(gradient: Gradient(colors: [Color.red,Color(red:0.6,green: 0,blue:0)]), startPoint: .center,endPoint: .bottom)
                            .ignoresSafeArea()
                        // メールアドレス
                        VStack{
                            Text("MoToBBC")
                                .font(.system(size:60))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 100, trailing: 0))
                                
                            TextField(" 　  メールアドレスを入力してください",text: $mail)
                            
                            
                                .frame(height: 60)
                                .textFieldStyle(PlainTextFieldStyle())
                            
                            
                            
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding()
                            // パスワード
                            SecureField("　　パスワードを入力してください",text:$password)
                                .frame(height: 60)
                                .textFieldStyle(PlainTextFieldStyle())
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding()
                            
                            // 認証
                            Button(
                                action:{
                                    if(self.mail == ""){
                                        self.errorMessage = " メールアドレスが入力されていません"
                                    } else if(self.password == ""){
                                        self.errorMessage = "パスワードが入力されていません"
                                    } else {
                                        Auth.auth().signIn(withEmail: self.mail, password: self.password) { authResult, error in
                                            if authResult?.user != nil {
                                                allview = true
                                            }
                                        }
                                    }
                                }, label:{
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
                
                else if(logingo == false){
                    
                    ZStack{
                        LinearGradient(gradient: Gradient(colors: [Color.red,Color(red:0.6,green: 0,blue:0)]), startPoint: .center,endPoint: .bottom)
                            .ignoresSafeArea()
                        ScrollView{
                            VStack(spacing: 30){
                                // メールアドレス
                                
                                TextField("　　メールアドレスを入力してください",text: $mail)
                                    .frame(height: 60)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding()
                                
                                // パスワード
                                SecureField("　　パスワードを入力してください",text:$password)
                                    .frame(height: 60)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .keyboardType(.numberPad)
                                    .padding()
                                TextField("　　氏名を入力してください",text: $usersname)
                                    .frame(height: 60)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding()
                                TextField("　　載っているバイクの車種",text:$bikename)
                                    .frame(height: 60)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding()
                                TextField("　　性別(男、女、その他)",text: $usercomment)
                                    .frame(height: 60)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .background(Color.white)
                                    .cornerRadius(10)
                                
                                    .padding()
                                
                                // 認証
                                Button(
                                    action:{
                                        if(self.mail == ""){
                                            self.errorMessage = "メールアドレスが入力されていません"
                                        } else if(self.password == ""){
                                            self.errorMessage = "パスワードが入力されていません"
                                        } else {
                                            Auth.auth().createUser(withEmail: self.mail, password: self.password) { authResult, error in
                                            }
                                            viewModel.adduser(usersname: usersname, bikename: bikename, usercomment: usercomment,userid: userid)
                                            self.viewModel.addattendfirst(eventid: eventid)
                                            allview = true
                                            
                                        }
                                    }, label:{
                                        Text("新規会員登録").frame(width: 200, height: 50) .foregroundColor(.black)
                                            .fontWeight(.bold)
                                            .background(Color(.white))
                                            .cornerRadius(10)
                                    }
                                )
                                Button(action: {logingo = true}, label:{ Text("ログイン")
                                        .foregroundColor(.white)
                                        .padding(.init(top: 20, leading: 0, bottom: 0, trailing: 0))
                                    
                                })
                            }
                        }
                    }
                    
                }
            }
            else if allview == true{
                HomeView()
            }
        }
        
    }
    }





struct login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
