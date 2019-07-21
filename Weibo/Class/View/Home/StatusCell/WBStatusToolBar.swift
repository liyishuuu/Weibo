//
//  WBStatusToolBar.swift
//  Weibo
//
//  Created by liyishu on 2019/7/14.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class WBStatusToolBar: UIView {
    var viewModel: WBStatusViewModel? {
        didSet {
            retweetedButton.setTitle(viewModel?.retweetedStr, for: [])
            commentButton.setTitle(viewModel?.commentStr, for: [])
            likeButton.setTitle(viewModel?.likeStr, for: [])
        }
    }

    /** 转发按钮 */
    @IBOutlet weak var retweetedButton: UIButton!
    /** 评论按钮 */
    @IBOutlet weak var commentButton: UIButton!
    /** 喜欢按钮 */
    @IBOutlet weak var likeButton: UIButton!
}