//
//  MyPageController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/10.
//


import UIKit
import SnapKit

class MyPageViewController : UIViewController {
    
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewChange()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyPageCell.self, forCellReuseIdentifier: MyPageCell.cellID)
        
    }
    
    func viewChange() {
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets).inset(50)
            make.left.right.equalTo(view).inset(0)
            make.height.equalTo(750)
        }
        
    }
    
}

    //MARK: - TableView Data Source
extension MyPageViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 0
        }else if section == 1 {
            
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyPageCell.cellID, for: indexPath) as! MyPageCell
        
        return cell
    }
    
}

extension MyPageViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = MyPageHeaderView()
        
        
        return header
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
}

    
    //MARK: - TableView Delegate

//MARK: - CustomCellClass
class MyPageCell : UITableViewCell {
    
    static let cellID = "CustomTableCell"
    
    let tableArray = ["찜 목록", "작성한 글"]
    let tableArray2 = ["공지사항", "로그아웃"]
    
}

//MARK: = CustomHeaderView
class MyPageHeaderView : UIView {
    
    let imageView = UIImageView()
    let idLabel = UILabel()
    let nameLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewInit() {
        
    }
    
}


