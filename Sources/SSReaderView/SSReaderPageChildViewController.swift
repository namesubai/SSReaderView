//
//  SSReaderPageChildViewController.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/9.
//

import UIKit

class SSReaderPageChildViewController: UIViewController {
    var contentView: UIView?
    init(contentView: UIView?) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = contentView ?? nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
