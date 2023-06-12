//
//  Mypageview.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/27.
//

import SwiftUI

struct Mypageview: View {
    @State private var showsheet = false
    @ObservedObject private var viewModel = ViewModel()
    @State var fetchusername:String = ""
    @State var fetchusercomment:String = ""
    @State var fetchbikename:String = ""
    
    
    let userid:String
    let  username:String
    let usercomment:String
    let bikename:String
    let  whereis:String
    let detail:String
    let title:String
    let dateString:String
    let how:String
    init(whereis:String,detail:String,title:String,dateStrig:String,how:String,username:String,usercomment:String,bikename:String,userid:String){
        self.whereis = whereis
        self.detail = detail
        self.title = title
        self.dateString = dateStrig
        self.how = how
        self.username = username
        self.usercomment = usercomment
        self.bikename = bikename
        self.userid = userid
    }
    
    var body: some View {
        ZStack(alignment:.topTrailing){
            VStack{
                
                HStack{
                    
                    VStack(alignment:.leading,spacing:10){
                        Text(fetchusername).font(.system(size:30)).fontWeight(.heavy)
                        HStack{ Text("車種:" + fetchbikename)  .fontWeight(.bold)
                                .font(.system(size:20))
                            Text(fetchusercomment)
                            
                        }
                        .font(.system(size:20))
                        
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                        .foregroundColor(Color(red: 0.8, green: 0
                                               , blue: 0))
                    
                    
                    
                }
                .frame(alignment: .leading)
                
                .frame(width: 500)
                Divider().background(Color.red)
                
                Text(fetchusername + "が募集中")
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                NavigationView{
                    List(viewModel.datamodeluser){datas in
                        NavigationLink(destination:MytoringView(eventid:datas.eventid,whereis: datas.whereis, detail: datas.detail, title: datas.title, dateStrig: datas.dateString, how: datas.how)                               , label: {
                            row(whereis: datas.whereis, detail: datas.detail, title: datas.title, dateStrig:datas.dateString, how: datas.how)
                        })
                    }
                    .padding(EdgeInsets(top: 0, leading: 43, bottom: 0, trailing:-218))
                    .listStyle(PlainListStyle()) // リストのスタイルをプレーンに設定
                    .background(Color.white) // 背景色を透明に設定
                    
                    
                    
                    
                }.navigationTitle(Text("募集中のイベント"))
                
            }
            Button("車種変更")
            {
                       self.showsheet.toggle()
                   }.fontWeight(.bold)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 60))
                   .sheet(isPresented: $showsheet) {
                       profileset(username: fetchusername, bikename: fetchbikename)
                   }
        }
            .onAppear(){
                // ViewController内の適切な位置に以下のコードを配置
                
                self.viewModel.fetchUserinfo() {fetchedUsername, fetchedUsercomment, fetchedBikename in
                    DispatchQueue.main.async {
                        fetchusername = fetchedUsername
                        fetchusercomment = fetchedUsercomment
                        fetchbikename = fetchedBikename                    }
                }
                self.viewModel.getUser()
                print(viewModel.datamodeluser)
            }
            
            
        }
    }



struct Mypageview_Previews: PreviewProvider {
    static var previews: some View {
        Mypageview(whereis: "", detail:"", title: "", dateStrig: "", how: "",username: "",usercomment: "",bikename: "",userid: "")
    }
}
