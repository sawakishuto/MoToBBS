//
//  RecruitView.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/26.
//

import SwiftUI
import UIKit
struct RecruitView: View {
    @State private var selectionDate = Date()
    @Environment(\.presentationMode) var presentation
    @ObservedObject private var viewModel = ViewModel()
    @State var usercomment:String = ""
    @State var bikename:String = ""
    @State var documentinfo:String = ""
    @State var userid:String = ""
    @State var eventid:String = ""
    @State var username:String = ""
    @State private var whereis:String = ""
    @State private var detail:String = ""
    @State private var title:String = ""
    @State private var how:String = ""
    @State private var participants:String = ""
    @State private var image:Image?
    @State private var imageui:UIImage?
    @State private var inputImage:UIImage?
    @State private var showingImagePicker = false
    
    func loadImage(){
          guard let inputImage = inputImage else {return}
          image = Image(uiImage: inputImage)
      }
    
    var body: some View{
        
        ScrollView{
            VStack{
              
                Image("recruit").padding(EdgeInsets(top: -150, leading: 0, bottom: 0, trailing: 0))
                Text("※できるだけ詳細に記入してください").foregroundColor(.red)
                    .fontWeight(.bold)
                TextField("タイトル",text:$title)
                    .frame(height: 40).textFieldStyle(PlainTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red,lineWidth: 2))
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                TextField("募集人数(数字のみ)",text:$how)
                    .frame(height: 40).textFieldStyle(PlainTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red,lineWidth: 2))
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .keyboardType(.numberPad)
                
                DatePicker("日時を選択", selection: $selectionDate)
                    .frame(height: 50)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red,lineWidth: 2))
                    .frame(height: 30)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                TextField   ("詳細:ツーリングルート,募集条件,問い合わせ先情報（Twitter,Instagram）",text:$detail, axis: .vertical
                )
                .lineLimit(1...7)
                .frame(minHeight: 190)
                
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.red,lineWidth: 2))
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                TextField("集合場所", text:$whereis)
                    .frame(height: 40).textFieldStyle(PlainTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red,lineWidth: 2))
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                image?.resizable().scaledToFit()
                Button {
                    showingImagePicker = true
                } label: {
                    Text("写真を選択")
                }.sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }//inputImageの変化を監視して変化があればloadImage
                .onChange(of: inputImage) { newValue in
                    loadImage()
                }
                
                
                
                Button(action: {self.viewModel.addDocument(title:title,detail:detail,whereis:whereis,how:how,selectionDate:selectionDate,eventid:eventid,userid:userid,username: username,participants:participants)
                    self.viewModel.GetUserInfoAndSet2(userid: userid, username: username, usercomment: usercomment, bikename: bikename)
                    
                    
                    
                    self.presentation.wrappedValue.dismiss()
                    // あるイベントIDとImage型の画像を渡してuploadPhotoを実行する
                    self.viewModel.uploadPhotoAfterConversion(eventid: self.eventid, images:self.image)

                }, label: {Text("投稿")}).buttonStyle(AnimationButtonStyle())
                
                
            }.padding(EdgeInsets(top: 150, leading: 0, bottom: 0, trailing: 0))
        }
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
