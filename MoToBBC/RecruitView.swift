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
    @State private var whereis:String = ""
    @State private var detail:String = ""
    @State private var title:String = ""
    @State private var how:String = ""
    
    var body: some View{
        
       
        TextField("タイトル",text:$title).textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("詳細",text:$detail).textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("開催地（大体）", text:$whereis).textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("募集人数",text:$how).textFieldStyle(RoundedBorderTextFieldStyle())
        DatePicker("日時を選択", selection: $selectionDate)
        
        
        
        Button(action: {self.viewModel.addDocumentprofile(userid:userid,eventid:eventid,title: title, detail: detail, whereis: whereis, how: how, selectionDate:selectionDate)
            self.presentation.wrappedValue.dismiss()
        }, label: {Text("投稿")})
        
        
    }
    }

struct RecruitView_Previews: PreviewProvider {
    static var previews: some View {
        RecruitView()
    }
}
