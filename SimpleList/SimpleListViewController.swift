//
//  ViewController.swift
//  SimpleList
//
//  Created by Theo WU on 20/07/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import UIKit

class SimpleListViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var simpleList: SimpleList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = simpleList.name
    }
    
    @IBAction func sortByDueDate() {
        simpleList.sortSimpleListItemsByDueDate()
        tableView.reloadData()
    }
    
    //tableView 代理方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simpleList.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SimpleListItem", forIndexPath: indexPath)
        let item = simpleList.items[indexPath.row]
        configureTextForCell(cell, withSimpleListItem: item)
        configureCheckmarkForCell(cell, withSimpleListItem: item)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let item = simpleList.items[indexPath.row]
            item.toggleCheckState()
            configureCheckmarkForCell(cell, withSimpleListItem: item)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        simpleList.items.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    
    //工具方法
    func configureCheckmarkForCell(cell: UITableViewCell, withSimpleListItem item: SimpleListItem) {
        let label = cell.viewWithTag(2000) as! UILabel
        if item.checkState {
            label.text = "✅"
        } else {
            label.text = ""
        }
    }
    
    func configureTextForCell(cell: UITableViewCell, withSimpleListItem item: SimpleListItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        let dateLabel = cell.viewWithTag(3000) as! UILabel
        label.text = item.text
        
        if item.notificationForThisItem() != nil {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .ShortStyle
            dateLabel.text = formatter.stringFromDate(item.dueDate)
        } else {
            dateLabel.text = "(Notification not set)"
        }
//        label.text = "\(item.itemID): \(item.text)"
    }
    
    //itemDetailViewController 代理
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: SimpleListItem) {
        let newRowIndex = simpleList.items.count
        simpleList.items.append(item)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: SimpleListItem, withIndex index: Int) {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            configureTextForCell(cell, withSimpleListItem: item)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //利用segue 把SimpleListViewController 设置成 ItemDetailViewController 的代理
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.itemToEdit = simpleList.items[indexPath.row]
                controller.indexOfItemToEdit = indexPath.row
            }
        }
    }
}

