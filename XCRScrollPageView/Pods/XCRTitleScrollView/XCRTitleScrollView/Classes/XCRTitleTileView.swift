//
//  XCRTitleTileView.swift
//  XCRTitleScrollView
//
//  Created by 胡晓玲 on 2017/12/8.
//

import UIKit

/// 平铺标题视图
public class XCRTitleTileView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - Property
    private var collectionViewLayout: UICollectionViewLayout
    private var collectionView: UICollectionView!
    public var titles: [String] = [] {
        didSet {
            UIView.animate(withDuration: 0, animations: {
                self.collectionView.reloadData()
            }) { (_) in
                guard let selectedIndex = self.selectedIndex else { return }
                let newIndexPath = IndexPath(item: selectedIndex, section: 0)
                let newCell = self.collectionView.cellForItem(at: newIndexPath) as? XCRTitleTileCell
                newCell?.hasSelected = true
            }
        }
    }
    public var selectedIndex: Int? {
        didSet {
            guard let selectedIndex = selectedIndex else { return }
            if titles.count <= selectedIndex || oldValue == selectedIndex {
                return
            }
            let oldIndexPath = IndexPath(item: oldValue ?? 0, section: 0)
            let oldCell = collectionView.cellForItem(at: oldIndexPath) as? XCRTitleTileCell
            oldCell?.hasSelected = false
            let newIndexPath = IndexPath(item: selectedIndex, section: 0)
            let newCell = collectionView.cellForItem(at: newIndexPath) as? XCRTitleTileCell
            newCell?.hasSelected = true
        }
    }
    public var handleSelect: ((_ index: Int) -> Void)?

    // MARK: - Initialize
    public init(collectionViewLayout: UICollectionViewLayout) {
        self.collectionViewLayout = collectionViewLayout
        super.init(frame: CGRect.zero)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.scrollsToTop = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(XCRTitleTileCell.self, forCellWithReuseIdentifier: XCRTitleTileCell.identifier)

        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XCRTitleTileCell.identifier, for: indexPath) as! XCRTitleTileCell
        cell.titleLabel.text = titles[indexPath.item]
        return cell
    }

    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        handleSelect?(selectedIndex ?? 0)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
