//
//  ListDetailViewController.swift
//  SimpleList
//
//  Created by Theo WU on 30/07/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    func listDetailViewControllerDidEndAddingList(controller: ListDetailViewController, simpleList: SimpleList)
    func listDetailViewControllerDidEndEditingList(controller: ListDetailViewController, simpleList: SimpleList)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var simpleListToEdit: SimpleList?
    var iconName = "Folder"
    
    //automatically bring up the keyboard when switch to this view
    override func viewWillAppear(animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    //change interface title according to functionality: add or edit
    override func viewDidLoad() {
        if let simpleList = simpleListToEdit {
            title = "Edit SimpleList"
            textField.text = simpleList.name
            doneBarButton.enabled = true
            iconName = simpleList.iconName
        }
        
        iconImageView.image = UIImage(named: iconName)
    }
    
    //prevent from selecting tableView cell
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    //doneBarButton eneable logic
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = newText.length > 0
        return true
    }
    
    @IBAction func done() {
        if let simpleList = simpleListToEdit {
            simpleList.name = textField.text!
            simpleList.iconName = iconName
            delegate?.listDetailViewControllerDidEndEditingList(self, simpleList: simpleList)
        } else {
            let simpleList = SimpleList(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewControllerDidEndAddingList(self, simpleList: simpleList)
        }
    }
    
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    //IconPickerViewController delegate method
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
//        dismiss 是把所有上层的view全部干掉 pop 是把最上层的干掉
        navigationController?.popViewControllerAnimated(true)
    }
    
    //prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destinationViewController as! IconPickerViewController
            controller.delegate = self
        }
    }
}
