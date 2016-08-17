//
//  DataModel.swift
//  SimpleList
//
//  Created by Theo WU on 30/07/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [SimpleList]()
    var indexOfSelectedSimpleList: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("IndexOfSelectedList")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "IndexOfSelectedList")
//            A quick call to synchronize was all that was needed to ensure data was written immediately to NSUserDefaults. It seems that in Yosemite/iOS 8, this call to synchronize is no longer necessary
//            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    init() {
        loadSimpleLists()
        //如果UserDefaults没有被设置过，那么此方法会给设定初始值
        registerDefaults()
        handleFirstTime()
    }
    
    // dataFilePath
    func dataFilePath() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        return documentDirectory.stringByAppendingPathComponent("SimpleLists.plist")
    }
    
    //save items
    func saveSimpleLists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "SimpleLists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    //load items
    func loadSimpleLists() {
        let path = dataFilePath()
//        print(dataFilePath())
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("SimpleLists") as! [SimpleList]
                unarchiver.finishDecoding()
                sortSimpleList()
            }
        }
    }
    
    //the first run experience
    func registerDefaults() {
        let dictionary = ["IndexOfSelectedList": -1, "FirstTime": true, "SimpleListItemID": 0]
//        If there is no registration domain, one is created using the specified dictionary, and NSRegistrationDomain is added to the end of the search list.
//        The contents of the registration domain are not written to disk; you need to call this method each time your application starts. You can place a plist file in the application's Resources directory and call registerDefaults: with the contents that you read in from that file.
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            let simpleList = SimpleList(name: "New List")
            lists.append(simpleList)
            indexOfSelectedSimpleList = 0
            userDefaults.setBool(false, forKey: "FirstTime")
//            It seems that in Yosemite/iOS 8, this call to synchronize is no longer necessary
//            userDefaults.synchronize()
        }
    }
    
    // alphabetical sort method
    func sortSimpleList() {
        lists.sortInPlace({ simpleList1, simpleList2 in return
            simpleList1.name.localizedCompare(simpleList2.name) == .OrderedAscending })
    }
    
    //call this method to give the new SimpleListItem object a unique ID
    class func nextSimpleListItemID() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("SimpleListItemID")
        userDefaults.setInteger(itemID + 1, forKey: "SimpleListItemID")
        return itemID
    }
}