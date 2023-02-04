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
    private var viewControllers : Array<UIViewController> = []
    
    var defaltPageNumber = 0
    
    private lazy var backButton : UIBarButtonItem = {
        let sb = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        return sb
    }()
    
    private let categoryTitleList = ["전체보기","한 식", "중 식", "양 식", "일 식", "간 식", "채 식", "퓨 전", "분 식", "안 주"]
    
//MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        naviBarAppearance()
        
        tabBarController?.tabBar.isHidden = true
        
        view.backgroundColor = .white
        
        let vc1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AllViewController") as! AllViewController
        let vc2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "KoreaViewController") as! KoreaViewController
        let vc3 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChinaViewController") as! ChinaViewController
        let vc4 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AViewController") as! AViewController
        let vc5 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JViewController") as! JViewController
        let vc6 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SnakViewController") as! SnakViewController
        let vc7 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VeViewController") as! VeViewController
        let vc8 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FuViewController") as! FuViewController
        let vc9 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SFViewController") as! SFViewController
        let vc10 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SojuViewController") as! SojuViewController
        
        viewControllers.append(vc1)
        viewControllers.append(vc2)
        viewControllers.append(vc3)
        viewControllers.append(vc4)
        viewControllers.append(vc5)
        viewControllers.append(vc6)
        viewControllers.append(vc7)
        viewControllers.append(vc8)
        viewControllers.append(vc9)
        viewControllers.append(vc10)
                    
        self.dataSource = self
        
        setBar()
        
    }
    

    
//MARK: - ViewMethod
    private func naviBarAppearance(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = backButton
    }
    
    private func setBar() {
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap //Customize
        
        // Add to view
        addBar(bar, dataSource: self, at: .top)
        
        bar.backgroundView.style = .blur(style: .light) //버튼 백그라운드 스타일
        bar.layout.alignment = .centerDistributed // .center시 선택된 탭이 가운데로 오게 됨.
        bar.layout.interButtonSpacing = 50 //버튼들의 간격설정
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 20.0) //안에 전체 버튼의 제약조건
        
        
        bar.buttons.customize { (button) in
            button.tintColor = .lightGray
            button.selectedTintColor = .customSignature
            button.font = UIFont(name: KeyWord.CustomFont, size: 15) ?? .systemFont(ofSize: 15)
            button.selectedFont = UIFont(name: KeyWord.CustomFontMedium, size: 17) ?? .systemFont(ofSize: 17)
        }
        
        bar.indicator.tintColor = .customPink2
        bar.indicator.overscrollBehavior = .compress
        
        
    }
    
//MARK: - ButtonMethod
    
}

//MARK: - Extension

extension ReadViewController : PageboyViewControllerDataSource, TMBarDataSource {

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
        let item = TMBarItem(title: "")
        item.title = categoryTitleList[index]
        
        
        return item
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
        
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        
        
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        
        return .at(index: defaltPageNumber)
    }
    
}
