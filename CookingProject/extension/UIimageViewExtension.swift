//
//  UIimageViewExtension.swift
//  CookingProject
//
//  Created by 엄지호 on 2023/02/03.
//

import Foundation
import Kingfisher
import FirebaseStorage

extension UIImageView {
    func setImage(with urlString: String, width: CGFloat, height: CGFloat) {
        self.kf.indicatorType = .activity
        let processor = DownsamplingImageProcessor(size: CGSize(width: width, height: height)) //이미지뷰 크기에 맞게 이미지다운샘플링
        let retry = DelayRetryStrategy(maxRetryCount: 1, retryInterval: .seconds(3)) //이미지 다운로드를 실패할 시 재실행
        
        let cache = ImageCache.default
        cache.retrieveImage(forKey: urlString,
                            options: [.scaleFactor(UIScreen.main.scale), .processor(processor), .transition(.fade(0.4)), .cacheOriginalImage, .retryStrategy(retry)]) { result in
            
            switch result {
            case .success(let cacheResult):
                
                if let image = cacheResult.image {
                    self.image = image
                    
                } else {
                    let storage = Storage.storage()
                    storage.reference(forURL: urlString).downloadURL { (url, error) in
                        if let error = error {
                            print("Error 저장고에서 사진 url가져오기 실패: \(error.localizedDescription)")
                            return
                        }else{
                            
                            guard let url = url else {return}
                            self.kf.setImage(with: url,
                                             placeholder: nil,
                                             options: [.scaleFactor(UIScreen.main.scale),
                                                       .processor(processor),
                                                       .transition(.fade(0.4)),
                                                       .cacheOriginalImage,
                                                       .retryStrategy(retry)])
                            
                        }
                    }
                }
                
            case .failure(let e):
                print("Error : \(e)")
            }
        }
    }
}
