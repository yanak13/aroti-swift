//
//  SoundManager.swift
//  Aroti
//
//  Sound manager for optional audio feedback
//  Respects system sound settings and provides museum installation aesthetic
//

import AVFoundation
import UIKit

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    private var audioEngine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?
    
    private var isSoundEnabled: Bool {
        // Check if device is not in silent mode
        // In production, you might want to check actual ringer state
        return true  // Default to enabled
    }
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            // Use ambient category so it respects silent mode
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    /// Play a single airy tonal swell during assembly
    /// - Parameters:
    ///   - duration: Duration of the sound in seconds (should match assembly duration)
    ///   - volume: Volume level (0.0 to 1.0), defaults to 0.25 for subtlety
    func playAssemblySwell(duration: Double = 1.75, volume: Float = 0.25) {
        guard isSoundEnabled else { return }
        
        // Stop any existing sound
        stop()
        
        // Create audio engine
        let engine = AVAudioEngine()
        let playerNode = AVAudioPlayerNode()
        
        engine.attach(playerNode)
        
        // Create audio format
        let sampleRate: Double = 44100
        let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)!
        
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
        
        // Generate airy tonal swell
        let frameCount = AVAudioFrameCount(sampleRate * duration)
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        buffer.frameLength = frameCount
        
        let frequency: Double = 220.0  // A3 note - warm, airy tone
        let channelData = buffer.floatChannelData![0]
        
        for i in 0..<Int(frameCount) {
            let time = Double(i) / sampleRate
            // Create a smooth swell envelope (sine wave from 0 to π)
            let envelope = sin(time * .pi / duration)
            // Generate sine wave with slight vibrato for airy quality
            let vibrato = sin(time * 4.0 * .pi) * 2.0  // Subtle vibrato
            let phase = 2.0 * .pi * (frequency + vibrato) * time
            let sample = sin(phase) * envelope * Double(volume)
            channelData[i] = Float(sample)
        }
        
        do {
            try engine.start()
            playerNode.scheduleBuffer(buffer, at: nil, options: [], completionHandler: {
                // Clean up after playback
                DispatchQueue.main.async {
                    self.stop()
                }
            })
            playerNode.play()
            
            self.audioEngine = engine
            self.playerNode = playerNode
        } catch {
            print("Failed to play assembly swell: \(error)")
        }
    }
    
    /// Stop any currently playing sound
    func stop() {
        playerNode?.stop()
        audioEngine?.stop()
        audioEngine = nil
        playerNode = nil
    }
}
