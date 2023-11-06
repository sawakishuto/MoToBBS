//
//  File.swift
//  MoToBBC
//
//  Created by 澤木柊斗 on 2023/04/28.
//

import Foundation

struct User: Identifiable {
    let id: String = UUID().uuidString
    let userid: String
    let username: String
    let usercomment: String
    let bikename: String
}

struct Item: Codable, Identifiable {
    var id: String?
    var strings: [String]
}

struct Events: Identifiable {
    let id: String = UUID().uuidString
    let eventid: String
    let userid: String
    let title: String
    let  whereis: String
    let dateEvent: Date
    let endTime: Date
    let participants: String
    let detail: String
    let how: String
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日　H時m分"
        return formatter.string(from: dateEvent)
    }
    var endTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日　H時m分"
        return formatter.string(from: endTime)
    }
}
struct Usersinfo: Identifiable {
    let id: String = UUID().uuidString
    let eventid: String
    let userid: String
    let title: String
    let  whereis: String
    let dateEvent: Date
    let endTime: Date
    let participants: String
    let detail: String
    let how: String
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日　H時m分"
        return formatter.string(from: dateEvent)
    }
    var endTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日　H時m分"
        return formatter.string(from: endTime)
    }
}
struct AttendEvents {
    let eventid: String
    let userid: String
}
struct Datamodel: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var how: String
    var whereis: String
    var detail: String
    var dateEvent: Date
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月d日　H時m分"
        return formatter.string(from: dateEvent)
    }
}
struct Eventidmodel: Identifiable {
    var id: String = UUID().uuidString
    var eventid: String
}
