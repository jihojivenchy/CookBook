//
//  ReadViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/09.
//

import UIKit
import SnapKit

class ReadViewController : UIViewController {
    //MARK: - Properties
    let scrollView = UIScrollView()
    let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
    let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
    let kButton = UIButton()      //한식 버튼
    let cButton = UIButton()      //중식 버튼
    let aButton = UIButton()      //양식 버튼
    let jButton = UIButton()      //일식 버튼
    let sButton = UIButton()      //간식 버튼
    let veButton = UIButton()      //채식 버튼
    let fuButton = UIButton()      //퓨전 음식 버튼
    let sfButton = UIButton()      //분식 버튼
    let lightButton = UIButton()      //가벼운 안주 버튼
    let allButton = UIButton()  //전체 보기 버튼
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()) //collectionview를 초기화할 때 꼭 레이아웃 설정을 해주어야 한다. 아니면 에러발생!
    let collectionImage = [UIImage(named: "sandwich"), UIImage(named: "채식"), UIImage(named: "한식"), UIImage(named: "양식"), UIImage(named: "sandwich")]
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        viewChange()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
    }
    

    
    //MARK: - ViewMethod
    func viewChange() {
        
        view.addSubview(scrollView)
        scrollView.indicatorStyle = .white
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets).inset(100)
            make.left.right.equalTo(view).inset(0)
            make.height.equalTo(45)
        }
        
        scrollView.addSubview(allButton)
        allButton.setTitle("전체 보기", for: .normal)
        allButton.setTitleColor(.white, for: .normal)
        allButton.backgroundColor = .customGreen
        allButton.layer.cornerRadius = 15
        allButton.clipsToBounds = true
        allButton.layer.borderWidth = 2
        allButton.layer.borderColor = UIColor.white.cgColor
        allButton.snp.makeConstraints { make in
            make.centerY.equalTo(scrollView)
            make.left.equalTo(scrollView).inset(10)
            make.width.equalTo(80)
        }
        
        scrollView.addSubview(kButton)
        kButton.setTitle("한식", for: .normal)
        kButton.backgroundColor = .customGreen
        kButton.layer.cornerRadius = 15
        kButton.clipsToBounds = true
        kButton.layer.borderWidth = 2
        kButton.layer.borderColor = UIColor.white.cgColor
        kButton.setTitleColor(.white, for: .normal)
        kButton.snp.makeConstraints { make in
            make.centerY.equalTo(scrollView)
            make.left.equalTo(allButton.snp_rightMargin).offset(20)
            make.width.equalTo(80)
            
        }
        
        scrollView.addSubview(cButton)
        cButton.setTitle("중식", for: .normal)
        cButton.backgroundColor = .customGreen
        cButton.layer.cornerRadius = 15
        cButton.clipsToBounds = true
        cButton.layer.borderWidth = 2
        cButton.layer.borderColor = UIColor.white.cgColor
        cButton.setTitleColor(.white, for: .normal)
        cButton.snp.makeConstraints { make in
            make.left.equalTo(kButton.snp_rightMargin).offset(20)
            make.width.equalTo(80)
            make.centerY.equalTo(scrollView)
        }
        
        scrollView.addSubview(aButton)
        aButton.setTitle("양식", for: .normal)
        aButton.backgroundColor = .customGreen
        aButton.layer.cornerRadius = 15
        aButton.clipsToBounds = true
        aButton.layer.borderWidth = 2
        aButton.layer.borderColor = UIColor.white.cgColor
        aButton.setTitleColor(.white, for: .normal)
        aButton.snp.makeConstraints { make in
            make.left.equalTo(cButton.snp_rightMargin).offset(20)
            make.width.equalTo(80)
            make.centerY.equalTo(scrollView)
        }
        
        scrollView.addSubview(jButton)
        jButton.setTitle("일식", for: .normal)
        jButton.backgroundColor = .customGreen
        jButton.layer.cornerRadius = 15
        jButton.clipsToBounds = true
        jButton.layer.borderWidth = 2
        jButton.layer.borderColor = UIColor.white.cgColor
        jButton.setTitleColor(.white, for: .normal)
        jButton.snp.makeConstraints { make in
            make.left.equalTo(aButton.snp_rightMargin).offset(20)
            make.width.equalTo(80)
            make.centerY.equalTo(scrollView)
        }
        
        scrollView.addSubview(sButton)
        sButton.setTitle("간식", for: .normal)
        sButton.backgroundColor = .customGreen
        sButton.layer.cornerRadius = 15
        sButton.clipsToBounds = true
        sButton.layer.borderWidth = 2
        sButton.layer.borderColor = UIColor.white.cgColor
        sButton.setTitleColor(.white, for: .normal)
        sButton.snp.makeConstraints { make in
            make.left.equalTo(jButton.snp_rightMargin).offset(20)
            make.width.equalTo(80)
            make.centerY.equalTo(scrollView)
        }
        
        scrollView.addSubview(veButton)
        veButton.setTitle("채식", for: .normal)
        veButton.backgroundColor = .customGreen
        veButton.layer.cornerRadius = 15
        veButton.clipsToBounds = true
        veButton.layer.borderWidth = 2
        veButton.layer.borderColor = UIColor.white.cgColor
        veButton.setTitleColor(.white, for: .normal)
        veButton.snp.makeConstraints { make in
            make.left.equalTo(sButton.snp_rightMargin).offset(20)
            make.width.equalTo(80)
            make.centerY.equalTo(scrollView)
        }
        
        scrollView.addSubview(fuButton)
        fuButton.setTitle("퓨전", for: .normal)
        fuButton.backgroundColor = .customGreen
        fuButton.layer.cornerRadius = 15
        fuButton.clipsToBounds = true
        fuButton.layer.borderWidth = 2
        fuButton.layer.borderColor = UIColor.white.cgColor
        fuButton.setTitleColor(.white, for: .normal)
        fuButton.snp.makeConstraints { make in
            make.left.equalTo(veButton.snp_rightMargin).offset(20)
            make.width.equalTo(80)
            make.centerY.equalTo(scrollView)
        }
        
        scrollView.addSubview(sfButton)
        sfButton.setTitle("분식", for: .normal)
        sfButton.backgroundColor = .customGreen
        sfButton.layer.cornerRadius = 15
        sfButton.clipsToBounds = true
        sfButton.layer.borderWidth = 2
        sfButton.layer.borderColor = UIColor.white.cgColor
        sfButton.setTitleColor(.white, for: .normal)
        sfButton.snp.makeConstraints { make in
            make.left.equalTo(fuButton.snp_rightMargin).offset(20)
            make.width.equalTo(80)
            make.centerY.equalTo(scrollView)
        }
        
        scrollView.addSubview(lightButton)
        lightButton.setTitle("안주", for: .normal)
        lightButton.backgroundColor = .customGreen
        lightButton.layer.cornerRadius = 15
        lightButton.clipsToBounds = true
        lightButton.layer.borderWidth = 2
        lightButton.layer.borderColor = UIColor.white.cgColor
        lightButton.setTitleColor(.white, for: .normal)
        lightButton.snp.makeConstraints { make in
            make.left.equalTo(sfButton.snp_rightMargin).offset(20)
            make.width.equalTo(80)
            make.right.equalTo(scrollView).offset(20)
            make.centerY.equalTo(scrollView)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp_bottomMargin).offset(30)
            make.right.left.equalTo(view).inset(0)
            make.height.equalTo(660)
        }
        
    }
}

