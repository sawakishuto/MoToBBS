//
//  profileset.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/06/09.
//

import SwiftUI

struct profileset: View {
    @Environment(\.presentationMode) var presentation
    @State public var  username:String = ""
   @State public var bikename:String = ""
    @ObservedObject private var viewModel = ViewModel()
    init(username: String, bikename: String) {
        self.username = username
        self.bikename = bikename
      
    }
    var body: some View {
        ZStack{
           
            VStack{
          Image("setting")
                TextField("　　変更車種",text:$bikename)
                    .frame(width: 370, height: 60).textFieldStyle(PlainTextFieldStyle())
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red,lineWidth: 5))
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                Button(action: {self.viewModel.profileset( bikename: bikename)
                    self.presentation.wrappedValue.dismiss()
                }, label:{ Text("変更"
                ).font(.system(size: 25))
                .frame(width: 120, height: 50)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.red,lineWidth: 2))
                      
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .background(Color.red)
                        .cornerRadius(10)
                       
                
                })
                
            }
        }
    }
}

struct profileset_Previews: PreviewProvider {
    static var previews: some View {
        profileset(username: "", bikename: "")
    }
}
