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
        flowLayout.minimumInteritemSpacing = 0
        
        let bc = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        bc.delegate = self
        bc.dataSource = self
        bc.backgroundColor = .white
        bc.isPagingEnabled = true
        bc.indicatorStyle = .white
        
        return bc
    }()
    
    
    private lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.numberOfPages = imageArray.count
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .black
        
        return pc
    }()
    
    private lazy var goToJoinButton : UIButton = {
        let gb = UIButton()
        gb.setTitle("회원가입", for: .normal)
        gb.setTitleColor(.white, for: .normal)
        gb.backgroundColor = .customPink
        gb.layer.cornerRadius = 5
        
        gb.addTarget(self, action: #selector(goTojoinButtonPreesed(_:)), for: .touchUpInside)
        
        return gb
    }()
    
    private let imageArray = [UIImage(named: "onboarding1"), UIImage(named: "onboarding2"), UIImage(named: "onboarding3"), UIImage(named: "onboarding4")]
    
    private let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = backButton
        
        viewChange()
        onBoardingCollectionView.register(OnBoadingCollectionViewCell.self, forCellWithReuseIdentifier: OnBoadingCollectionViewCell.identifier)
    }
    
    
//MARK: - ViewMethod
    private func viewChange() {
        view.backgroundColor = .white
        
        view.addSubview(onBoardingCollectionView)
        onBoardingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets).inset(70)
            make.left.right.equalTo(view).inset(10)
            make.bottom.equalTo(view.safeAreaInsets).inset(110)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(onBoardingCollectionView.snp_bottomMargin).offset(10)
            make.centerX.equalTo(onBoardingCollectionView)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        view.addSubview(goToJoinButton)
        goToJoinButton.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp_bottomMargin).offset(30)
            make.centerX.equalTo(view)
            make.width.equalTo(250)
            make.height.equalTo(40)
            
        }
    }
    
    @objc private func goTojoinButtonPreesed(_ sender : UIButton){
        performSegue(withIdentifier: "goToJoin", sender: self)
    }
}

//MARK: - Extension
extension OnboardingViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoadingCollectionViewCell.identifier, for: indexPath) as! OnBoadingCollectionViewCell
        cell.onBoadingImageView.image = imageArray[indexPath.row]
        
        return cell
    }
}

extension OnboardingViewController : UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let page = Int(targetContentOffset.pointee.x / onBoardingCollectionView.frame.width)
        self.pageControl.currentPage = page
        
    }
}

extension OnboardingViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    //section 사이의 공간을 제거
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
        return size
    }
}

