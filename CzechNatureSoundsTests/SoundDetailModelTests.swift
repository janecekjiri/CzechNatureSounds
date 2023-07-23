//
//  SoundDetailModelTests.swift
//  CzechNatureSoundsTests
//
//  Created by Jiri Janecek on 22.07.2023.
//  Copyright © 2023 Jiri Janecek. All rights reserved.
//

@testable import Czech_Nature_Sounds
import XCTest

final class SoundDetailModelTests: XCTestCase {
    
    private let soundListModel = SoundsListModel()
    private var soundDetailModel: SoundDetailModel!
    
    override func setUp() {
        super.setUp()
        guard
            let soundModel = self.soundListModel.soundModels.first,
            let audioPlayer = self.soundListModel.makeAudioPlayer(for: soundModel)
        else { return }
        
        self.soundDetailModel = SoundDetailModel(soundModel: soundModel, audioPlayer: audioPlayer)
    }
    
    override func tearDown() {
        self.soundDetailModel = nil
        super.tearDown()
    }
    
    func testSoundDetailModel_whenInitialized_notStartedState() {
        XCTAssertEqual(self.soundDetailModel.playerState, PlayerStateEnum.notStarted)
    }
    
    func testSoundDetailModel_whenCalledPlayMethod_playingState() {
        self.soundDetailModel.play()
        XCTAssertEqual(self.soundDetailModel.playerState, PlayerStateEnum.playing)
    }
    
    func testSoundDetailModel_whenCalledPauseMethod_pausedState() {
        self.soundDetailModel.play()
        self.soundDetailModel.pause()
        XCTAssertEqual(self.soundDetailModel.playerState, PlayerStateEnum.paused)
    }
    
    func testSoundDetailModel_whenCalledResumeMethod_resumedState() {
        self.soundDetailModel.play()
        self.soundDetailModel.pause()
        self.soundDetailModel.resume()
        XCTAssertEqual(self.soundDetailModel.playerState, PlayerStateEnum.resumed)
    }
    
    func testSoundDetailModel_whenCalledStopMethod_notStartedState() {
        self.soundDetailModel.play()
        self.soundDetailModel.stop(isStoppedByUser: false)
        XCTAssertEqual(self.soundDetailModel.playerState, PlayerStateEnum.notStarted)
    }
}
