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
            Spacer()
                Text(title).font(.title).fontWeight(.bold)
            Spacer()
            
            HStack{
                Text("出発地：" + whereis)}
            Text("開催予定日：" + dateString)
            Text(eventid)
            
            Text("現在の参加予定" + String(pp) + "人").foregroundColor(.green)
            Spacer()
           
            Text(String(eventid))
            Text(messa).onTapGesture {
                self.viewModel.deleteDocument()
                
                self.isgo.toggle()
                if isgo == true{
                   messa = "参加した！"

                }
            }
        }.onAppear(){self.viewModel.fetchData()
            
           
          
        }
        }
    }
    

struct MytoringView_Previews: PreviewProvider {
    static var previews: some View {
       MytoringView(eventid: "", whereis: "", detail: "", title: "", dateStrig: "", how: "")
    }
}
