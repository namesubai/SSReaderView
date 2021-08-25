//
//  SSChapterListController.swift
//  SSReaderDemo
//
//  Created by yangsq on 2021/8/19.
//

import UIKit
class SSChapterListController: UITableViewController {
    var selectedChapter: ((Int) -> Void)?
    var chapters: [Chapter]
    var currentChapterNum: Int
    init(chapters:[Chapter], currentChapterNum: Int) {
        self.chapters = chapters
        self.currentChapterNum = currentChapterNum
        super.init(style: .plain)
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chapters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")
        cell?.textLabel?.text = self.chapters[indexPath.row].title
        cell?.textLabel?.textColor = indexPath.row == currentChapterNum ? UIColor.red : UIColor.black
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedChapter = selectedChapter {
            selectedChapter(indexPath.row)
        }
    }
    
    func selectedChapter(onTrigger: @escaping (Int) -> Void) {
        self.selectedChapter = onTrigger
    }
}
