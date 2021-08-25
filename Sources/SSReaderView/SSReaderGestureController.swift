//
//  SSReaderGestureController.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/10.
//

import UIKit



class SSReaderGestureController: UIViewController {
    var topToolView: UIView?
    var bottomToolView: UIView?
    init(topToolView: UIView?, bottomToolView: UIView?) {
        self.topToolView = topToolView
        self.bottomToolView = bottomToolView
        super.init(nibName: nil, bundle: nil)
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
