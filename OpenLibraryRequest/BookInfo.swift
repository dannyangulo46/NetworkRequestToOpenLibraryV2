//
//  BookInfo.swift
//  OpenLibraryRequest
//
//  Created by Lloyd Angulo on 2/23/16.
//  Copyright © 2016 BajaCalApps. All rights reserved.
//

import Foundation
import UIKit

struct BookInfo {
    
    let ISBN: String?
    let title: String?
    let authors: String?
    let image: UIImage?
    
    
    init(ISBN: String, title: String, authors: String, image: UIImage? ) {
        
        self.ISBN = ISBN
        self.title = title
        self.authors = authors
        self.image = image
        
    }
    
}