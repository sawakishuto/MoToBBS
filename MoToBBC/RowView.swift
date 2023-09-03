//
//  Row.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/20.
//

import SwiftUI
import UIKit
import FirebaseStorage

struct RowView: View {
    @State  var image: UIImage? = nil
    @ObservedObject private var viewModel = ViewModel()
    let eventid:String
    let  whereis:String
    let detail:String
    let title:String
    let dateString:String
    let how:String
    var getimages:UIImage?
    init(eventid:String,whereis:String,detail:String,title:String,dateStrig:String,how:String,getimages:UIImage?){
        self.eventid = eventid
        self.whereis = whereis
        self.detail = detail
        self.title = title
        self.dateString = dateStrig
        self.how = how
        self.getimages = getimages
    }
    
    
    
    
    var body: some View {
        VStack{
            ZStack{
                Spacer()
                if let image = image {
                    
                    Image(uiImage:image).resizable() .padding(EdgeInsets(top: 0, leading: 0, bottom: 140, trailing: 0))
                }
                else {
                    Text("画像読み込み中").padding(EdgeInsets(top: 0, leading: 0, bottom: 200, trailing: 0))
                        }
                Text(title)
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(.white)
                    .cornerRadius(10)                .fontWeight(.bold)
                    .zIndex(200)
                    .padding(EdgeInsets(top: 100, leading: 0, bottom: 140, trailing:0))
                
                Spacer()
                VStack{
                    Text("出発地点:" + whereis).fontWeight(.bold)
                    
                    Divider().background(Color.red)
                    Text("開催日時:" + dateString + "頃").fontWeight(.bold)
                    Divider().background(Color.red)
                    
                    Text(detail).frame(width: 310,height: 50)
                    
                }.frame(width: 333.5,height: 150)
                
                    .padding(EdgeInsets(top: 35, leading: 9, bottom: 10, trailing: 10))
                    .zIndex(10)
                    .background(.white)
                    .cornerRadius(20)
                    .padding(EdgeInsets(top: 138, leading: 0, bottom: 0, trailing: 0))
                
                    .shadow(color: .gray, radius: 15)
                
            }
        }.onAppear{
            self.viewModel.getImage(eventid:self.eventid) { image in
                if let image = image {
                    // 取得した画像をStateにセットしてUIに反映する
                    self.image = image
                } else {
                    print("画像の取得に失敗しました")
                }
            }
        }
        .frame(width:320,height:300)
            .padding()
            .background(.white)
            .cornerRadius(20)
            .clipped()
            .shadow(color: .black.opacity(0.8), radius: 10)
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.red,lineWidth: 4))
            
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(eventid:"" ,whereis: "三重県桑名市", detail: "今日は誰でも歓迎ですあああああああああああああああああああああああああああああああああああああああああああ", title: "誰でもツーリング",dateStrig:"Date()", how: "11", getimages: UIImage(named: "Image"))
    }
}

