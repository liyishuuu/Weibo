//
//  SwiftView.swift
//  MessageDialog
//
//  Created by liyishu on 2019/8/10.
//  Copyright © 2019年 Apple. All rights reserved.
//
import UIKit
import Foundation

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class MessageDialog: UIView {

    // 声明闭包，点击按钮传值
    typealias clickAlertClosure = (_ index: Int) -> Void
    // 把申明的闭包设置成属性
    var clickClosure: clickAlertClosure?
    // 为闭包设置调用函数
    func clickIndexClosure(_ closure: clickAlertClosure?){
        // 将函数指针赋值给myClosure闭包
        clickClosure = closure
    }

    // MARK: - 变量

    /** 左右外边距 */
    private var dialogMarginLeft: CGFloat = 20.0
    /** 左右内边距 */
    private var dialogPaddingLeft: CGFloat = 24.0
    /** 按钮外边距 */
    private var buttonMargin: CGFloat = 10
    /** 字体大小 */
    private var fontSize: CGFloat = 17.0
    /** 标题字体大小 */
    private var titleFontSize: CGFloat = 19.0
    /** 标题上下边距 */
    private var titleMargin: CGFloat = 15.0
    /** 按钮字体大小 */
    private var buttonFontSize: CGFloat = 18.0
    /** 弹框默认高度 */
    private var dialogDefaultHeight: CGFloat = 200.0
    /** 标题高度 */
    private var titleHeight: CGFloat = 25.0
    /** 按钮高度 */
    private var buttonHeight: CGFloat = 44.0
    /** View圆角 */
    private var dialogViewCorner: CGFloat = 9.0
    /** 按钮圆角 */
    private var buttonCorner: CGFloat = 3.0
    /** 背景透明度 */
    private var backgroundAlpha: CGFloat = 0.2

    // MARK: - 弹框控件

    /** 背景 */
    private var dialogView = UIView()
    /** 标题 */
    private var titleLable = UILabel()
    /** 内容 */
    private var contentLabel: UILabel? = UILabel()
    /** 滑动 */
    private var scrollView = UIScrollView()
    /** 取消按钮 */
    private let cancelButton = UIButton()
    /** 确定按钮 */
    private let confirmButton = UIButton()
    
    init(title: String?, message: String?, cancelButtonTitle: String?, confirmButtonTitle: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        self.createDialog(message: message!)
        self.titleLable.text = title
        self.contentLabel?.text = message
        self.cancelButton.setTitle(cancelButtonTitle, for: UIControl.State())
        self.confirmButton.setTitle(confirmButtonTitle, for: UIControl.State())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /*
     - 创建MessageDialog

     - para message: 消息文言
     */
    func createDialog(message: String) {
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.backgroundColor = UIColor.black.withAlphaComponent(backgroundAlpha)
        let sizeHeight = (message.getHeightForComment(
            fontSize: fontSize,
            width: SCREEN_WIDTH - 2*dialogMarginLeft - 2*dialogPaddingLeft) + 130) > dialogDefaultHeight ?
            message.getHeightForComment(fontSize: fontSize,
                                        width: SCREEN_WIDTH - 2*dialogMarginLeft - 2*dialogPaddingLeft) + 130 :
                                        dialogDefaultHeight
        // 白底
        dialogView.frame = CGRect(x: dialogMarginLeft,
                                  y: SCREEN_HEIGHT/2 - dialogDefaultHeight/2,
                                  width: SCREEN_WIDTH - 2*dialogMarginLeft,
                                  height: SCREEN_HEIGHT - sizeHeight < 40 ? SCREEN_HEIGHT - 40 : sizeHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = dialogViewCorner
        dialogView.clipsToBounds = true
        dialogView.center = self.center
        self.addSubview(dialogView)
        let dialogWidth = dialogView.frame.size.width
        let dialogHeight = dialogView.frame.size.height

        // 标题
        titleLable.frame = CGRect(x: 0, y: titleMargin, width: dialogWidth, height: titleHeight)
        titleLable.textColor = UIColor.black
        titleLable.font = UIFont.systemFont(ofSize: titleFontSize)
        titleLable.textAlignment = .center
        dialogView.addSubview(titleLable)

        // 滑动scroll
        let contentHeight = message.getHeightForComment(fontSize: fontSize,
                                                        width: SCREEN_WIDTH - 2*dialogMarginLeft - 2*dialogPaddingLeft)
        scrollView.frame = CGRect(x: dialogPaddingLeft,
                                  y: titleHeight + 2*titleMargin,
                                  width: dialogWidth - 2*dialogPaddingLeft,
                                  height: dialogHeight - 130)
        scrollView.isScrollEnabled = SCREEN_HEIGHT - dialogView.frame.size.height == 40 ? true: false
        scrollView.contentSize = CGSize.init(width: 0,
                                             height: contentHeight)
        dialogView.addSubview(scrollView)

        // 内容
        contentLabel?.frame = CGRect(x: 0,
                                     y: 0,
                                     width: dialogWidth - 2*dialogPaddingLeft,
                                     height: contentHeight)
        contentLabel?.numberOfLines = 0
        contentLabel?.textAlignment = .center
        contentLabel?.textColor = UIColor.black
        contentLabel?.font = UIFont.systemFont(ofSize: fontSize)
        scrollView.addSubview(contentLabel!)

        // 取消按钮
        let buttonWidth = (dialogWidth - 3*buttonMargin) / 2
        cancelButton.frame = CGRect(x: buttonMargin,
                                    y: dialogHeight - buttonMargin - buttonHeight,
                                    width: buttonWidth,
                                    height: buttonHeight)
        cancelButton.backgroundColor = UIColor.gray
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
        cancelButton.layer.cornerRadius = buttonCorner
        cancelButton.clipsToBounds = true
        cancelButton.tag = 1
        cancelButton.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        dialogView.addSubview(cancelButton)

        // 确认按钮
        confirmButton.frame = CGRect(x: buttonWidth + 2*buttonMargin,
                                     y: dialogHeight - buttonMargin - buttonHeight,
                                     width: buttonWidth,
                                     height: buttonHeight)
        confirmButton.backgroundColor = UIColor.init(hexString: "#1E90FF")
        confirmButton.setTitleColor(UIColor.white, for: UIControl.State())
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
        confirmButton.layer.cornerRadius = buttonCorner
        confirmButton.clipsToBounds = true
        confirmButton.tag = 2
        confirmButton.addTarget(self, action: #selector(clickBtnAction(_:)), for: .touchUpInside)
        dialogView.addSubview(confirmButton)
    }
    
    // MARK: 按键的对应的方法
    @objc func clickBtnAction(_ sender: UIButton) {
        if (clickClosure != nil) {
            clickClosure!(sender.tag)
        }
        dismiss()
    }

    // MARK: 消失
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.dialogView.alpha = 0
            self.alpha = 0
        }, completion: { (finish) -> Void in
            if finish {
                self.removeFromSuperview()
            }
        })
    }

    /** 指定视图实现方法 */
    func show() {
        let wind = UIApplication.shared.keyWindow
        self.alpha = 0
        wind?.addSubview(self)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.alpha = 1
        })
    }
}
