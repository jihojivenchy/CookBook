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
import Kingfisher

final class HomeViewController: UIViewController{
//MARK: - Properties
    private let db = Firestore.firestore()
    private var myInformationData : MyInformationData = .init(myEmail: "", loginInfo: "")
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        sb.tintColor = .customNavy
        
        return sb
    }()
    
    private lazy var menuButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "text.alignleft"), style: .done, target: self, action: #selector(menuButtonPressed(_:)))
        button.tintColor = .customNavy
        
        return button
    }()
    
    private lazy var homeButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .default)
        let image = UIImage(systemName: "house", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = "홈"
        configuration.attributedTitle?.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .white
        button.addTarget(self, action: #selector(homeButtonPressed(_:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }() //customTabbar용
    
    private lazy var plusButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .default)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = "작성"
        configuration.attributedTitle?.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .white
        button.addTarget(self, action: #selector(plusButtonPressed(_:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }() //customTabbar용
    
    private lazy var bellButton : UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular, scale: .default)
        let image = UIImage(systemName: "bell", withConfiguration: imageConfig)
        var configuration = UIButton.Configuration.tinted()
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        configuration.title = "알림"
        configuration.attributedTitle?.font = UIFont(name: FontKeyWord.CustomFont, size: 12)
        configuration.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .white
        button.addTarget(self, action: #selector(bellButtonPressed(_:)), for: .touchUpInside)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7
        
        return button
    }() //customTabbar용
    
    private let animationView = AnimationView(name: "prepare")
    private let introduceLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let backGroundView = UIView()
    private let backGroundView2 = UIView()
    private let backGroundView3 = UIView()
    
    private let popularLabel = UILabel()
    private let popularCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
        flowLayout.itemSize = .init(width: 250, height: 300)
        let inset = (UIScreen.main.bounds.width - 250) / 2
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        let cView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cView.backgroundColor = .clear
        cView.tag = 0
        cView.showsHorizontalScrollIndicator = false
        cView.decelerationRate = .fast
        cView.isPagingEnabled = false
        
        return cView
    }()
    
    private var popularRecipeDataArray : [PopularRecipeDataModel] = []
    
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
    
    private var timer = Timer()
    private var currentIndex = 20

    private let categoryLabel = UILabel()
    private let categoryCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let cView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cView.backgroundColor = .clear
        cView.tag = 1
        cView.isScrollEnabled = false
        cView.showsVerticalScrollIndicator = false
        
        return cView
    }()
    
    private let categoryArray : [String] = ["한식", "중식", "양식", "일식", "간식", "채식", "퓨전", "분식", "안주"]
    
    private let scrollView = UIScrollView()
    

//MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUsereData()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        animationView.play()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
//        getPopularRecipeData()
        setCustomTabButton()
        addSubViews()
        naviBarAppearance()

        setPopularCollection()
        setTemaCollection()
        
        checkAppleLogin()
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //뷰가 사라질 때 타이머 종료
        animationView.stop()
    }
    
    
