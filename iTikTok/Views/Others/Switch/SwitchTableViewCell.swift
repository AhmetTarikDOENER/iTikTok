//
//  SwitchTableViewCell.swift
//  iTikTok
//
//  Created by Ahmet Tarik DÖNER on 8.02.2024.
//

import UIKit

protocol SwitchTableViewCellDelegate: AnyObject {
    func switchTableViewCell(_ cell: SwitchTableViewCell, didUpdateSwitchTo isOn: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    
    static let identifier = "SwitchTableViewCell"
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        
        return label
    }()
    
    private let _switch: UISwitch = {
        let _switch = UISwitch()
        _switch.onTintColor = .systemBlue
        _switch.isOn = UserDefaults.standard.bool(forKey: "save_video")
        
        return _switch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        selectionStyle = .none
        contentView.addSubviews(label, _switch)
        _switch.addTarget(self, action: #selector(didChangeSwitchValue(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(
            x: 20,
            y: 0,
            width: label.width,
            height: contentView.height
        )
        _switch.sizeToFit()
        _switch.frame = CGRect(
            x: contentView.width - _switch.width - 10,
            y: 6,
            width: _switch.width,
            height: _switch.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    @objc func didChangeSwitchValue(_ sender: UISwitch) {
        delegate?.switchTableViewCell(self, didUpdateSwitchTo: sender.isOn)
    }
    
    func configure(with viewModel: SwitchCellViewModel) {
        label.text = viewModel.title
        _switch.isOn = viewModel.isOn
    }
}
