//
//  ViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/07/08.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import SideMenu
import Lottie

final class HomeViewController: UIViewController{
//MARK: - Properties
    private let db = Firestore.firestore()
    private var userInformationData : UserInformationData = .init(name: "", email: "", login: "")
    
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
    
    private let weatherImageView = UIImageView()
    private let animationView = AnimationView(name: "cooking")
    private let introduceView = UIView()
    private let introduceLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let backGroundView = UIView()
    
    private let popularLabel = UILabel()
    private let popularCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
        flowLayout.itemSize = .init(width: 250, height: 300)
        let inset = (UIScreen.main.bounds.width - 250) / 2
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        let cView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cView.backgroundColor = .white
        cView.tag = 0
        cView.showsHorizontalScrollIndicator = false
        cView.decelerationRate = .fast
        cView.isPagingEnabled = false
        
        return cView
    }()
    
    private let popularImageArray : [String] = ["양식", "퓨전", "채식", "비빔밥", "맥주"]
    private lazy var popularDataSource: [String] = {
       popularImageArray + popularImageArray + popularImageArray + popularImageArray + popularImageArray + popularImageArray + popularImageArray + popularImageArray + popularImageArray
    }()
    
    private var previousCellIndex : Int = 20 //지나간 cell은 다시 축소 이미지 animation 구현
    
    private var pageIndex = 0
    private lazy var pageControl : UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = pageIndex
        pc.numberOfPages = 5
        pc.currentPageIndicatorTintColor = .customSignature
        pc.pageIndicatorTintColor = .lightGray
        
        return pc
    }()
    
    private var scrollToEnd: Bool = false  //무한 carousel을 구현할 때 다시 원점으로 돌아가게 해주도록 toggle 형식
    private var scrollToBegin: Bool = false //무한 carousel을 구현할 때 다시 원점으로 돌아가게 해주도록 toggle 형식
    
    private var timer: Timer!
    private var currentIndex = 20

    private let temaLabel = UILabel()
    private let temaCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let cView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cView.backgroundColor = .white
        cView.tag = 1
        cView.isScrollEnabled = false
        cView.showsVerticalScrollIndicator = false
        
        return cView
    }()
    
    private let temaArray : [String] = ["한식", "중식", "양식", "일식", "간식", "채식", "퓨전", "분식", "안주"]
    
    private let scrollView = UIScrollView()
    private let whiteView = UIView()


//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUsereData()
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        
        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(moveToNextCell), userInfo: nil, repeats: true)
        
        animationView.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        naviBarAppearance()
        
        setPopularCollection()
        setTemaCollection()
        
        checkAppleLogin()
        tabBarAppearance()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popularCollectionView.scrollToItem(at: IndexPath(item: 20, section: 0),
                                            at: .centeredHorizontally,
                                            animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //뷰가 사라질 때 타이머 종료
        timer.invalidate()
        animationView.stop()
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
        
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem = menuButton
        self.navigationItem.rightBarButtonItem = signalButton
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
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaInsets)
        }
        
        scrollView.addSubview(introduceLabel)
        introduceLabel.lineBreakStrategy = .hangulWordPriority
        introduceLabel.textColor = .customSignature
        introduceLabel.numberOfLines = 2
        introduceLabel.font = UIFont(name: KeyWord.CustomFont, size: 30)
        introduceLabel.sizeToFit()
        introduceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.right.equalTo(view).inset(20)
        }
        
        scrollView.addSubview(subTitleLabel)
        subTitleLabel.textColor = .darkGray
        subTitleLabel.font = UIFont(name: KeyWord.CustomFont, size: 20)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel.snp_bottomMargin).offset(15)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(30)
        }
        
        scrollView.addSubview(animationView)
        animationView.animationSpeed = 0.7
        animationView.loopMode = .loop
        animationView.backgroundColor = .clear
        animationView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp_bottomMargin)
            make.right.equalTo(view)
            make.width.equalTo(150)
            make.height.equalTo(135)
        }
        
        scrollView.addSubview(backGroundView)
        backGroundView.backgroundColor = .white
        backGroundView.clipsToBounds = true
        backGroundView.layer.cornerRadius = 13
        backGroundView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        backGroundView.layer.masksToBounds = false
        backGroundView.layer.shadowOpacity = 1
        backGroundView.layer.shadowColor = UIColor.darkGray.cgColor
        backGroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backGroundView.layer.shadowRadius = 0.5
        backGroundView.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp_bottomMargin).offset(10)
            make.left.right.equalTo(view)
            make.height.equalTo(930)
            make.bottom.equalToSuperview()
        }
        
        backGroundView.addSubview(popularLabel)
        popularLabel.text = "추천 레시피"
        popularLabel.textColor = .black
        popularLabel.textAlignment = .center
        popularLabel.font = UIFont(name: KeyWord.CustomFont, size: 22)
        popularLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(25)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(40)
        }
        
        backGroundView.addSubview(popularCollectionView)
        popularCollectionView.snp.makeConstraints { make in
            make.top.equalTo(popularLabel.snp_bottomMargin).offset(30)
            make.left.right.equalTo(view)
            make.height.equalTo(300)
        }
        
        backGroundView.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(popularCollectionView.snp_bottomMargin).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(10)
        }
        
        backGroundView.addSubview(temaLabel)
        temaLabel.text = "카테고리"
        temaLabel.textColor = .black
        temaLabel.textAlignment = .center
        temaLabel.font = UIFont(name: KeyWord.CustomFont, size: 22)
        temaLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp_bottomMargin).offset(70)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        backGroundView.addSubview(temaCollectionView)
        temaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(temaLabel.snp_bottomMargin).offset(25)
            make.left.right.equalTo(view).inset(15)
            make.height.equalTo(360)
        }
        
        
    }
    
    private func setPopularCollection() {
        popularCollectionView.register(PopularCollectionViewCell.self, forCellWithReuseIdentifier: PopularCollectionViewCell.identifier)
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
    } //컬렉션뷰 필요한 코드 set
    
    private func setTemaCollection() {
        temaCollectionView.register(TemaCollectionViewCell.self, forCellWithReuseIdentifier: TemaCollectionViewCell.identifier)
        temaCollectionView.dataSource = self
        temaCollectionView.delegate = self
    }   //컬렉션뷰 필요한 코드 set
    
    private func setPageControlIndex() {
        let currentPage = Int(popularCollectionView.contentOffset.x / 270)
        
        self.pageIndex = currentPage % 5         //pagecontrol을 위한
        self.currentIndex = currentPage          //자동스크롤을 위한
        pageControl.currentPage = pageIndex
    } //pagecontrol currenpage 맞추기.
    
    private func zoomFocusCell(cell: UICollectionViewCell, isFocus: Bool ) {
        UIView.animate( withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            if isFocus {
                cell.transform = .identity
            } else {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        }, completion: nil)
    } //해당 셀의 크기 커지게 해주는 코드
    
