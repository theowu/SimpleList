//
//  AllListsViewController.swift
//  SimpleList
//
//  Created by Theo WU on 30/07/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    var dataModel: DataModel!
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedSimpleList
        if index >= 0 && index < dataModel.lists.count {
            let simpleList = dataModel.lists[index]
            performSegueWithIdentifier("ShowSimpleList", sender: simpleList)
        }
    }
    
    //navigationController delegate method
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController === self {
            //the number of unchecked items may change which will result in different detail textLabel text, this is a perfect place to reconfigure the Subtitle for the cell for the row selected since we keep track of the index of this row by using indexOfSelectedSimpleList
            let simpleList = dataModel.lists[dataModel.indexOfSelectedSimpleList]
            let indexPath = NSIndexPath(forRow: dataModel.indexOfSelectedSimpleList, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureSubtitleForCell(cell, simpleList: simpleList)
            }
            
            dataModel.indexOfSelectedSimpleList = -1
        }
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = cellForTableView(tableView, withReuseIdentifier: "SimpleListCell")
        let simpleList = dataModel.lists[indexPath.row]
        configureTextForCell(cell, simpleList: simpleList)
        configureSubtitleForCell(cell, simpleList: simpleList)
        configureImageForCell(cell, simpleList: simpleList)
        cell.accessoryType = .DetailDisclosureButton
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let simpleList = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowSimpleList", sender: simpleList)
        // 记忆进入了哪个simpleList界面
        dataModel.indexOfSelectedSimpleList = indexPath.row
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        
        let simpleList = dataModel.lists[indexPath.row]
        controller.simpleListToEdit = simpleList
        
        presentViewController(navigationController, animated: true, completion: nil)
    }

    //utility method
    func cellForTableView(tableView: UITableView, withReuseIdentifier reuseIdentifier: String) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        }
    }
    
    func configureTextForCell(cell: UITableViewCell, simpleList: SimpleList) {
        cell.textLabel!.text = simpleList.name
    }
    
    func configureImageForCell(cell: UITableViewCell, simpleList: SimpleList) {
        cell.imageView!.image = UIImage(named: simpleList.iconName)
    }
    
    func configureSubtitleForCell(cell: UITableViewCell, simpleList: SimpleList) {
        guard let numberOfUnCheckedItems = simpleList.countUncheckedItems() else {
            cell.detailTextLabel!.text = "(No Item)"
            return
        }
        if numberOfUnCheckedItems == 0 {
            cell.detailTextLabel!.text = "All Done!"
        } else {
            cell.detailTextLabel!.text = "\(numberOfUnCheckedItems) Remaining"
        }
    }
    
    
    //prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSimpleList" {
            let controller = segue.destinationViewController as! SimpleListViewController
            controller.simpleList = sender as! SimpleList
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    //ListDetailViewController delegate methods
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewControllerDidEndAddingList(controller: ListDetailViewController, simpleList: SimpleList) {
        dataModel.lists.append(simpleList)
        dataModel.sortSimpleList()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewControllerDidEndEditingList(controller: ListDetailViewController, simpleList: SimpleList) {
        dataModel.sortSimpleList()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
}
