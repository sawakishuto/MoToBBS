//
//  Row.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/20.
//

import SwiftUI
import UIKit
import FirebaseStorage
// swiftlint:disable line_length
struct DisplayContents {
    let eventid: String
    let  whereis: String
    let detail: String
    let title: String
    let dateString: String
    let how: String
    var getimages: UIImage?
}
struct RowView: View {
    @State  var image: UIImage? = nil
    @ObservedObject private var viewModel = ViewModel()
    var contents: DisplayContents
    var body: some View {
        VStack {
            ZStack {
                Spacer()
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 140, trailing: 0))

                } else {
                    Text("画像読み込み中")
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 200, trailing: 0))
                        }
                Text(contents.title)
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(.white)
                    .cornerRadius(10)
                    .fontWeight(.bold)
                    .zIndex(200)
                    .padding(EdgeInsets(top: 100, leading: 0, bottom: 140, trailing: 0))

                Spacer()
                VStack {
                    Text("出発地点:" + contents.whereis)
                        .fontWeight(.bold)
                    Divider().background(Color.red)
                    Text("開催日時:" + contents.dateString + "頃")
                        .fontWeight(.bold)
                    Divider()
                        .background(Color.red)
                    Text(contents.detail)
                        .frame(width: 310, height: 50)
                }
                .frame(width: 333.5, height: 150)
                .padding(EdgeInsets(top: 35, leading: 9, bottom: 10, trailing: 10))
                .zIndex(10)
                .background(.white)
                .cornerRadius(20)
                .padding(EdgeInsets(top: 138, leading: 0, bottom: 0, trailing: 0))
                .shadow(color: .gray, radius: 15)
            }
        }
        .onAppear {
            self.viewModel.getImage(eventid: contents.eventid) { image in
                if let image = image {
                    // 取得した画像をStateにセットしてUIに反映する
                    self.image = image
                } else {
                    print("画像の取得に失敗しました")
                }
            }
        }
        .frame(width: 320, height: 300)
            .padding()
            .background(.white)
            .cornerRadius(20)
            .clipped()
            .shadow(color: .black.opacity(0.8), radius: 10)
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.red, lineWidth: 4))}
}
struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(contents: DisplayContents(eventid: "",
                                          whereis: "",
                                          detail: "",
                                          title: "",
                                          dateString: "",
                                          how: ""))
    }
}