//MARK: - ViewMethod
    private func naviBarAppearance() {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.clipsToBounds = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem = menuButton
    }
    
    private func addSubViews() {
        
        view.backgroundColor = .customSignature
        
        view.addSubview(scrollView)
        scrollView.backgroundColor = .customWhite
        scrollView.showsVerticalScrollIndicator = false
        scrollView.clipsToBounds = true
        scrollView.layer.cornerRadius = 30
        scrollView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaInsets)
            make.bottom.equalTo(view.safeAreaInsets).inset(80)
        }
        
        scrollView.addSubview(backGroundView)
        viewBorderCustom()
        backGroundView.backgroundColor = .clear
        backGroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalTo(view)
            make.height.equalTo(270)
        }
        
        backGroundView.addSubview(introduceLabel)
        introduceLabel.lineBreakStrategy = .hangulWordPriority
        introduceLabel.textColor = .customNavy
        introduceLabel.numberOfLines = 2
        introduceLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 30)
        introduceLabel.sizeToFit()
        introduceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        backGroundView.addSubview(subTitleLabel)
        subTitleLabel.textColor = .customNavy
        subTitleLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 20)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel.snp_bottomMargin).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        backGroundView.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.backgroundColor = .clear
        animationView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp_bottomMargin).offset(10)
            make.right.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(110)
        }
        
        scrollView.addSubview(backGroundView2)
        backGroundView2.backgroundColor = .clear
        backGroundView2.snp.makeConstraints { make in
            make.top.equalTo(backGroundView.snp_bottomMargin).offset(30)
            make.left.right.equalTo(view)
            make.height.equalTo(450)
        }
        
        backGroundView2.addSubview(popularLabel)
        popularLabel.text = "인기 레시피"
        popularLabel.textColor = .customNavy
        popularLabel.textAlignment = .center
        popularLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 22)
        popularLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        backGroundView2.addSubview(popularCollectionView)
        popularCollectionView.snp.makeConstraints { make in
            make.top.equalTo(popularLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        backGroundView2.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(popularCollectionView.snp_bottomMargin).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(10)
        }
        
        scrollView.addSubview(backGroundView3)
        backGroundView3.backgroundColor = .clear
        backGroundView3.snp.makeConstraints { make in
            make.top.equalTo(backGroundView2.snp_bottomMargin).offset(30)
            make.left.right.equalTo(view)
            make.height.equalTo(490)
            make.bottom.equalToSuperview().inset(20)
        }
        
        
        backGroundView3.addSubview(categoryLabel)
        categoryLabel.text = "카테고리"
        categoryLabel.textColor = .customNavy
        categoryLabel.textAlignment = .center
        categoryLabel.font = UIFont(name: FontKeyWord.CustomFont, size: 22)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        backGroundView3.addSubview(categoryCollectionView)
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(360)
        }
        
        
    }
    
    private func viewBorderCustom() {
        
        let border = UIView()
        border.backgroundColor = .lightGray
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: 0, width: backGroundView.frame.width, height: 0.5)
        border.clipsToBounds = true
        border.layer.cornerRadius = 30
        border.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        backGroundView.addSubview(border)
        //특정 border line
    }
    
    private func setCustomTabButton() {
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 0
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaInsets).inset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(60)
        }
        
        stackView.addArrangedSubview(homeButton)
        stackView.addArrangedSubview(plusButton)
        stackView.addArrangedSubview(bellButton)
        
    }//탭바 안쓰고 이거 쓸거임.
    
    private func setPopularCollection() {
        popularCollectionView.register(PopularCollectionViewCell.self, forCellWithReuseIdentifier: PopularCollectionViewCell.identifier)
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
    } //컬렉션뷰 필요한 코드 set
    
    private func setTemaCollection() {
        categoryCollectionView.register(TemaCollectionViewCell.self, forCellWithReuseIdentifier: TemaCollectionViewCell.identifier)
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
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
        vc.myInformationData = self.myInformationData
        vc.pushDelegate = self
        
        let sideView = SideMenuNavigation(rootViewController: vc)
        
        
        present(sideView, animated: true)
    }
    
    @objc private func homeButtonPressed(_ sender : UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @objc private func plusButtonPressed(_ sender : UIButton) {
        if Auth.auth().currentUser != nil {
            let vc = CategoryViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            CustomAlert.show(title: "로그인", subMessage: "로그인이 필요한 서비스입니다.")
        }
    }
    
    @objc private func bellButtonPressed(_ sender : UIButton) {
        let vc = ManageNotificationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//MARK: - Timer
    @objc private func moveToNextCell() {
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
            return self.popularRecipeDataArray.count * 11
        }else{
            return self.categoryArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell.identifier, for: indexPath) as! PopularCollectionViewCell
            
            let url = popularRecipeDataArray[indexPath.row % 5].url //이미지 url이 저장되어 있는 배열에서 하나씩 가져오기.
            
            cell.foodImageView.setImage(with: url, width: 250, height: 265)
            
            cell.foodLabel.text = popularRecipeDataArray[indexPath.row % 5].foodName
            cell.nameLabel.text = popularRecipeDataArray[indexPath.row % 5].userName
            cell.heartCountLabel.text = "\(popularRecipeDataArray[indexPath.row % 5].heartPeople.count)"
            cell.levelLabel.text = popularRecipeDataArray[indexPath.row % 5].foodLevel
            
            
            if indexPath.row != self.previousCellIndex {
                cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            
            return cell
            
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TemaCollectionViewCell.identifier, for: indexPath) as! TemaCollectionViewCell
            
            cell.contentView.isUserInteractionEnabled = true
            cell.temaButton.setBackgroundImage(UIImage(named: self.categoryArray[indexPath.row]), for: .normal)
            cell.temaLabel.text = self.categoryArray[indexPath.row]
            
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
        if collectionView.tag == 0 {
            let vc = RecipeViewController()
            vc.recipeDocumentID = self.popularRecipeDataArray[indexPath.row % 5].documentID
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc = ShowRecipeViewController()
            vc.selectedIndex = indexPath.row + 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

//side메뉴에서 cell을 누르면 이곳에서 navi push 진행
extension HomeViewController : CellPushDelegate {
    func cellPressed(index: Int) {
        switch index {
        case 0:    //마이 레시피.
            guard let user = Auth.auth().currentUser else{return}
            guard let myName = UserDefaults.standard.string(forKey: "myName") else{return}
            
            let vc = MyRecipeViewController()
            vc.userName = myName
            vc.userUid = user.uid
            self.navigationController?.pushViewController(vc, animated: true)

        case 1:    //차단유저관리
            let vc = ManageBlockUsersViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 2:    //설정
            self.navigationController?.pushViewController(SettingViewController(), animated: true)
            
        case 3:    //피드백
            let vc = FeedBackViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:   //header(마이페이지)
            let vc = ProfileViewController()
            vc.myInformationData = self.myInformationData
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

//유저 정보 가져오기
extension HomeViewController {
    private func getUsereData(){
        if let user = Auth.auth().currentUser {
            
            db.collection("Users").document("\(user.uid)").getDocument { qs, error in
                if let e = error {
                    print("Error 유저 데이터 가져오기 실패 \(e)")
                }else{
                    guard let userData = qs?.data() else {return} //해당 도큐먼트 안에 데이터가 있는지 확인
                    
                    guard let userEmailData = user.email else{return} //유저 이메일
                    guard let userNameData = userData["myName"] as? String else{return} //유저 닉네임
                    guard let userLoginData = userData["login"] as? String else{return}
                    
                    self.myInformationData = MyInformationData(myEmail: userEmailData, loginInfo: userLoginData)
                    
                    UserDefaults.standard.set(userNameData, forKey: "myName")
                    
                    DispatchQueue.main.async {
                        self.setIntroduceText(name: userNameData)
                    }
                }
            }
        }else{
            self.setIntroduceText(name: "회원")
            self.myInformationData = .init(myEmail: "로그인이 필요합니다.", loginInfo: "")
            UserDefaults.standard.set("", forKey: "myName")
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

//추천 레시피에 올라올 레시피들 가져오기
extension HomeViewController {
    private func getPopularRecipeData() {
        CustomLoadingView.shared.startLoading()
        
        db.collection("전체보기").order(by: DataKeyWord.heartPeople, descending: true).limit(to: 5).addSnapshotListener { qs, error in
            if let e = error {
                print("Error 좋아요 레시피 가져오기 실패 : \(e)")
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                }
            }else{
                self.popularRecipeDataArray = []
                self.timer.invalidate() //timer 초기화. 중복 가능성 제거.
                
                guard let snapshotDocuments = qs?.documents else{return}
                
                for doc in snapshotDocuments{
                    let data = doc.data()   //도큐먼트 안에 데이터에 접근
                    
                    guard let foodNameData = data[DataKeyWord.foodName] as? String else{return}
                    guard let userNameData = data[DataKeyWord.userName] as? String else{return}
                    guard let heartPeopleData = data[DataKeyWord.heartPeople] as? [String] else{return}
                    guard let levelData = data[DataKeyWord.foodLevel] as? String else{return}
                    guard let timeData = data[DataKeyWord.foodTime] as? String else{return}
                    guard let urlData = data[DataKeyWord.url] as? [String] else{return}
                    
                    let findData = PopularRecipeDataModel(foodName: foodNameData, userName: userNameData, heartPeople: heartPeopleData, foodLevel: levelData, foodTime: timeData, url: urlData[0], documentID: doc.documentID)
                    
                    self.popularRecipeDataArray.append(findData)
                }
                
                DispatchQueue.main.async {
                    CustomLoadingView.shared.stopLoading()
                    self.popularCollectionView.reloadData()
                    self.popularCollectionView.scrollToItem(at: IndexPath(item: 20, section: 0),
                                                        at: .centeredHorizontally,
                                                        animated: false)
                    self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.moveToNextCell), userInfo: nil, repeats: true)
                }
            }
        }
    }
}


