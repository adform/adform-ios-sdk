//
//  ViewController.swift
//  sample
//
//  Created by Laurynas Letkauskas on 2021-02-25.
//

import UIKit
import AdformAdvertising

class PlacementsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AdhesionTop" {
            (segue.destination as? AdhesionViewController)?.adPosition = .top
        } else if segue.identifier == "AdhesionBottom" {
            (segue.destination as? AdhesionViewController)?.adPosition = .bottom
        }
    }

}