//MARK: - ButtonMethod
    
    @objc private func menuButtonPressed(_ sender : UIBarButtonItem) {
        let vc = SideMenuViewController()
        vc.userInformationData = self.userInformationData
        
        let sideView = SideMenuNavigation(rootViewController: vc)
        
        
        present(sideView, animated: true)
    }
    
    @objc private func signalButtonPressed(_ sender : UIBarButtonItem) {
        self.navigationController?.pushViewController(SignalViewController(), animated: true)
    }
    
    
    private func showClickedIndex(number : Int) {
        let vc = ReadViewController()
        vc.defaltPageNumber = number
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
//MARK: - Timer
    @objc func moveToNextCell() {
        pageIndex += 1
        
        if pageIndex > 4 {
            pageIndex = 0
        }
        
        currentIndex += 1
        if currentIndex == 40 { //39번 인덱스에 가면 다시 원상복귀
            currentIndex = 20
            pageIndex = 0
        }
        
        let indexPath = IndexPath(item: currentIndex, section: 0)
        
        if currentIndex == 20 { //돌아갈 때 휘리리릭하는 애니메이션 없애면 좀 더 이어지는 느낌이 난다.
            popularCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }else{
            popularCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
        pageControl.currentPage = pageIndex
    }

}

//MARK: - Extension
extension HomeViewController {
    //유저가 앱 설정에서 애플 id 로그아웃을 실행했을 때 우리는 로그인 화면으로 보여줌.
    private func checkAppleLogin() {
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (Notification) in
            
            self.navigationController?.pushViewController(SocialLoginViewController(), animated: true)
        }
    }
} //애플 로그인 유저가 로그아웃 했을 때 확인

extension HomeViewController : UIScrollViewDelegate {
    //스크롤뷰 드래그가 끝나려 할 때 호출
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //velocity : 터치가 끝났을 때의 드래그 속도값
        //targetContentOffset : content가 정지해야 할 offset
        let cellWidthIncludeSpacing : CGFloat = 270 //cell의 width + cell의 spacing

        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludeSpacing
        let index: Int

