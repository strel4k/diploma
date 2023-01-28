//
//  ViewProtocols.swift
//  Diplom2
//
//  Created by Mac on 07.01.2023.
//

import Foundation

//protocol HideKeyboard {
//    func hideKeyboard()
//}

protocol TextEdit {
    func editText()
}

//protocol TextValidate {
//    func validateText() -> Bool
//}

protocol ImageViewTap {
    func imageViewTap()
}

protocol ButtonTap {
    func buttonTap()
}

protocol SimpleButtonTap {
    func simpleButtonTap()
}

protocol  ShowPhoto {
    func showPhotoController()
    func showSelectedPhoto(number: Int)
}

