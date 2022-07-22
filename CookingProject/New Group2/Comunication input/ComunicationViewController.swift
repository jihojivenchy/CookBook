//
//  ComunicationViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/15.
//

import UIKit
import SnapKit
import Tabman
import Pageboy

class ComunicationViewController: TabmanViewController {
    //MARK: - Properties
    private let scrollView = UIScrollView()
    
    private let titlePhoto = UIImageView()
    
    private let titleLabel = UILabel()
    var titleText = "우리의 음식"
    private let segementLabel = UILabel()
    var segementText = "초급"
    private let temaLabel = UILabel()
    var temaText = "한식"
    private let whoLabel = UILabel()
    var whoText = "꿀꿀이"
    
    private let ingredientsLabel = UILabel()
    private lazy var ingredientsTextView : UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .white
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 10
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.customGray?.cgColor
        tv.font = .systemFont(ofSize: 20, weight: .black)
        tv.textColor = .black

        return tv
    }()
    
    //MAKR: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .customPink
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        navigationItem.title = "보기"
        

        viewChange()
    }
    
    //MAKR: - ViewMethod
    private func viewChange() {
        
        
        view.addSubview(scrollView)
        scrollView.indicatorStyle = .white
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets)
            make.right.left.equalTo(view)
            make.bottom.equalTo(view.safeAreaInsets)
        }
        
        scrollView.addSubview(titlePhoto)
        titlePhoto.layer.borderWidth = 1
        titlePhoto.layer.borderColor = UIColor.customPink?.cgColor
        titlePhoto.backgroundColor = .white
        titlePhoto.snp.makeConstraints { make in
            make.top.equalTo(scrollView).inset(10)
            make.right.left.equalTo(view).inset(10)
            make.height.equalTo(280)
        }
        
        scrollView.addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 25)
        titleLabel.text = titleText
        titleLabel.textColor = .black
        titleLabel.backgroundColor = .white
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titlePhoto.snp_bottomMargin).offset(15)
            make.left.right.equalTo(view).inset(10)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(segementLabel)
        segementLabel.font = .systemFont(ofSize: 20)
        segementLabel.textColor = .black
        segementLabel.text = segementText
        segementLabel.backgroundColor = .white
        segementLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(20)
            make.left.equalTo(view).inset(10)
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
        
        scrollView.addSubview(temaLabel)
        temaLabel.font = .systemFont(ofSize: 20)
        temaLabel.textColor = .black
        temaLabel.text = temaText
        temaLabel.backgroundColor = .white
        temaLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(20)
            make.left.equalTo(segementLabel.snp_rightMargin).offset(30)
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
        
        scrollView.addSubview(whoLabel)
        whoLabel.font = .systemFont(ofSize: 20)
        whoLabel.textColor = .black
        whoLabel.text = whoText
        whoLabel.backgroundColor = .white
        whoLabel.snp.makeConstraints { make in
            make.top.equalTo(temaLabel.snp_bottomMargin).offset(20)
            make.left.equalTo(view).inset(10)
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
        
        scrollView.addSubview(ingredientsLabel)
        ingredientsLabel.font = .systemFont(ofSize: 25)
        ingredientsLabel.textColor = .black
        ingredientsLabel.text = "재료"
        ingredientsLabel.backgroundColor = .white
        ingredientsLabel.snp.makeConstraints { make in
            make.top.equalTo(whoLabel.snp_bottomMargin).offset(30)
            make.left.right.equalTo(view).inset(10)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(ingredientsTextView)
        ingredientsTextView.snp.makeConstraints { make in
            make.top.equalTo(ingredientsLabel.snp_bottomMargin).offset(15)
            make.left.right.equalTo(view).inset(10)
            make.height.equalTo(250)
            make.bottom.equalTo(scrollView).offset(20)
        }
        
        
    }
    

   
}