        // 스크롤 방향 체크
        // item 절반 사이즈 만큼 스크롤로 판단하여 올림, 내림 처리
        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
            
        }else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
            
        }else {
            index = Int(round(estimatedIndex))
        }
        // 위 코드를 통해 페이징 될 좌표 값을 targetContentOffset에 대입
        targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidthIncludeSpacing, y: 0)

        let beginOffset = 270 * CGFloat(5.5) //마지막 인덱스로 다시 되돌려줄 위치 포인트
        let endOffset = 270 * CGFloat(20 * 2 - 1) //처음 인덱스로 다시 되돌려줄 위치 포인트
        
        //현재 컨텐츠의 위치가 되돌려줄 위치 포인트를 지나치면 다시 되돌려줌., 속도값의 x는 드래그 약하게 하면 0으로 뱉음.
        if scrollView.contentOffset.x < beginOffset && velocity.x < .zero {
            
            scrollToEnd = true
            print("처음 -> 마지막")
            
        } else if scrollView.contentOffset.x > endOffset && velocity.x > .zero { //반대로 컨텐츠 위치가 정해준 포인트를 지나면 되돌려줌.
            scrollToBegin = true
            print("마지막 -> 처음")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.setPageControlIndex()
        
        if scrollToBegin {
            self.pageControl.currentPage = 0
            popularCollectionView.scrollToItem(at: IndexPath(item: 20, section: .zero),
                                                at: .centeredHorizontally,
                                                animated: false)
            scrollToBegin.toggle()
            return
        }
        if scrollToEnd {
            self.pageControl.currentPage = 4
            popularCollectionView.scrollToItem(at: IndexPath(item: 24, section: .zero),
                                                at: .centeredHorizontally,
                                                animated: false)
            scrollToEnd.toggle()
            return
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        let cellWidthIncludeSpacing : CGFloat = 270                    //cell의 width + cell의 spacing
        let offsetX = popularCollectionView.contentOffset.x            //컬렉션뷰의 현재 x 위치
        let index = (offsetX + popularCollectionView.contentInset.left) / cellWidthIncludeSpacing
        let roundedIndex = round(index)                                //int형태로 나타내기 위해서 반올림.
        let indexPath = IndexPath(item: Int(roundedIndex), section: 0) //스크롤 후 보여지는 인덱스.
        
        if let cell = popularCollectionView.cellForItem(at: indexPath) {
            zoomFocusCell(cell: cell, isFocus: true)
        }
        
        if Int(roundedIndex) != previousCellIndex {
            let preIndexPath = IndexPath(item: previousCellIndex, section: 0)
            if let preCell = popularCollectionView.cellForItem(at: preIndexPath) {
                zoomFocusCell(cell: preCell, isFocus: false)
            }
            previousCellIndex = indexPath.item
        }
    }
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 0 {
            return self.popularDataSource.count
        }else{
            return self.temaArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell.identifier, for: indexPath) as! PopularCollectionViewCell
            
            cell.foodImageView.image = UIImage(named: self.popularDataSource[indexPath.row])
            
            if indexPath.row != self.previousCellIndex {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            
            return cell
            
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TemaCollectionViewCell.identifier, for: indexPath) as! TemaCollectionViewCell
            
            cell.temaButton.setBackgroundImage(UIImage(named: self.temaArray[indexPath.row]), for: .normal)
            cell.temaLabel.text = self.temaArray[indexPath.row]
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var size = CGSize()
        
        if collectionView.tag == 0 {
            
            size = CGSize(width: 250, height: 300)
            
        }else{
            let width = collectionView.frame.width / 3
            let height = collectionView.frame.height / 3
            
            size = CGSize(width: width, height: height)
        }
        
        return size
    }
}

extension HomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CategoryViewController()
        vc.userName = self.userInformationData.name
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//유저 정보 가져오기
extension HomeViewController {
    private func getUsereData(){
        CustomLoadingView.shared.startLoading()
        
        if let user = Auth.auth().currentUser {
            
            db.collection("Users").document("\(user.uid)").getDocument { qs, error in
                if let e = error {
                    print("Error 유저 데이터 가져오기 실패 \(e)")
                    CustomLoadingView.shared.stopLoading()
                }else{
                    guard let userData = qs?.data() else {return} //해당 도큐먼트 안에 데이터가 있는지 확인
                    
                    guard let userEmailData = user.email else{return} //유저 이메일
                    guard let userNameData = userData["NickName"] as? String else{return} //유저 닉네임
                    guard let userLoginData = userData["login"] as? String else{return}
                    
                    self.userInformationData = UserInformationData(name: userNameData, email: userEmailData, login: userLoginData)
                    
                    DispatchQueue.main.async {
                        self.setIntroduceText(name: self.userInformationData.name)
                        CustomLoadingView.shared.stopLoading()
                    }
                }
            }
        }else{
            self.setIntroduceText(name: "유저")
            self.userInformationData = .init(name: "로그인", email: "로그인이 필요합니다.", login: "")
            CustomLoadingView.shared.stopLoading()
        }
    }
    
    private func setIntroduceText(name : String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "HH"
        
        guard let currentTime = Int(dateFormatter.string(from: Date())) else{return}
        
        if currentTime < 06 { //새벽
            self.introduceLabel.text = "Good Night, \(name)님"
            self.subTitleLabel.text = "편안한 밤 보내세요."
            
        }else if currentTime < 12 { //아침
            self.introduceLabel.text = "좋은아침, \(name)님"
            self.subTitleLabel.text = "상쾌한 하루를 준비해보세요."
            
        }else if currentTime < 19 { //오후
            self.introduceLabel.text = "Good Afternoon, \(name)님"
            self.subTitleLabel.text = "든든한 오후를 준비해보세요."
            
        }else{ //저녁
            self.introduceLabel.text = "좋은하루, \(name)님"
            self.subTitleLabel.text = "행복한 저녁을 준비해보세요."
        }
    } //유저에게 전하는 메세지 시간에 따라 변경
}
