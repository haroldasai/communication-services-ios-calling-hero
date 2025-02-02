//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

class AudioDeviceSelectionDataSource: NSObject, BottomDrawerDataSource {

    // MARK: Properties

    private var audioDeviceOptions = [BottomDrawerItem]()
    private var dismissDrawer: () -> Void = {}
    var didSelectAudioDevice: () -> Void = {}
    // MARK: Initialization

    override init() {
        super.init()
        createAudioDeviceOptions()
    }

    // MARK: Private Functions

    private func createAudioDeviceOptions() {
        let audioDeviceTypes = AudioSessionManager.getAllAudioDeviceTypes()
        let currentAudioDeviceType = AudioSessionManager.getCurrentAudioDeviceType()

        for audioDeviceType in audioDeviceTypes {

            let accessoryImage = UIImage(named: "ic_fluent_checkmark_20_filled")!
            let image = UIImage(named: audioDeviceType.iconName)!
            let audioDeviceOption = BottomDrawerItem(avatar: image, title: audioDeviceType.name, accessoryImage: accessoryImage, enabled: audioDeviceType == currentAudioDeviceType)
            audioDeviceOptions.append(audioDeviceOption)
        }
    }

    // MARK: BottomDrawerDataSource events

    func setDismissDrawer(dismissDrawer: @escaping () -> Void) {
        self.dismissDrawer = dismissDrawer
    }

    // MARK: UITableViewDelegate events

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let audioDeviceType = AudioDeviceType(rawValue: audioDeviceOptions[indexPath.row].title)!
        AudioSessionManager.switchAudioDeviceType(audioDeviceType: audioDeviceType)
        didSelectAudioDevice()
        dismissDrawer()
    }

    // MARK: UITableViewDataSource events

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioDeviceOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BottomDrawerCellView", for: indexPath) as! BottomDrawerCellView
        let audioOption = audioDeviceOptions[indexPath.row]
        cell.updateCellView(cellViewModel: audioOption)

        return cell
    }
}
