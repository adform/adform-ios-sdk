//
//  DataViewController.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-04-22.
//

import Foundation
import UIKit

class DataViewController: UIViewController {
    var previousIndex = 0
    
    @IBOutlet var dataLabel: UILabel!
    
    var dataObject: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataLabel.text = dataObject
    }
}
