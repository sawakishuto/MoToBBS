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
            Text(title).font(.title)
            
        
            HStack{  Text(whereis)
                Text(dateString)
                
                
                Text(how + "人程度")  }
            Text(detail)
        }.frame(width:300,height:200)
            .padding()
            .background(.white)
            .cornerRadius(18)
            .clipped()
            .shadow(color: .gray.opacity(0.7), radius: 10)
        
    }
}

struct row_Previews: PreviewProvider {
    static var previews: some View {
        row( whereis: "三重県桑名市", detail: "今日は誰でも歓迎です", title: "誰でもツーリング",dateStrig:"Date()", how: "11")
    }
}

