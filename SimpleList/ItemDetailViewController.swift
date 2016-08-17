//
//  ItemDetailViewController.swift
//  SimpleList
//
//  Created by Theo WU on 23/07/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller:ItemDetailViewController)
    func itemDetailViewController(controller:ItemDetailViewController, didFinishAddingItem item: SimpleListItem)
    func itemDetailViewController(controller:ItemDetailViewController,didFinishEditingItem item: SimpleListItem, withIndex index: Int)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var itemToEdit: SimpleListItem?
    var indexOfItemToEdit: Int?
    var dueDate = NSDate()

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
            if item.notificationForThisItem() != nil {
                shouldRemindSwitch.on = item.shouldRemind
            }
            dueDate = item.dueDate
            datePicker.setDate(dueDate, animated: false)
        }
        
        updateDueDateLabel()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        if newText.length > 0 {
            doneBarButton.enabled = true
        } else {
            doneBarButton.enabled = false
        }
        return true
    }
    
    @IBAction func cancel(){
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
//            print(item)
            delegate?.itemDetailViewController(self, didFinishEditingItem: item, withIndex: indexOfItemToEdit!)
        } else {
            let item =
                SimpleListItem(text: textField.text!, checkState: false, dueDate: dueDate, shouldRemind: shouldRemindSwitch.on, itemID: DataModel.nextSimpleListItemID())
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
    }
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    
    @IBAction func switchValueChanged(sender: UISwitch) {
        textField.resignFirstResponder()
        
        if shouldRemindSwitch.on {
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            
            showDatePicker()
        } else {
            hideDatePicker()
        }
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        if indexPath.section == 1 && indexPath.row == 2 {
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && shouldRemindSwitch.on {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        if indexPath.section == 1 && indexPath.row == 1 {
//            return indexPath
//        } else {
//            return nil
//        }
        return nil
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.section == 1 && indexPath.row == 1 {
//            showDatePicker()
//        }
//    }
    
    func updateDueDateLabel() {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dueDateLabel.text = formatter.stringFromDate(dueDate)
    }
    
    func showDatePicker() {
        if shouldRemindSwitch.on {
            
            let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
            let indexPathDataPicker = NSIndexPath(forRow: 2, inSection: 1)
            
            if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
                dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
            }
            
//            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([indexPathDataPicker], withRowAnimation: .Fade)
//            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
//            tableView.endUpdates()
            
            datePicker.setDate(dueDate, animated: false)
        }
    }
    
    func hideDatePicker() {
        if !shouldRemindSwitch.on {
            
            let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
            let indexPath = NSIndexPath(forRow: 2, inSection: 1)
            
            if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
                dateCell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}