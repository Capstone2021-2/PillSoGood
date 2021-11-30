//
//  RequestViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/26.
//

import UIKit
import PhotosUI

class RequestViewController: UIViewController {

    @IBOutlet weak var selectImageView: UIImageView! {
        didSet {
            selectImageView.isUserInteractionEnabled = true
            selectImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(checkPermission)))
        }
    }
    @IBOutlet weak var supplementName: UITextField!
    @IBOutlet weak var company: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func checkPermission() {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized || PHPhotoLibrary.authorizationStatus(for: .readWrite) == .limited {
            DispatchQueue.main.async {
                self.showGallery()
            }
        } else if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .denied {
            DispatchQueue.main.async {
                self.showAuthorizationDeniedAlert()
            }
        } else if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                self.checkPermission()
            }
        }
    }
    
    func showGallery() {
        let library = PHPhotoLibrary.shared()
        
        var configuration = PHPickerConfiguration(photoLibrary: library)
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    func showAuthorizationDeniedAlert() {
        let alert = UIAlertController(title: "앨범 접근 권한을 활성화 해주세요.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "설정으로 가기", style: .default, handler: { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    // 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension RequestViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        let identifier = results.compactMap(\.assetIdentifier)
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: identifier, options: nil)
        
        let imageManager = PHImageManager()
        let scale = UIScreen.main.scale
        let imageSize = CGSize(width: 200*scale, height: 200*scale)
        imageManager.requestImage(for: asset[0], targetSize: imageSize, contentMode: .aspectFill, options: nil) { image, info in
            self.selectImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
