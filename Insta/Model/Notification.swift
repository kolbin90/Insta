//
//  Notification.swift
//  Insta
//
//  Created by Apple User on 12/3/19.
//  Copyright © 2019 Apple User. All rights reserved.
//

import Foundation

class NotificationModel{
    var from: String?
    var type: String?
    var objectId: String?
    var timestamp: Int?
    var id: String?
}

extension NotificationModel {
    static func transformToUser(dict: [String:Any], key: String) -> NotificationModel {
        let notification = NotificationModel()
        
        notification.from = dict["from"] as? String
        notification.type = dict["type"] as? String
        notification.objectId = dict["objectId"] as? String
        notification.timestamp = dict["timestamp"] as? Int
        notification.id = key
        
        return notification
    }
}
