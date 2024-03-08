//
//  ImagePickerView.swift
//  MyCamera
//
//  Created by 河田佳之 on 2024/03/07.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    // UIImagePickerController（写真撮影）が表示されているかを管理
    @Binding var isShowSheet: Bool
    // 撮影した写真を格納する変数
    @Binding var captureImage: UIImage?
    
    // Coordinatorでコントローラのdelegateを管理
    class Coordinator: NSObject,
                      UINavigationControllerDelegate,
                      UIImagePickerControllerDelegate {
        // ImagePickerView型の定義を用意
        let parent: ImagePickerView
        
        // イニシャライザ
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        // 撮影が終わった時に呼ばれるdelegateメソッド、必ず必要
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // 撮影した写真をcaptureImageに保存
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.captureImage = originalImage
            }
            // sheetを閉じない
            parent.isShowSheet = true
        }
        // キャンセルボタンが選択された時に呼ばれる
        // delegateメソッド、必ず必要
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // sheetを閉じる
            parent.isShowSheet = false
        }
    }
    
    // Coordinatorを生成、SwiftUIによって自動的に呼びだし
    func makeCoordinator() -> Coordinator {
        // Coordinaterクラスのインスタンスを生成
        Coordinator(self)
    }
    
    // Viewを生成する時に実行
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ImagePickerView>) ->
        UIImagePickerController {
        
        // UIImagePickerControllerのインスタンスを生成
        let myImagePickerController = UIImagePickerController()
        // sourceTypeにcameraを設定
        myImagePickerController.sourceType = .camera
        // delegate設定
            myImagePickerController.delegate = context.coordinator
        // UIImagePickerControllerを返す
        return myImagePickerController
    }
    
    // Viewが更新された時に実行
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePickerView>) {
        // 処理なし
    }
}
