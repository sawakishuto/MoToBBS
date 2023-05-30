//
//  RecruitView.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/26.
//

import SwiftUI

struct RecruitView: View {
    @State private var selectionDate = Date()
    @Environment(\.presentationMode) var presentation
    @ObservedObject private var viewModel = ViewModel()
    @State var userid:String = ""
    @State var eventid:String = ""
    @State var username:String = ""
    @State private var whereis:String = ""
    @State private var detail:String = ""
    @State private var title:String = ""
    @State private var how:String = ""
    @State private var participants:String = ""
    
    var body: some View{
        
       
        TextField("タイトル",text:$title).textFieldStyle(RoundedBorderTextFieldStyle())
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red,lineWidth: 2))
      
        TextField("募集人数(数字のみ)",text:$how).textFieldStyle(RoundedBorderTextFieldStyle())
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red,lineWidth: 2))
        DatePicker("日時を選択", selection: $selectionDate)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red,lineWidth: 2))
            .frame(height: 30)
        TextField   ("詳細:ツーリングルート,募集条件,問い合わせ先情報（Twitter,Instagram）",text:$detail, axis: .vertical
            )
        .lineLimit(1...7)
        .frame(minHeight: 190)
       
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red,lineWidth: 2))
        TextField("出発地点（集合場所など）", text:$whereis).textFieldStyle(RoundedBorderTextFieldStyle())
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color.red,lineWidth: 2))
      
        
        
        Button(action: {self.viewModel.addDocument(title:title,detail:detail,whereis:whereis,how:how,selectionDate:selectionDate,eventid:eventid,userid:userid,username: username,participants:participants)
            

            self.presentation.wrappedValue.dismiss()
        }, label: {Text("投稿")}).buttonStyle(AnimationButtonStyle())
        
        
    }
    }

struct AnimationButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .padding()
           
            .overlay(RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black))
            .background(configuration.isPressed ? Color.red : Color.white )
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeOut(duration: 0.01), value: configuration.isPressed)
    }
}

struct RecruitView_Previews: PreviewProvider {
    static var previews: some View {
        RecruitView()
    }
}
