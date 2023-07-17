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

struct detail: View {
    @State private var userInfoArray: [[String]] = []
    @State var isGood = false
    @State var goodAlert = false
    @State var messa = "参加する！"
    @ObservedObject private var viewModel = ViewModel()
   
    @State  var datamodel = ViewModel().datamodel
    @State var isgo = false
    @State var pp:Int = 0
    @State var uid:String = ""
    @State var documentId = ""
    
    let username:String
    let usercomment:String
    let bikename:String
    let userid:String
    let documentinfo:String
    
    let eventid:String
    let  whereis:String
    let detail:String
    let title:String
    let dateString:String
    let how:String
    
    init(eventid:String,whereis:String,detail:String,title:String,dateStrig:String,how:String,documentinfo:String,
          username:String,
       usercomment:String,
       bikename:String,
          userid:String){
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
        
        ZStack{
            VStack{

                    Spacer()
                    Text(title).font(.title).fontWeight(.bold)
                    Spacer()
                    
                    VStack(alignment:.leading){
                        ScrollView{
                        Text("集合場所：" + whereis).frame(height: 20)
                                 .fontWeight(.bold)
                        Divider().background(Color.red)
                                .fontWeight(.bold)
                        Text("開催予定日：" + dateString)
                            .frame(height: 20)
                            .fontWeight(.bold)
                        Divider().background(Color.red)
                                .fontWeight(.bold)
                        Text("詳細:" + detail)
                    }.padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing:0
                                        ))}
                    Divider().background(Color.red)
                    Text("参加予定者").foregroundColor(.red)
                        .fontWeight(.bold)
                List(userInfoArray, id: \.self) { userInfo in
                    Text("\(userInfo[0])\n車種: \(userInfo[2])\n性別: \(userInfo[1])　")
                    
                } .fontWeight(.bold)
                .listStyle(PlainListStyle()) // リストのスタイルをプレーンに設定
                        .background(Color.white)
                        .frame(height: 150)
                        .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing:0
                                            ))
                
            Spacer()
                
                
                Text(messa)
                    .fontWeight(.bold)
                    .frame(width: 190,height: 60)
                    .background(Capsule().fill(Color.red))                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
                    .padding(EdgeInsets(top: 0, leading: 18, bottom: 20, trailing: 0))
                    .onTapGesture {
               
                        goodAlert = true
                
              

                }
                    .alert(isPresented: $goodAlert, content: {
                        Alert(
                            title: Text("このイベントに参加しますか？"),
                            message: Text(""),
                            primaryButton: .default(Text("はい"),
                                                    action: {isgo = true
                                                        if isgo == true{
                                                            messa = "エントリー完了"
                                                            self.viewModel.addattend(eventid: self.eventid)
                                                            self.viewModel.GetUserInfoAndSet(userid: self.userid, username: self.username, usercomment: self.usercomment, bikename: self.bikename, documentinfo:self.documentinfo )
                                                        }
                                                        
                                                    }),
                            secondaryButton: .destructive(Text("いいえ"),
                                                          action: {isgo = false})
                        )
                        
                    })
               
            }
            
            
        }.onAppear(){
            self.viewModel.fetchUserInfoFromAttendList(documentinfo: self.eventid) { userInfoArray in
                self.userInfoArray = userInfoArray
            }
            self.viewModel.fetchData()
            
            
           
          
        }
        }
    }
    

struct detail_Previews: PreviewProvider {
    static var previews: some View {
        detail(eventid: "", whereis: "", detail: "", title: "", dateStrig: "", how: "", documentinfo: "", username: "", usercomment: "", bikename: "", userid: "")}
}
