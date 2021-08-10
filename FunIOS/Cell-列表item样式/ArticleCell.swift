//
//  ArticleCell.swift
//  FunIOS
//
//  Created by redli on 2021/7/22.
//

import UIKit
import SnapKitExtend

class ArticleCell: BaseTableViewCell {
    
    private lazy var  labelAuthor = UILabel().then({ (attr) in
        attr.text = "author"
        attr.font = UIFont.systemFont(ofSize: 12)
        attr.numberOfLines = 0 //相当于不限制行数
        attr.lineBreakMode = .byWordWrapping
        attr.sizeToFit()
        attr.backgroundColor = UIColor.white
    })
    
    private lazy var  labelTime = UILabel().then({ (attr) in
        attr.text = "Time"
        attr.textColor = .gray
        attr.font = UIFont.systemFont(ofSize: 12)
        attr.numberOfLines = 0 //相当于不限制行数
        attr.lineBreakMode = .byWordWrapping
        attr.sizeToFit()
        attr.backgroundColor = UIColor.white
    })
    
    
    private lazy var labelTitle: UILabel = UILabel().then {(attr) in
        attr.text = "Titile"
        attr.textColor = .black
        attr.font = UIFont.systemFont(ofSize: 14)
        attr.numberOfLines = 2 //相当于不限制行数
        attr.lineBreakMode = .byWordWrapping
        attr.sizeToFit()
        attr.backgroundColor = UIColor.white
    }
    
    
    private lazy var labelChapterName = UILabel().then({(attr) in
        attr.text = "ChapterName"
        attr.textColor = .gray
        attr.font = UIFont.systemFont(ofSize: 10)
        attr.numberOfLines = 0 //相当于不限制行数
        attr.lineBreakMode = .byWordWrapping
        attr.sizeToFit()
        attr.backgroundColor = UIColor.white
    })
    
    private lazy var  labelSuperChapterName = UILabel().then({(attr) in
        attr.text = "SuperChapterName"
        attr.textColor = .gray
        attr.font = UIFont.systemFont(ofSize: 10)
        attr.numberOfLines = 0 //相当于不限制行数
        attr.lineBreakMode = .byWordWrapping
        attr.sizeToFit()
        attr.backgroundColor = UIColor.white
    })
    
    var model: ArticleItemModel?{
        didSet {
            guard model == nil else {
                labelAuthor.text = (model?.author.isEmpty)! ? model?.shareUser : model?.author
                labelTime.text = model?.niceShareDate
                labelTitle.text = model?.title
                labelSuperChapterName.text = model?.superChapterName
                labelChapterName.text = " · \(model?.chapterName ?? "")"
                return
            }
        }
    }
    
    
    override func configUI() {
        contentView.addSubview(labelAuthor)
        labelAuthor.snp.makeConstraints {(make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            
        }

        contentView.addSubview(labelTime)
        labelTime.snp.makeConstraints({(make) in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        })

        contentView.addSubview(labelTitle)
        labelTitle.snp.makeConstraints({(make) in
            make.top.equalTo(labelAuthor.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            
        })
        
        contentView.addSubview(labelSuperChapterName)
        labelSuperChapterName.snp.makeConstraints {(make) in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(labelTitle.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }

        contentView.addSubview(labelChapterName)
        labelChapterName.snp.makeConstraints({(make) in
            make.leading.equalTo(labelSuperChapterName.snp.trailing)
            make.top.equalTo(labelTitle.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        })
    }
}
