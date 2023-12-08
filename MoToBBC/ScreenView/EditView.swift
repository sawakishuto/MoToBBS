//
//  SwiftUIView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/12/08.
//

import SwiftUI

struct EditView: View {
    @State private var selectedPrefecture: Int = 0
    @State private var postAlert:Bool = false
    @State private var selectionDate = Date()
    @Environment(\.presentationMode) var presentation
    @ObservedObject private var viewModel = ViewModels()
    @State var usercomment: String = ""
    @State var bikename: String = ""
    @State var documentinfo: String = ""
    @State var userid: String = ""
    @State var eventid: String = ""
    @State var username: String = ""
    @State private var whereis: String = ""
    @State private var endTime = Date()
    @State private var detail: String = "ルート:\n\n高速の有無:\n\nその他詳細:\n問い合わせ先(メール, X,Instagram):\n"
    @State private var title: String = ""
    @State private var how: String = ""
    @State private var participants: String = ""
    @State private var image: UIImage?
    @State private var imageui: UIImage?
    @State private var inputImage: UIImage?
    @State private var postState: String = "変更"
    @State private var showingImagePicker = false
    let Edittitle: String
    let Editwhereis: String
    let EditHow: String
    let EditDetail: String
    func loadImage() {
        guard inputImage != nil else {return}
    }
    // swiftlint:disable line_length
    var body: some View {
        ScrollView {
            VStack {
                Text("※できるだけ詳細に記入してください")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
                TextField("タイトル", text: $title)
                    .frame(width: 370, height: 40)
                    .textFieldStyle(PlainTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 1))
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                TextField("募集人数(数字のみ)", text: $how)
                    .frame(width: 370, height: 40)
                    .textFieldStyle(PlainTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 1))
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .keyboardType(.numberPad)

                ZStack(alignment: .topLeading) {
                    TextEditor(text: $detail)
                        .frame(width: 370)
                        .frame(height: 190)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 1))
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))

                    if detail.isEmpty {
                        Text("詳細\nルート\n高速道路の有無\n問い合わせ先(X,Instagram)") .foregroundColor(Color(uiColor: .placeholderText))
                            .padding(EdgeInsets(top: 20, leading: 4, bottom: 0, trailing: 0))
                            .allowsHitTesting(false)
                    }
                }

                TextField("集合場所", text: $whereis)
                    .frame(width: 370, height: 40).textFieldStyle(PlainTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 1))
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                Button {
                    showingImagePicker = true
                } label: {
                    VStack {
                        Text("写真を選択")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
                            .background(Color.red)
                            .cornerRadius(30)
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 2, trailing: 0))
                        Text("横向きの写真をお勧めします")
                            .opacity(0.7)
                    }
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }// inputImageの変化を監視して変化があればloadImage
                .onChange(of: inputImage) { newValue in
                    loadImage()
                    print(eventid)
                    //                  imageui =   self.viewModel.convertToUIImage(images: self.image)
                }
                if let inputImage {
                    Image(uiImage: inputImage)
                        .resizable()
                        .scaledToFit()
                }
                Button(action: {postAlert = true}, label: {
                    Text(postState)
                        .foregroundStyle(.white)
                        .font(.system(size: 25))
                        .fontWeight(.black)
                })
                    .padding(EdgeInsets(top: 8, leading: 28, bottom: 8, trailing: 28))
                    .background(.red)
                    .cornerRadius(24)
                    .alert(isPresented: $postAlert, content: {
                        Alert(
                            title: Text("この内容に変更しますか？"),
                            message: Text(""),
                            primaryButton: .destructive(Text("いいえ"),
                                                        action: {}),
                            secondaryButton: .default(Text("はい"),
                                                      action: {
                                                          postState = "変更中"
                                                          if inputImage != nil {
                                                              self.viewModel.UploadImage(inputImage: self.inputImage)
                                                          }
                                                          // 上記の処理が完了した後に次の処理を実行
                                                          DispatchQueue.global().async {
                                                              self.viewModel.addDocument(
                                                                title: "\(title)",
                                                                detail: detail,
                                                                whereis: whereis,
                                                                how: how,
                                                                selectionDate: selectionDate,
                                                                endTime: endTime,
                                                                eventid: eventid,
                                                                userid: userid,
                                                                username: username,
                                                                participants: participants
                                                              )
                                                              // 指定した処理が完了したらメインスレッドでUI更新を行います
                                                              DispatchQueue.main.async {
                                                                  self.presentation.wrappedValue.dismiss()
                                                              }
                                                          }
                                                      }
                                                     )
                        )
                    })
            }
            .padding(EdgeInsets(top: 150, leading: 0, bottom: 0, trailing: 0))
            .frame(maxWidth: .infinity)
        }
        .onAppear {
            DispatchQueue.main.async {
            self.viewModel.getImage(eventid: self.eventid) { image in
                if let image = image {
                    // 取得した画像をStateにセットしてUIに反映する
                    self.inputImage = image
                } else { print("画像の取得に失敗しました") }
            }
}
            self.title = "\(Edittitle)"
            self.whereis = Editwhereis
            self.how = EditHow
            self.detail = EditDetail
        }

    }
}

#Preview {
    EditView(Edittitle: "", Editwhereis: "", EditHow: "", EditDetail: "")
}
