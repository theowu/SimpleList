//
//  SimpleListItem.swift
//  SimpleList
//
//  Created by Theo WU on 21/07/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import Foundation
import UIKit

class SimpleListItem: NSObject, NSCoding {
    var text: String
    var checkState: Bool
    var dueDate: NSDate
    var shouldRemind: Bool
    var itemID: Int
    
    override var description: String {
        get {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .ShortStyle
            let dueDateText = formatter.stringFromDate(dueDate)
            return "text: \(text), checkState: \(checkState), dueDate: \(dueDateText), shouldRemind: \(shouldRemind), itemID: \(itemID)"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObjectForKey("Text") as! String
        checkState = aDecoder.decodeBoolForKey("CheckState")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        super.init()
    }
    
    convenience init(text: String) {
        self.init(text: text, checkState: false, dueDate: NSDate(), shouldRemind: false, itemID: DataModel.nextSimpleListItemID())
    }
    
    init(text: String, checkState: Bool, dueDate: NSDate, shouldRemind: Bool, itemID: Int) {
        self.text = text
        self.checkState = checkState
        self.dueDate = dueDate
        self.shouldRemind = shouldRemind
        self.itemID = itemID
        super.init()
    }
    
    deinit {
        if let notification = notificationForThisItem() {
//            print("Removing existing notification \(notification)")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
    
    func toggleCheckState() {
        checkState = !checkState
    }
    
    func notificationForThisItem() -> UILocalNotification? {
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        for notification in allNotifications {
            if let number = notification.userInfo?["ItemID"] as? Int where number == itemID {
                return notification
            }
        }
        return nil
    }
    
    func scheduleNotification() {
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
//            print("Found an existing notification \(notification) and cancelling......")
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        
        if shouldRemind && dueDate.compare(NSDate()) != .OrderedAscending {
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": itemID]
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
//            print("Scheduled notification \(localNotification) for itemID \(itemID)")
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checkState, forKey: "CheckState")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemID, forKey: "ItemID")
    }
}

//class SimpleListItem: Equatable {
//    var text = ""
//    var checkState = false
//    
//    init(text: String, checkState: Bool) {
//        self.text = text
//        self.checkState = checkState
//    }
//    
//    func toggleCheckState() {
//        checkState = !checkState
//    }
//}
//
//func == (left: SimpleListItem, right: SimpleListItem) -> Bool {
//    return left.text == right.text && left.checkState == right.checkState
//}