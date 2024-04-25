//
//  TutorialView.swift
//  MoToBBS
//
//  Created by 澤木柊斗 on 2023/11/12.
//

import SwiftUI
import CoreData

struct TutorialView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: LoginInfo.entity(),
        sortDescriptors: [NSSortDescriptor(key: "haveAccount", ascending: false)],
        animation: .default
    ) var fetchedInfo: FetchedResults<LoginInfo>
    var PageStr: [String] = ["FirstPage", "SecondPage", "ThirdPage", "ForthPage", "FifthPage", "FinalPage"]
    var body: some View {
            SlideView {
                ForEach(0..<PageStr.count) {str in
                    ZStack {
                        Image(PageStr[str])
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .shadow(radius: 10)
                        if str == 5 {
                            Button {
                                toggleHaveAccount()
                            } label: {
                                Text("はじめる")
                                    .font(.system(size: 28))
                                    .fontWeight(.black)
                                    .foregroundStyle(.black)
                                    .padding(15)
                                    .background(.white)
                                    .cornerRadius(25)
                            }
                            .padding(.top, 200)

                        }
                    }
                }
                .padding(.horizontal, 40)
                .transition(.opacity)
            }

        }
    private func toggleHaveAccount() {
        let info = LoginInfo(context: viewContext)
        info.haveAccount = true
        try? viewContext.save()
        print("保存成功")

    }
    }

#Preview {
    TutorialView()
}
