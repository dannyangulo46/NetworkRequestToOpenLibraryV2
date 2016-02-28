//
//  ISBNTableViewController.swift
//  OpenLibraryRequest
//
//  Created by Lloyd Angulo on 2/22/16.
//  Copyright © 2016 BajaCalApps. All rights reserved.
//

import UIKit

class ISBNTableViewController: UITableViewController {

    var books = [BookInfo]()
    
   // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        books = appDelegate.books
        
        
        tableView.reloadData()
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
 
        cell.textLabel?.text = books[indexPath.row].title

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toDisplayBook" {
        
            let ISBNDVC = segue.destinationViewController as! ISBNDisplayViewController
            
            let ip = tableView.indexPathForSelectedRow
            
            ISBNDVC.ISBN = books[(ip?.row)!].ISBN
            ISBNDVC.bookTitle = books[(ip?.row)!].title
            ISBNDVC.authors = books[(ip?.row)!].authors
            ISBNDVC.imageforBook = books[(ip?.row)!].image
        }
        
    }
 

}
