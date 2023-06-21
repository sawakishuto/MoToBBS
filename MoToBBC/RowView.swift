//
//  row.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/20.
//

import SwiftUI

struct row: View {
 
    let  whereis:String
    let detail:String
    let title:String
    let dateString:String
    let how:String
    init(whereis:String,detail:String,title:String,dateStrig:String,how:String){
    
        self.whereis = whereis
        self.detail = detail
        self.title = title
        self.dateString = dateStrig
        self.how = how
    }
    
    
    
    
    var body: some View {
        VStack{
            Spacer()
            Text(title).font(.title)
                .fontWeight(.bold)
            Spacer()
        
            Text("出発地点:" + whereis).fontWeight(.bold)
                    
                Divider().background(Color.red)
            Text("開催日時:" + dateString + "頃").fontWeight(.bold)
            Divider().background(Color.red)
                
                
               
            Text("募集人数:" + how + "人程度")
                .fontWeight(.bold)
            Divider().background(Color.red)
            Text(detail).frame(width: 350,height: 50)
            
        }.frame(width:350,height:300)
            .padding()
            .background(.white)
            .cornerRadius(20)
            .clipped()
            .shadow(color: .gray.opacity(0.7), radius: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 20).stroke(Color.red,lineWidth: 4))
        
    }
}

struct row_Previews: PreviewProvider {
    static var previews: some View {
        row( whereis: "三重県桑名市", detail: "今日は誰でも歓迎ですあああああああああああああああああああああああああああああああああああああああああああ", title: "誰でもツーリング",dateStrig:"Date()", how: "11")
    }
}

