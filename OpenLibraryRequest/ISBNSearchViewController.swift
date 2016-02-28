//
//  ISBNSearchViewController.swift
//  OpenLibraryRequest
//
//  Created by Lloyd Angulo on 2/23/16.
//  Copyright © 2016 BajaCalApps. All rights reserved.
//

import UIKit

class ISBNSearchViewController: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var textToSearh: UITextField!
    
    @IBOutlet weak var lblMessageToUser: UILabel!
    
    @IBOutlet weak var imageViewBookPicture: UIImageView!
    
    @IBOutlet weak var lblDisplayTitle: UILabel!
    
    @IBOutlet weak var lblDisplayAuthor: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewBookPicture.contentMode = .ScaleAspectFit
    }

    // Mark: - TEXTFIELD DELEGATES
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        lblMessageToUser.text = ""
        lblDisplayTitle.text = ""
        lblDisplayAuthor.text = ""
        imageViewBookPicture.image = nil
        
        
        
        if (textField.text?.characters.count<13) { // Check if the ISBN as 13 numbers
            lblMessageToUser.text = "Al ISBN le faltan mas numeros, deben de ser 13"
            
        } else {
            asyncNetworkRequest(addDashesToISBN(textField.text!))
        }
        
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string.characters.count == 0 {
            return true
        }
        
        let currentText = textField.text ?? ""
        
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if prospectiveText.containsOnlyCharactersIn("0123456789") && prospectiveText.characters.count < 14 {
            
            return true
        }
        
        
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    
    // Mark: - HELPER FUNCTIONS
    
    // 9780060833459 The effective executive, Peter Drucker
    // 9780517549780
    // 9788437604947  Gabriel Garcia Marquez
    
    
    func asyncNetworkRequest(isbn: String) {
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn
        
        
        let url = NSURL(string: urls)
        let session = NSURLSession.sharedSession()
        
        
        let block = { (data: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
            
            guard (error == nil) else {
                self.showError()
                return
            }
            
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)
                
                let dic1 = json as! NSDictionary
                let isbn1 = "ISBN:"+isbn
                
                guard let dic2 = dic1[isbn1] as! [String:AnyObject]! else {
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.lblMessageToUser.text = "El numero ISBN es invalido"
                    }
                    
                    return
                }
                
                let title = dic2["title"] as! String?
                
                self.updateTitle(title!)
                
                let authors = dic2["authors"] as! [[String:AnyObject]]
                
                
                // Extract Author's names
                var i = 0
                var allAuthors:String?
                for author in authors {
                    
                    i++
                    let authorName = author["name"] as! String
                    
                    if i==1 {
                        allAuthors = authorName
                        
                    } else {
                        
                        allAuthors = allAuthors! + "; " + authorName
                    }
                    print(allAuthors)
                }
                
                //Update UI with Authors names
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.lblDisplayAuthor.text = allAuthors
                    
                }
                
              
                
                
                guard let imageDic = dic2["cover"] as? NSDictionary else {
                    print("Book does not have an image")
                    let newBook = BookInfo(ISBN: isbn, title: title!, authors: allAuthors!, image: nil)
                    self.addBookToDataModel(newBook)
                    return
                }
                
                
                guard let imageURLString = imageDic["large"] as? String else {
                    print("Book does not have a large image")
                    let newBook = BookInfo(ISBN: isbn, title: title!, authors: allAuthors!, image: nil)
                    self.addBookToDataModel(newBook)
                    return
                }
                
                
                
                let imageURL: NSURL = NSURL(string: imageURLString)!
                let imageData: NSData? = NSData(contentsOfURL: imageURL)
                
                
                if imageData != nil {
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.imageViewBookPicture.image = UIImage(data: imageData!)
                        
                    }
                }
                
                // Add book information to Data Model
                
                if title != nil {
                    let newBook = BookInfo(ISBN: isbn, title: title!, authors: allAuthors!, image: UIImage(data: imageData!))
                
                    self.addBookToDataModel(newBook)
                }
                
            }
            catch _ {
                
            }
            
            
            // let text = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            
        }
        
        let dt = session.dataTaskWithURL(url!, completionHandler: block)
        dt.resume()
        
    }
    
    //Helper Functions
    
    func addBookToDataModel(newBook: BookInfo){
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).books.append(newBook)
        
    }
    
    
    
    func addDashesToISBN(ISBN: String) -> String{
        
        var myISBN = ISBN
        
        let index1 = myISBN.startIndex.advancedBy(12)
        let index2 = myISBN.startIndex.advancedBy(8)
        let index3 = myISBN.startIndex.advancedBy(5)
        let index4 = myISBN.startIndex.advancedBy(3)
        
        
        myISBN.insert("-", atIndex: index1)
        myISBN.insert("-", atIndex: index2)
        myISBN.insert("-", atIndex: index3)
        myISBN.insert("-", atIndex: index4)
        
        
        return myISBN
    }
    
    func showError() {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let ac = UIAlertController(title: "No hubo respuesta del servidor", message: "Verifica tu conexion de internet", preferredStyle: .Alert)
            
            ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            self.presentViewController(ac, animated: true, completion: nil)
            
        }
    }
    
    func updateTitle(titleName: String) {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.lblDisplayTitle.text = titleName
            
        })
    }
    
    
    
    @IBAction func onDone(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
}

extension String {
    
    
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersInString: matchCharacters).invertedSet
        return self.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
    }

}









