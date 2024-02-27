//
//  ViewController.swift
//  UIKitMarathon_D9
//
//  Created by Maksim Vaselkov on 25.02.2024.
//

import UIKit

class ViewController: UIViewController {

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 250, height: 400)
        layout.sectionInsetReference = .fromLayoutMargins
        return layout
    }()

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Collection"
        navigationController?.navigationBar.prefersLargeTitles = true

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.dataSource = dataSource
        collectionView.delegate = self

        configCollectionView()
    }

    private lazy var data: [String] = {
        var data: [String] = []

        for i in 1...10 {
            data.append("\(i)")
        }

        return data
    }()

    private lazy var dataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)

        cell.backgroundColor = .systemGray6
        cell.layer.cornerRadius = 20
        cell.layer.cornerCurve = .continuous
        cell.clipsToBounds = true

        return cell
    }

    override func viewWillLayoutSubviews() {
        view.addSubview(collectionView)

        collectionView.frame = view.bounds
    }

    private func configCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()

        snapshot.appendSections(["First"])
        snapshot.appendItems(data, toSection: "First")

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let target = targetContentOffset.pointee
        let center = CGPoint(x: target.x + collectionView.bounds.width / 2, y: target.y + collectionView.bounds.height / 2)

        guard let indexPath = collectionView.indexPathForItem(at: center) else { return }
        guard let attributes = collectionView.layoutAttributesForItem(at: indexPath) else { return }

        let insets = collectionView.contentInset
        let itemSize = attributes.frame.size
        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumLineSpacing ?? 0
        let newX = round((target.x - insets.left) / (itemSize.width + spacing)) * (itemSize.width + spacing) + insets.left

        targetContentOffset.pointee = CGPoint(x: newX, y: target.y)
    }
}
