//
//  ViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/08.
//

import UIKit
import SnapKit
import FirebaseAuth
import AuthenticationServices

final class HomeViewController: UIViewController{
//MARK: - Properties
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private lazy var menuButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "text.alignleft"), style: .done, target: self, action: #selector(menuButtonPressed(_:)))
        button.tintColor = .customSignature
        
        return button
    }()
    
    private lazy var signalButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .done, target: self, action: #selector(signalButtonPressed(_:)))
        button.tintColor = .customSignature
        
        return button
    }()
    
    private let popularLabel = UILabel()
    private lazy var popularCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let cView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cView.backgroundColor = .white
        cView.tag = 0
        cView.showsHorizontalScrollIndicator = false
        cView.register(PopularCollectionViewCell.self, forCellWithReuseIdentifier: PopularCollectionViewCell.identifier)
        cView.dataSource = self
        cView.delegate = self
        
        return cView
    }()
    
    private let popularImageArray : [String] = ["초밥", "초밥", "초밥", "초밥", "초밥"]

    private let temaLabel = UILabel()
    private lazy var temaCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let cView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cView.backgroundColor = .white
        cView.tag = 1
        cView.isScrollEnabled = false
        cView.showsVerticalScrollIndicator = false
        cView.register(TemaCollectionViewCell.self, forCellWithReuseIdentifier: TemaCollectionViewCell.identifier)
        cView.dataSource = self
        cView.delegate = self
        
        return cView
    }()
    
    private let temaImageArray : [String] = ["비빔밥", "dimsum", "양식", "초밥", "sandwich", "채식", "퓨전", "김밥", "맥주"]
    private let temaLabelArray : [String] = ["한식", "중식", "양식", "일식", "간식", "채식", "퓨전", "분식", "안주"]
    
    private let scrollView = UIScrollView()
    private let whiteView = UIView()

    
//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        
        checkLoginState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        naviBarAppearance()
//        navigationTitleCustom()
        checkAppleLogin()
        tabBarAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showIndex()
    }
    
    
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem = menuButton
        self.navigationItem.rightBarButtonItem = signalButton
    }
    
    private func navigationTitleCustom() {
        let titleName = UILabel()
        titleName.text = "요리도감"
        titleName.font = UIFont(name: "EF_watermelonSalad", size: 25)
        titleName.textAlignment = .center
        titleName.textColor = .black
        titleName.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [titleName])
        stackView.axis = .horizontal
        stackView.frame.size.width = titleName.frame.width
        stackView.frame.size.height = titleName.frame.height
        
        self.navigationItem.titleView = stackView
    }
    
    private func tabBarAppearance() {
        let tapAppearnce = UITabBarAppearance()
        tapAppearnce.backgroundColor = .customSignature
        tabBarController?.tabBar.standardAppearance = tapAppearnce
        tabBarController?.tabBar.scrollEdgeAppearance = tapAppearnce
        
    }
    
    
    private func addSubViews() {
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().inset(50)
            make.right.left.equalTo(view)
        }
        
        scrollView.addSubview(popularLabel)
        popularLabel.text = "인기 레시피"
        popularLabel.textColor = .black
        popularLabel.textAlignment = .center
        popularLabel.font = .boldSystemFont(ofSize: 25)
        popularLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(popularCollectionView)
        popularCollectionView.snp.makeConstraints { make in
            make.top.equalTo(popularLabel.snp_bottomMargin).offset(25)
            make.left.right.equalTo(view)
            make.height.equalTo(280)
        }
        
        scrollView.addSubview(temaLabel)
        temaLabel.text = "테마별 레시피"
        temaLabel.textColor = .black
        temaLabel.textAlignment = .center
        temaLabel.font = .boldSystemFont(ofSize: 25)
        temaLabel.snp.makeConstraints { make in
            make.top.equalTo(popularCollectionView.snp_bottomMargin).offset(50)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        scrollView.addSubview(temaCollectionView)
        temaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(temaLabel.snp_bottomMargin).offset(25)
            make.left.right.equalTo(view).inset(15)
            make.height.equalTo(360)
        }
        
        scrollView.addSubview(whiteView)
        whiteView.backgroundColor = .white
        whiteView.snp.makeConstraints { make in
            make.top.equalTo(temaCollectionView.snp_bottomMargin).offset(30)
            make.left.right.equalTo(view)
            make.height.equalTo(100)
            make.bottom.equalTo(scrollView).inset(20)
            
        }
    }
    
    private func checkLoginState() {
        if Auth.auth().currentUser != nil { //유저가 로그인 상태가 아니라면 로그인 뷰로 고고
            
        }else{
            self.navigationController?.pushViewController(SocialLoginViewController(), animated: true)
        }
    }
    
    private func showIndex() {
        
        let indexPath = IndexPath(row: 1, section: 0)
        popularCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    
//MARK: - ButtonMethod
    @objc private func menuButtonPressed(_ sender : UIBarButtonItem) {
        
    }
    
    @objc private func signalButtonPressed(_ sender : UIBarButtonItem) {
        
    }
    
    @objc private func kButtonPressed(_ sender : UIButton) {
        showClickedIndex(number: 1)
    }
    
    @objc private func cButtonPressed(_ sender : UIButton) {
        showClickedIndex(number: 2)
    }
    
    @objc private func aButtonPressed(_ sender : UIButton) {
        showClickedIndex(number: 3)
    }
    
    @objc private func jButtonPressed(_ sender : UIButton) {
        showClickedIndex(number: 4)
    }
    
    @objc private func sButtonPressed(_ sender : UIButton) {
        showClickedIndex(number: 5)
    }
    
    @objc private func veButtonPressed(_ sender : UIButton) {
        showClickedIndex(number: 6)
    }
    
    @objc private func fuButtonPressed(_ sender : UIButton) {
        showClickedIndex(number: 7)
    }
    
    @objc private func sfButtonPressed(_ sender : UIButton) {
        showClickedIndex(number: 8)
    }
    
    @objc private func lightButtonPressed(_ sender : UIButton) {
        showClickedIndex(number: 9)
    }
    
    private func showClickedIndex(number : Int) {
        let vc = ReadViewController()
        vc.defaltPageNumber = number
        
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

//MARK: - Extension
extension HomeViewController {
    //유저가 앱 설정에서 애플 id 로그아웃을 실행했을 때 우리는 로그인 화면으로 보여줌.
    private func checkAppleLogin() {
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (Notification) in
            print("Revoked Notification")
        }
    }
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 0 {
            return self.popularImageArray.count
        }else{
            return self.temaImageArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell.identifier, for: indexPath) as! PopularCollectionViewCell
            
            cell.foodImageView.image = UIImage(named: self.popularImageArray[indexPath.row])
            
            return cell
            
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TemaCollectionViewCell.identifier, for: indexPath) as! TemaCollectionViewCell
            
            cell.temaButton.setBackgroundImage(UIImage(named: self.temaImageArray[indexPath.row]), for: .normal)
            cell.temaLabel.text = self.temaLabelArray[indexPath.row]
            
            return cell
        }
    }
    
    //위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    //옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView.tag == 0 {
            return 30
        }else{
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize()
        
        if collectionView.tag == 0 {
            let width = collectionView.frame.width - 90
            size = CGSize(width: width, height: 280)
            
        }else{
            let width = collectionView.frame.width / 3
            let height = collectionView.frame.height / 3
            
            size = CGSize(width: width, height: height)
        }
        
        return size
    }
}

extension HomeViewController : UICollectionViewDelegate {
    
}

