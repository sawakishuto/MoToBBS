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
    let id:String
   
    let  whereis:String
    let detail:String
    let title:String
    let dateString:String
    let how:String
    init(whereis:String,detail:String,title:String,dateStrig:String,how:String,id:String){
        
        self.whereis = whereis
        self.detail = detail
        self.title = title
        self.dateString = dateStrig
        self.how = how
        self.id = id
    }
  
    var body: some View {
        
        VStack{
            Spacer()
                Text(title).font(.title).fontWeight(.bold)
            Spacer()
            
            HStack{
                Text("出発地：" + whereis)}
            Text("開催予定日：" + dateString)
            
            
            Text("現在の参加予定" + String(pp) + "人").foregroundColor(.green)
            Spacer(minLength: 30)
            Text(detail)
            
            Text(messa).onTapGesture {
                
//                self.viewModel.addDocument2(pp:pp,documentId:documentId)
                self.isgo.toggle()
                if isgo == true{
                   messa = "参加した！"

                }
            }
        }.onAppear(){self.viewModel.fetchData()
           
          
        }
        }
    }
    

struct detail_Previews: PreviewProvider {
    static var previews: some View {
        detail(whereis: "三重県",detail:"dfdf", title:"誰でもツーリング", dateStrig:"2004年12月24日", how: "11",id:"")}
}
