//
//  CustomElementViewController.swift
//  TVMLCatalog
//
//  Created by Jason Newell on 6/6/16.
//  Copyright © 2016 appletv. All rights reserved.
//

import UIKit

class CustomElementViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Custom view loaded")
        
        let label = UILabel(frame: CGRectMake(0, 0, 1000, 1000))
        label.text = "Hey, it worked"
            
        self.view.addSubview(label)
    }
}
