//
//  ContentView.swift
//  MyCamera
//
//  Created by 河田佳之 on 2024/03/07.
//

import SwiftUI

struct ContentView: View {
    // 撮影した写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    // 撮影画面（sheet）の開閉状態を管理
    @State var isShowSheet = false
    // シェア画面（sheet）の開閉状態を管理
    @State var isShowActivity = false
    
    // フォトライブラリーかカメラかを保持する状態変数
    @State var isPhonelibrary = false
    // 選択画面（ActionSheet）のsheet開閉状態を管理
    @State var isShowAction = false
    
    var body: some View {
        VStack {
            Spacer()
            // 撮影した写真があるとき
            if let unwrapCaptureImage = captureImage {
                // 撮影写真を表示
                Image(uiImage: unwrapCaptureImage)
                    // リサイズ
                    .resizable()
                    // アスペクト比（縦横比）を維持して画面内
                    .aspectRatio(contentMode: .fit)
            }
            Spacer()
            
            // 「カメラを起動する」ボタン
            Button {
                // カメラが使用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラは利用できます")
                    //isShowSheet = true
                    isShowAction = true
                } else {
                    print("カメラは利用できません")
                }
            } label: {
                // テキスト表示
                Text("カメラを起動する")
                    // 横幅いっぱい
                    .frame(maxWidth: .infinity)
                    // 高さ50ポイントを指定
                    .frame(height: 50)
                    // 文字列をセンタリング指定
                    .multilineTextAlignment(.center)
                    // 背景を青色に指定
                    .background(Color.blue)
                    // 文字色を白色に指定
                    .foregroundColor(Color.white)
            }
            // 上下左右に余白を追加
            .padding()
            // sheetを表示
            // isPresentedで指定した状態変数がtrueのとき実行
            .sheet(isPresented: $isShowSheet) {
                // フォトライブラリーが選択された
                if isPhonelibrary {
                    // PHPickerViewController（フォトライブラリー）を表示
                    PHPickerView(
                        isShowSheet: $isShowSheet,
                        captureImage: $captureImage)
                } else {
                    // UIImagePickerController（写真撮影）を表示
                    ImagePickerView(isShowSheet: $isShowSheet,
                                    captureImage: $captureImage)
                }
            }
            .actionSheet(isPresented: $isShowAction) {
                // ActionSheetを表示する
                ActionSheet(title: Text("確認"),
                            message: Text("選択してください"),
                            buttons: [
                                .default(Text("カメラ"), action: {
                                    // カメラを起動
                                    isPhonelibrary = false
                                    // カメラが利用可能かチェック
                                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                        print("カメラは利用できます")
                                        // カメラが使えるなら、isShowSheetをtrueにする
                                        isShowSheet = true
                                    } else {
                                        print("カメラは利用できません")
                                    }
                                }),
                                .default(Text("フォトライブラリー"), action: {
                                    // フォトライブラリーを選択
                                    isPhonelibrary = true
                                    // isShowSheetをtrue
                                    isShowSheet = true
                                }),
                                // キャンセル
                                .cancel()
                            ])
            }
            
            // 「SNSに投稿する」ボタン
            Button {
                // 撮影した写真があるときだけ
                // UIActivityViewController（シェア機能）を表示
                if let _ = captureImage {
                    isShowActivity = true
                }
            } label: {
                Text("SNSに投稿する")
                // 横幅いっぱい
                .frame(maxWidth: .infinity)
                // 高さ50ポイントを指定
                .frame(height: 50)
                // 文字列をセンタリング指定
                .multilineTextAlignment(.center)
                // 背景を青色に指定
                .background(Color.blue)
                // 文字色を白色に指定
                .foregroundColor(Color.white)
            }
            // 上下左右に余白を追加
            .padding()
            // sheetを表示
            // isPresentedで指定した状態変数がtrueのとき実行
            .sheet(isPresented: $isShowActivity) {
                // UIActivityViewController（シャア機能）を表示
                ActivityView(shareItems: [captureImage!])
            }
        }
    }
}

#Preview {
    ContentView()
}
