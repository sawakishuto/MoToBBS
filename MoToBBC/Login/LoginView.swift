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
                    VStack(spacing: 30){
                        // メールアドレス
                        TextField("メールアドレスを入力してください",text: $mail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red,lineWidth: 2))
                            .padding()
                        // パスワード
                        SecureField("パスワードを入力してください",text:$password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red,lineWidth: 2))
                            .padding()
                      
                        // 認証
                        Button(
                            action:{
                                if(self.mail == ""){
                                    self.errorMessage = "メールアドレスが入力されていません"
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
                                Text("ログイン")
                            })
                        Text("新規登録").onTapGesture {
                        
                            logingo = false
                        }}
                }
                
                else if(logingo == false){
                    VStack(spacing: 30){
                        // メールアドレス
                        
                        TextField("メールアドレスを入力してください",text: $mail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red,lineWidth: 2))
                            .padding()
                        
                        // パスワード
                        SecureField("パスワードを入力してください",text:$password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red,lineWidth: 2))
                            .keyboardType(.numberPad)
                            .padding()
                        TextField("氏名を入力してください",text: $usersname)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red,lineWidth: 2))
                            .padding()
                        TextField("載っているバイクの車種を入力してください",text:$bikename)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red,lineWidth: 2))
                            .padding()
                        TextField("性別(男性、女性、その他)",text: $usercomment)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red,lineWidth: 2))
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
                                Text("新規会員登録")
                            }
                        )
                        Button(action: {logingo = true}, label:{ Text("ログイン")})
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
