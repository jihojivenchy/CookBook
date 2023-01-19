//
//  SelectedImageViewController.swift
//  CookingProject
//
//  Created by 엄지호 on 2022/08/21.
//

import UIKit
import SnapKit
import Firebase
import Kingfisher

class SelectedImageViewController: UIViewController {

//MARK: - Properties
    
    var urlDataArray : [String] = []
    var indexPathNumber = 0
    
    private lazy var detailCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: view.frame.width, height: 450)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .black
        cv.indicatorStyle = .white
        
        
        return cv
    }()
    
    private lazy var dismissButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
        button.tintColor = .white
        
        return button
    }()
    
    private let indexLabel = UILabel()
    

//MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailCollectionView.isPagingEnabled = false
        navigationController?.navigationBar.isHidden = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewChange()
        detailCollectionView.register(DetailImageCollectionViewCell.self, forCellWithReuseIdentifier: DetailImageCollectionViewCell.identifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToIndex()
    }
    
//        override func viewDidDisappear(_ animated: Bool) {
//            let cache = ImageCache.default
//    
//            cache.clearMemoryCache()
//            cache.clearDiskCache(completion: nil)
//    
//            cache.cleanExpiredMemoryCache()
//            cache.cleanExpiredDiskCache(completion: nil)
//        }
    
//MARK: - View Method
    
    private func viewChange() {
        view.backgroundColor = .black
        
        view.addSubview(detailCollectionView)
        detailCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(view)
            make.left.right.equalTo(view)
            make.height.equalTo(450)
        }
        
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaInsets).inset(20)
            make.left.equalTo(view).inset(10)
            make.width.height.equalTo(50)
        }
        
        view.addSubview(indexLabel)
        indexLabel.textColor = .white
        indexLabel.font = .systemFont(ofSize: 16)
        indexLabel.textAlignment = .center
        indexLabel.snp.makeConstraints { make in
            make.top.equalTo(detailCollectionView.snp_bottomMargin).offset(30)
            make.centerX.equalTo(detailCollectionView)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
    }
    
    private func scrollToIndex() {
        detailCollectionView.scrollToItem(at: IndexPath(item: indexPathNumber, section: 0), at: .centeredHorizontally, animated: true)
        detailCollectionView.isPagingEnabled = true
    }
    
    @objc private func dismissButtonPressed(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func imageUploadFail() {
        let alert = UIAlertController(title: "이미지 다운로드 실패", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    


}

//MARK: - Extension
extension SelectedImageViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCollectionViewCell.identifier, for: indexPath) as! DetailImageCollectionViewCell
        
        guard let url = URL(string: urlDataArray[indexPath.row]) else{return cell}
        
//        let processor = DownsamplingImageProcessor(size: CGSize(width: collectionView.frame.width, height: collectionView.frame.height )) //이미지뷰 크기에 맞게 이미지다운샘플링
        
//        let processor = ResizingImageProcessor(referenceSize: CGSize(width: collectionView.frame.width, height: collectionView.frame.height))
       
        cell.imageViewer.kf.indicatorType = .activity
        cell.imageViewer.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7)), .cacheOriginalImage ]) { result in
            
            switch result{
            case .success(let value):
                print("Done : \(value)")
            case .failure(_):
                self.imageUploadFail() //image upload에 실패했을 때
            }
        }
        
        return cell
    }
    
    
}

extension SelectedImageViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.indexLabel.text = "\(indexPath.row + 1) / \(urlDataArray.count)"
        
    }
    
    //퍼포먼스 상승
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCollectionViewCell.identifier, for: indexPath) as! DetailImageCollectionViewCell
        
        cell.imageViewer.kf.cancelDownloadTask()
    }
    
}


extension SelectedImageViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    //section 사이의 공간을 제거
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
}
