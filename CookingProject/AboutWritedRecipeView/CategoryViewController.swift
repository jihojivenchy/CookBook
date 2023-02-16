//
//  ChoiceCategoryViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/01/26.
//

import UIKit
import SnapKit

final class CategoryViewController: UIViewController {
    //MARK: - Properties
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let scrollView = UIScrollView()
    
    private let progressBar = UIProgressView()
    private let categoryLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let categoryCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        
        let cView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cView.backgroundColor = .clear
        cView.tag = 1
        cView.isScrollEnabled = false
        cView.showsVerticalScrollIndicator = false
        
        return cView
    }()
    private let categoryArray : [String] = ["한식", "중식", "양식", "일식", "간식", "채식", "퓨전", "분식", "안주"]
    
    private lazy var nextButton : UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(nextButtonPressed(_:)), for: .touchUpInside)
        button.backgroundColor = .customSignature
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }()
    
    final var selectedCategory = String()
    final var userName = String()
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        
        addSubViews()
        
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    private func addSubViews() {
        view.backgroundColor = .customGray
        
        view.addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(progressBar)
        progressBar.backgroundColor = .lightGray
        progressBar.progress = 0.05
        progressBar.progressTintColor = .customSignature
        progressBar.layer.cornerRadius = 2
        progressBar.clipsToBounds = true
        progressBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalTo(view).inset(25)
            make.height.equalTo(7)
        }
        
        scrollView.addSubview(categoryLabel)
        categoryLabel.text = "카테고리를 선택해주세요"
        categoryLabel.textColor = .black
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 25)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(progressBar.snp_bottomMargin).offset(30)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(subTitleLabel)
        subTitleLabel.text = "선택한 카테고리란에 레시피가 올라갑니다."
        subTitleLabel.textColor = .darkGray
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 17)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp_bottomMargin).offset(20)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(20)
        }
        
        scrollView.addSubview(categoryCollectionView)
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp_bottomMargin).offset(50)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }
        
        scrollView.addSubview(nextButton)
        nextButton.alpha = 0.6
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp_bottomMargin).offset(50)
            make.left.right.equalTo(view).inset(25)
            make.height.equalTo(55)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
//MARK: - ButtonMethod
    
    @objc private func nextButtonPressed(_ sender : UIButton){
        let state = nextButton.alpha
        
        if state == 1.0 {
            let vc = LevelViewController()
            vc.sendedArray[0] = self.selectedCategory
            vc.userName = self.userName
            
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            CustomAlert.show(title: "카테고리 선택", subMessage: "선택 후 진행이 가능합니다.")
        }
    }
    
    
//MARK: - DataMethod
    
    
    
}
//MARK: - Extension
extension CategoryViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.categoryArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        
        cell.categoryLabel.text = self.categoryArray[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 3
        let height = collectionView.frame.height / 3
        
        return CGSize(width: width, height: height)
    }
}

extension CategoryViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.nextButton.alpha = 1
        self.selectedCategory = categoryArray[indexPath.row]
        
    }
}

