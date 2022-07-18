//
//  ReadViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/09.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

class ReadViewController : TabmanViewController {
    //MARK: - Properties
    
    lazy var searchButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonPressed(_:)))
        
        return sb
    }()
    
    let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
    private let categoryTitleList = [ "한식", "중식", "양식", "일식", "간식", "채식", "퓨전", "분식", "안주" ]
    
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "요리가 좋아"
        navigationItem.rightBarButtonItem = searchButton
//        navigationController?.navigationBar.topItem?.title = ""  //back button의 타이틀을 없애기
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customGreen2
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        tabBarController?.tabBar.isHidden = true
        
        navigationItem.backBarButtonItem = backButton
       
    }
    

    
//MARK: - ViewMethod
//MARK: - ButtonMethod
    
    @objc func searchButtonPressed(_ sender : UIBarButtonItem) {
        performSegue(withIdentifier: "ReadToSearch", sender: self)
    }
    
}

//MARK: - Extension