//MARK: - Collection datasource, delegate
extension ReadViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCell.identifier, for: indexPath) as! CustomCell
        
        
        cell.imageView.image = collectionImage[indexPath.row]
        
        return cell
    }
    
    //위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
    
    //옆 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            
        let width = collectionView.frame.width / 2 - 1
        
        let size = CGSize(width: width, height: 250)
        
        return size
       }
   
}

//MARK: - CustomCellClass
class CustomCell : UICollectionViewCell {
    static let identifier = "CustomCollectionCell"
    
    let imageView = UIImageView()
    let titleLable = UILabel()
    let difficultyLabel = UILabel()
    let whoLabel = UILabel()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
    
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewInit() {
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
          make.height.equalTo(140)
            
        }
        
        addSubview(titleLable)
        titleLable.text = "우리의 음식"
        titleLable.textColor = .black
        titleLable.font = .systemFont(ofSize: 20)
        titleLable.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }

        addSubview(difficultyLabel)
        difficultyLabel.text = "초급"
        difficultyLabel.textColor = .black
        difficultyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp_bottomMargin).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(20)

        }

        addSubview(whoLabel)
        whoLabel.text = "작성자 : jiho"
        whoLabel.textColor = .black
        whoLabel.snp.makeConstraints { make in
            make.top.equalTo(difficultyLabel.snp_bottomMargin).offset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(20)
        }
        
        
        
        
        
    }
    
    
    
}
    
