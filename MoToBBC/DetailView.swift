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
    
    @State var messa = "参加する！"
    @ObservedObject private var viewModel = ViewModel()
   
    @State  var datamodel = ViewModel().datamodel
    @State var isgo = false
    @State var pp:Int = 0
    @State var uid:String = ""
    @State var documentId = ""
    
   
    let eventid:String
    let  whereis:String
    let detail:String
    let title:String
    let dateString:String
    let how:String
    
    init(eventid:String,whereis:String,detail:String,title:String,dateStrig:String,how:String){
        self.eventid = eventid
        self.whereis = whereis
        self.detail = detail
        self.title = title
        self.dateString = dateStrig
        self.how = how
     
    }
  
    var body: some View {
        
        ZStack{
            VStack{
                ScrollView{
            Spacer()
                Text(title).font(.title).fontWeight(.bold)
            Spacer()
            
                    VStack(alignment:.leading){
                        Text("出発地：" + whereis).frame(height: 20)
                        Divider().background(Color.red)
                        Text("開催予定日：" + dateString)
                            .frame(height: 20)
                        Divider().background(Color.red)
                        
                        
                        Text("現在の参加予定" + String(pp) + "人")
                            .foregroundColor(.green)
                            .frame(height: 20)
                        Divider().background(Color.red)
                        
                        Text("詳細:" + detail)
                    }.padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing:0
                                        ))
                }
            Spacer()
                Text(messa)
                    .fontWeight(.bold)
                    .frame(width: 190,height: 60)
                    .background(Capsule().fill(Color.gray))                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
                    .padding(EdgeInsets(top: 0, leading: 18, bottom: 20, trailing: 0))
                    .onTapGesture {
                self.viewModel.addattend(eventid: self.eventid)
                
                self.isgo.toggle()
                if isgo == true{
                    messa = "エントリー完了"
                }

                }
            }
        }.onAppear(){self.viewModel.fetchData()
            
           
          
        }
        }
    }
    

struct detail_Previews: PreviewProvider {
    static var previews: some View {
        detail(eventid:"っっっっっl",whereis: "三重県",detail:"dfdf", title:"誰でもツーリング", dateStrig:"2004年12月24日", how: "11")}
}
