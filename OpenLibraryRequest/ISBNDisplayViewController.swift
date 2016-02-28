//
//  ViewController.swift
//  OpenLibraryRequest
//
//  Created by Lloyd Angulo on 2/21/16.
//  Copyright © 2016 BajaCalApps. All rights reserved.
//

import UIKit

class ISBNDisplayViewController: UIViewController {

    var ISBN: String?
    var bookTitle: String?
    var authors: String?
    var imageforBook: UIImage?
    
    @IBOutlet weak var lblISBN: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblAuthors: UILabel!
    
    @IBOutlet weak var imgBook: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        lblISBN.text = ISBN
        lblTitle.text = bookTitle
        lblAuthors.text = authors
        imgBook.image = imageforBook
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

