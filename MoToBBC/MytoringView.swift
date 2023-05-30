//
//  MytoringView.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/05/16.
//



import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseAuth

struct MytoringView: View {
    
    @State var messa = "ツーリング終了！"
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
        
        VStack{
                Text(title).font(.title).fontWeight(.bold)
            Spacer()
            
                Text("出発地:" + whereis)
            Divider().background(Color.red)
            Text("開催予定日:" + dateString)
   
            Divider().background(Color.red)
            Text("現在の参加予定:" + String(pp) + "人").foregroundColor(.green)
            Divider().background(Color.red)
            Text("詳細:" + detail)
           
            
            Text(messa)
                .frame(width: 190,height: 60)
                .background(Capsule().fill(Color.gray))                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
                .onTapGesture {
                self.viewModel.deleteDocument()
                                self.isgo.toggle()
                if isgo == true{
                   self.viewModel.getUser()
                   messa = "お疲れ様でした！"
                    
                }
            }
        }.onAppear(){
            self.viewModel.getUser()
            
           
          
        }
        }
    }
    

struct MytoringView_Previews: PreviewProvider {
    static var previews: some View {
       MytoringView(eventid: "現在募集中のツーリングはありません", whereis: "1", detail: "", title: "", dateStrig: "", how: "")
    }
}
