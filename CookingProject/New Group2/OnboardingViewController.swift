//
//  FirstViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/19.
//

import UIKit
import SnapKit

class OnboardingViewController : UIViewController {

//MARK: - Properties
    private lazy var onBoardingCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let bc = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        bc.delegate = self
        bc.dataSource = self
        bc.backgroundColor = .white
        
        return bc
    }()
    
    private lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = imageArray.count
        pc.currentPage = 0
        pc.pageIndicatorTintColor = UIColor.customGray // 페이지를 암시하는 동그란 점의 색상
        pc.currentPageIndicatorTintColor = UIColor.black
        
        return pc
    }()
    
    private let imageArray = ["비빔밥", "요리사", "양식"]
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewChange()
        onBoardingCollectionView.register(OnBoadingCollectionViewCell.self, forCellWithReuseIdentifier: OnBoadingCollectionViewCell.identifier)
    }
    
    
//MARK: - ViewMethod
    private func viewChange() {
        view.backgroundColor = .white
        
    }
    
}

//MARK: - Extension
extension OnboardingViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}

extension OnboardingViewController : UICollectionViewDelegate {
    
}

extension OnboardingViewController : UICollectionViewDelegateFlowLayout {
    
}
