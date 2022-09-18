//
//  AttributesCustomFlowLayout.swift
//  MusicArtistsApp
//
//  Created by Raycho Kostadinov on 21.06.22.
//

import UIKit

private let separatorDecorationView = "separator"

final class AttributesCustomFlowLayout: UICollectionViewFlowLayout {

    override func awakeFromNib() {
        super.awakeFromNib()
        register(SeparatorView.self, forDecorationViewOfKind: separatorDecorationView)

        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.minimumLineSpacing = 25
        self.sectionInset = UIEdgeInsets(top: 0, left: 19, bottom: 0, right: 19)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect) ?? []

        var decorationAttributes: [UICollectionViewLayoutAttributes] = []

        // skip first cell
        for layoutAttribute in layoutAttributes where layoutAttribute.indexPath.item > 0 {
            let separatorAttribute = UICollectionViewLayoutAttributes(forDecorationViewOfKind: separatorDecorationView,
                                                                      with: layoutAttribute.indexPath)
            let cellFrame = layoutAttribute.frame
            guard let midY = collectionView?.frame.midY else {
                fatalError("AttributesSeparator error!")
            }
            separatorAttribute.frame = CGRect(x: cellFrame.origin.x - 8,
                                              y: midY / 2,
                                              width: 0.7,
                                              height: 40)
            separatorAttribute.zIndex = Int.max
            decorationAttributes.append(separatorAttribute)
        }

        return layoutAttributes + decorationAttributes
    }

}

private final class SeparatorView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        self.frame = layoutAttributes.frame
    }
}
