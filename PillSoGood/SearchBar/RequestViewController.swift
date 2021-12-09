//
//  RequestViewController.swift
//  PillSoGood
//
//  Created by 노수빈 on 2021/11/26.
//

import UIKit
import PhotosUI
import Alamofire

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
    
    @IBAction func sendRequest(_ sender: Any) {
        let url = URL(string: "http://ec2-13-125-182-91.ap-northeast-2.compute.amazonaws.com:8000/api/request_supplement/")
        let URL : Alamofire.URLConvertible = url!
        
        
        let header : HTTPHeaders = ["Content-Type" : "multipart/form-data"]
        
        let parameters: [String:Any] = ["supplement" : supplementName.text! as String, "company" : company.text! as String]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let image = self.selectImageView.image?.pngData() {
                multipartFormData.append(image, withName: "image", fileName: "\(image).png", mimeType: "image/png")
            }
        }, to: URL, usingThreshold: UInt64.init(), method: .post, headers: header).responseJSON { response in
            guard let statusCode = response.response?.statusCode, statusCode == 201 else { return }
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "제품등록 요청 완료", message: "요청이 완료되었습니다! 최대한 빠르게 반영해드리겠습니다 :)", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
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
