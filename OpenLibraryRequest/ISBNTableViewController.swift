//
//  ISBNTableViewController.swift
//  OpenLibraryRequest
//
//  Created by Lloyd Angulo on 2/22/16.
//  Copyright © 2016 BajaCalApps. All rights reserved.
//

import UIKit
import CoreData

class ISBNTableViewController: UITableViewController {

    var books = [BookInfo]()

    var tracker: Int = 0
    var tracker2: Int = 0
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
   // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tracker++
        print("viewDidLoad Tracker: \(tracker)")
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let entityBookTable = NSEntityDescription.entityForName("BookTable", inManagedObjectContext: managedObjectContext!)
        let request = entityBookTable?.managedObjectModel.fetchRequestTemplateForName("requestBookTable")
    
        do {
            let entityBooks = try managedObjectContext?.executeFetchRequest(request!)
            
            for entityBook in entityBooks! {
                let isbn = entityBook.valueForKey("isbn") as! String
                let title = entityBook.valueForKey("title") as! String
                let author = entityBook.valueForKey("author") as! String
                let image = UIImage(data: entityBook.valueForKey("image") as! NSData)
                
                let newBook = BookInfo(ISBN: isbn, title: title, authors: author, image: image)
                
                (UIApplication.sharedApplication().delegate as! AppDelegate).books.append(newBook)
                
            }
        } catch {}
    
    
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tracker2++
        print("viewWillAppear: \(tracker2)")
        
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
