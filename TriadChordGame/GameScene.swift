//
//  GameScene.swift
//  TriadChordGame
//
//  Created by Dhil Khairan Badjiser on 19/05/23.
//


import SwiftUI
import SpriteKit

class ScoreManager {
    static let shared = ScoreManager()
    
    var score: Int = 0
    
    private init() {}
}

// Create a SwiftUI view for the GUI
struct CustomGUIView: View {
    var body: some View {
        VStack {
            Text("Correct Answer!")
                .font(.largeTitle)
                .foregroundColor(.green)
            Image("HUD")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Characters
    var Character_1 = SKSpriteNode()
    var Character_2 = SKSpriteNode()
    var Character_3 = SKSpriteNode()
    
    // Note variables
    var character1Note: String?
    var character2Note: String?
    var character3Note: String?
    
    //Tilemap
    var tileMap: SKTileMapNode = SKTileMapNode()
    var pianoMap: SKTileMapNode = SKTileMapNode()
    var floorMap: SKTileMapNode = SKTileMapNode()
    
    //Test
    var floorTileMap: SKTileMapNode!
    var pianoTileMap: SKTileMapNode!
    
    //Notes Tilemap
    
    //1st Octave
    var Notes_C: SKTileMapNode!
    var Notes_CS: SKTileMapNode!
    var Notes_D: SKTileMapNode!
    var Notes_DS: SKTileMapNode!
    var Notes_E: SKTileMapNode!
    var Notes_F: SKTileMapNode!
    var Notes_FS: SKTileMapNode!
    var Notes_G: SKTileMapNode!
    var Notes_GS: SKTileMapNode!
    var Notes_A: SKTileMapNode!
    var Notes_AS: SKTileMapNode!
    var Notes_B: SKTileMapNode!
    
    //2nd Octave
    var Notes_C2: SKTileMapNode!
    var Notes_CS2: SKTileMapNode!
    var Notes_D2: SKTileMapNode!
    var Notes_DS2: SKTileMapNode!
    var Notes_E2: SKTileMapNode!
    var Notes_F2: SKTileMapNode!
    var Notes_FS2: SKTileMapNode!
    var Notes_G2: SKTileMapNode!
    var Notes_GS2: SKTileMapNode!
    var Notes_A2: SKTileMapNode!
    var Notes_AS2: SKTileMapNode!
    var Notes_B2: SKTileMapNode!
    
    //Note sound
    var noteSounds: [String: SKAction] = [:]
    
    //Level
    var currentLevel = 1
    
    //Generated chord
    var hasGeneratedChord = false
    var generatedChord: [String] = []
    
    //Chord Label
    var chordNameLabel: SKLabelNode!
    
    //Pop up Label
    var popUpLabel: SKLabelNode!
    
    //Score
    var scoreLabel: SKLabelNode!
    
    // Add a boolean property to track if the answer is correct
    var isAnswerCorrect = false
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        //Select level
        setupLevel(level: currentLevel)
        
        //1st Octave
        Notes_C = childNode(withName: "Note_C") as? SKTileMapNode
        Notes_CS = childNode(withName: "Note_C#") as? SKTileMapNode
        Notes_D = childNode(withName: "Note_D") as? SKTileMapNode
        Notes_DS = childNode(withName: "Note_D#") as? SKTileMapNode
        Notes_E = childNode(withName: "Note_E") as? SKTileMapNode
        Notes_F = childNode(withName: "Note_F") as? SKTileMapNode
        Notes_FS = childNode(withName: "Note_F#") as? SKTileMapNode
        Notes_G = childNode(withName: "Note_G") as? SKTileMapNode
        Notes_GS = childNode(withName: "Note_G#") as? SKTileMapNode
        Notes_A = childNode(withName: "Note_A") as? SKTileMapNode
        Notes_AS = childNode(withName: "Note_A#") as? SKTileMapNode
        Notes_B = childNode(withName: "Note_B") as? SKTileMapNode
        
        //2nd Octave
        Notes_C2 = childNode(withName: "Note_C2") as? SKTileMapNode
        Notes_CS2 = childNode(withName: "Note_C#2") as? SKTileMapNode
        Notes_D2 = childNode(withName: "Note_D2") as? SKTileMapNode
        Notes_DS2 = childNode(withName: "Note_D#2") as? SKTileMapNode
        Notes_E2 = childNode(withName: "Note_E2") as? SKTileMapNode
        Notes_F2 = childNode(withName: "Note_F2") as? SKTileMapNode
        Notes_FS2 = childNode(withName: "Note_F#2") as? SKTileMapNode
        Notes_G2 = childNode(withName: "Note_G2") as? SKTileMapNode
        Notes_GS2 = childNode(withName: "Note_G#2") as? SKTileMapNode
        Notes_A2 = childNode(withName: "Note_A2") as? SKTileMapNode
        Notes_AS2 = childNode(withName: "Note_A#2") as? SKTileMapNode
        Notes_B2 = childNode(withName: "Note_B2") as? SKTileMapNode
        
        let fontURL = Bundle.main.url(forResource: "Minecraft", withExtension: "ttf")
                CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        
        if !hasGeneratedChord {
            let generatedData = generateRandomChord()
            generatedChord = generatedData.chord
            hasGeneratedChord = true
            let chordName = generatedData.name
            
            // Create and configure the chord name label
            chordNameLabel = SKLabelNode(fontNamed: "Minecraft")
            chordNameLabel.text = chordName
            chordNameLabel.fontSize = 28
            chordNameLabel.position = CGPoint(x: self.frame.midX, y: self.frame.maxY - 50)
            addChild(chordNameLabel)
        }
        
        // Create the button
                let button = SKLabelNode(fontNamed: "Minecraft")
                button.text = "SUBMIT"
                button.fontSize = 30
                button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 170)
                button.name = "checkButton"
                addChild(button)
        
        // Create the score label
                scoreLabel = SKLabelNode(fontNamed: "Minecraft")
                scoreLabel.text = "Score: \(ScoreManager.shared.score)"
                scoreLabel.fontSize = 24
                scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 310)
                addChild(scoreLabel)
        
        loadNoteSounds()
        
        // Create the pop-up label
                popUpLabel = SKLabelNode(fontNamed: "Minecraft")
                popUpLabel.text = "Correct Chord!"
                popUpLabel.fontSize = 36
                popUpLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                popUpLabel.isHidden = true
                addChild(popUpLabel)
        
    }
    
    
    
    
    //Level setup
    func setupLevel(level: Int){
        switch level {
        case 1:
            addCharacters()
            
        case 2:
            addCharacters()
            
        case 3:
            addCharacters()
        default:
            break
        }
    }
    
    func loadNoteSounds() {
        // Load and assign the sound actions for each note
        noteSounds["C"] = SKAction.playSoundFileNamed("C_1.m4a", waitForCompletion: false)
        noteSounds["C#"] = SKAction.playSoundFileNamed("C#_1.m4a", waitForCompletion: false)
        noteSounds["D"] = SKAction.playSoundFileNamed("D_1.m4a", waitForCompletion: false)
        noteSounds["D#"] = SKAction.playSoundFileNamed("D#_1.m4a", waitForCompletion: false)
        noteSounds["E"] = SKAction.playSoundFileNamed("E_1.m4a", waitForCompletion: false)
        noteSounds["F"] = SKAction.playSoundFileNamed("F_1.m4a", waitForCompletion: false)
        noteSounds["F#"] = SKAction.playSoundFileNamed("F#_1.m4a", waitForCompletion: false)
        noteSounds["G"] = SKAction.playSoundFileNamed("G_1.m4a", waitForCompletion: false)
        noteSounds["G#"] = SKAction.playSoundFileNamed("G#_1.m4a", waitForCompletion: false)
        noteSounds["A"] = SKAction.playSoundFileNamed("A_1.m4a", waitForCompletion: false)
        noteSounds["A#"] = SKAction.playSoundFileNamed("A#_1.m4a", waitForCompletion: false)
        noteSounds["B"] = SKAction.playSoundFileNamed("B_1.m4a", waitForCompletion: false)
        // Add the rest of the notes and their corresponding sound files
        // ...
    }

    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func addCharacters() {
        let characterPositions: [CGPoint] = [CGPoint(x: -150, y: -100), CGPoint(x: 0, y: -100), CGPoint(x: 150, y: -100)]
        let characterImages: [String] = ["davidmartinez", "maine", "faraday"]
        let characterScales: [CGFloat] = [2, 2, 2]
        let characterBitMasks: [UInt32] = [1, 2, 3]

        for i in 0..<characterPositions.count {
            let character = SKSpriteNode(imageNamed: characterImages[i])
            character.position = characterPositions[i]
            character.setScale(characterScales[i])
            
            // Set up physics body
            character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
            character.physicsBody?.categoryBitMask = characterBitMasks[i]
            character.physicsBody?.contactTestBitMask = characterBitMasks[i] // same category can collide
            character.physicsBody?.collisionBitMask = characterBitMasks.reduce(0) { $0 | $1 } // collide with all characters
            character.physicsBody?.affectedByGravity = false
            character.physicsBody?.allowsRotation = false

            addChild(character)

            // Assign character variables
            switch i {
            case 0:
                Character_1 = character
            case 1:
                Character_2 = character
            case 2:
                Character_3 = character
            default:
                break
            }
        }
    }


    
    // Add characters
    func addCharacters1() {
        let characterPositions: [CGPoint] = [CGPoint(x: -150, y: -100), CGPoint(x: 0, y: -100), CGPoint(x: 150, y: -100)]
        let characterImages: [String] = ["Characters-1", "Characters-2", "Characters"]
        let characterBitMasks: [UInt32] = [1, 2, 2]
        
        for i in 0..<characterPositions.count {
            let character = SKSpriteNode(imageNamed: characterImages[i])
            character.zPosition = 100
            character.position = characterPositions[i]
            character.setScale(0.05)
            character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
            character.physicsBody?.categoryBitMask = characterBitMasks[i]
            character.physicsBody?.contactTestBitMask = characterBitMasks[i] == 1 ? 2 : 1
            character.physicsBody?.collisionBitMask = 3
            character.physicsBody?.affectedByGravity = false
            character.physicsBody?.allowsRotation = false
            
            addChild(character)
            
            // Assign character variables
            switch i {
            case 0:
                Character_1 = character
            case 1:
                Character_2 = character
//            case 2:
//                Character_3 = character
            default:
                break
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }

            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)

            if touchedNode.name == "checkButton" {
                // Check if the chords are equal
                let areChordsEqual = compareChords(formedChord: checkChord(), generatedChord: generatedChord)

                if areChordsEqual {
                    // Increment the score
                    ScoreManager.shared.score += 1
                    
                    // Update the score label
                    scoreLabel.text = "Score: \(ScoreManager.shared.score)"
                    
                    // Show the pop-up label
                    popUpLabel.isHidden = false

                    // Delay for 5 seconds
                    let delayAction = SKAction.wait(forDuration: 3.0)

                    // Hide the pop-up label after the delay
                    let hideAction = SKAction.hide()

                    // Restart the game after the delay
                    let restartAction = SKAction.run {
                        self.restartGame()
                    }
                    

                    // Sequence the actions: delay -> hide -> restart
                    let sequence = SKAction.sequence([delayAction, hideAction, restartAction])

                    // Run the sequence on the pop-up label
                    popUpLabel.run(sequence)
                }
                else{
                    restartGame()
                }
            }
        }
    
    
    func restartGame() {
            // Logic to reset the game

            // Reload the scene to restart the game
            if let scene = GameScene(fileNamed: "Level_1_Scene") {
                scene.scaleMode = .aspectFill
                view?.presentScene(scene)
            }
        }
    
    // Move characters
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        
        // Define the note tile maps and character nodes
        let noteTileMaps: [SKTileMapNode?] = [Notes_C, Notes_CS, Notes_D, Notes_DS, Notes_E, Notes_F, Notes_FS, Notes_G, Notes_GS, Notes_A, Notes_AS, Notes_B, Notes_C2, Notes_CS2, Notes_D2, Notes_DS2, Notes_E2, Notes_F2, Notes_FS2, Notes_G2, Notes_GS2, Notes_A2, Notes_AS2, Notes_B2]
        let characterNodes: [SKSpriteNode] = [Character_1, Character_2, Character_3]
        let characterNames: [String] = ["Character_1", "Character_2", "Character_3"]
         
        // Iterate over each note tile map
            for (index, noteTileMap) in noteTileMaps.enumerated() {
                if let noteTileMap = noteTileMap, noteTileMap.contains(touchLocation) {
                    for (characterIndex, characterNode) in characterNodes.enumerated() {
                        if characterNode.frame.contains(touchLocation) {
                            let noteName = getNoteName(index)
                            switch characterIndex {
                            case 0:
                                character1Note = noteName
                                playNoteSound(noteName)
                            case 1:
                                character2Note = noteName
                                playNoteSound(noteName)
                            case 2:
                                character3Note = noteName
                                playNoteSound(noteName)
                            default:
                                break
                            }
                            print("\(characterNames[characterIndex]) is standing on \(noteName) Note!")
                        }
                    }
                }
        }
        
        //Character 1
        if Character_1.frame.contains(touchLocation) {
            let newPosition = CGPoint(x: touchLocation.x, y: touchLocation.y)
            Character_1.position = newPosition
        }
        //Character 2
        if Character_2.frame.contains(touchLocation) {
            let newPosition = CGPoint(x: touchLocation.x, y: touchLocation.y)
            Character_2.position = newPosition
        }
        //Character 3
        if Character_3.frame.contains(touchLocation) {
            let newPosition = CGPoint(x: touchLocation.x, y: touchLocation.y)
            Character_3.position = newPosition
        }
        
        let formedChord = checkChord()
        print(formedChord)
        
        
        compareChords(formedChord: formedChord, generatedChord: generatedChord)
        
        
    }
    
    func playNoteSound(_ noteName: String) {
        if let soundAction = noteSounds[noteName] {
            run(soundAction)
        }
    }
    
    func getNoteName(_ index: Int) -> String {
        let noteNames: [String] = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B", "C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2", "G#2", "A2", "A#2", "B2"]
        if index >= 0 && index < noteNames.count {
            return noteNames[index]
        } else {
            return "Unknown"
        }
    }
    
    // Function to check the formed chord
    func checkChord() -> [String] {
        guard let note1 = character1Note,
              let note2 = character2Note,
              let note3 = character3Note else {
            return []
        }
        
        let chordNotes = [note1, note2, note3]
        
        // Sort the chord notes alphabetically
        let sortedChordNotes = chordNotes.sorted()
        
        return sortedChordNotes
    }
    
    
    func generateRandomChord() -> (chord: [String], name: String) {
        let chordNames = [
            ("C major", ["C", "E", "G"]),
            ("D major", ["D", "F#", "A"]),
            ("E major", ["E", "G#", "B"]),
            ("F major", ["F", "A", "C"]),
            ("G major", ["G", "B", "D"]),
            ("A major", ["A", "C#", "E"]),
            ("B major", ["B", "D#", "F#"]),
            ("C minor", ["C", "D#", "G"]),
            ("D minor", ["D", "F", "A"]),
            ("E minor", ["E", "G", "B"]),
            ("F minor", ["F", "G#", "C"]),
            ("G minor", ["G", "A#", "D"]),
            ("A minor", ["A", "C", "E"]),
            ("B minor", ["B", "D", "F#"])
        ]
        
        let randomChordIndex = Int.random(in: 0..<chordNames.count)
        let (chordName, chordNotes) = chordNames[randomChordIndex]
        
        print("Generated Chord: \(chordNotes)")
        print("Chord Name: \(chordName)")
        
        return (chordNotes, chordName)
    }
    
    
    func getChordName(for chord: [String]) -> String {
        let chordNotes = chord.sorted()
        
        switch chordNotes {
        //Major Chords
        case ["C", "E", "G"]:
            return "C major"
        case ["D", "F#", "A"]:
            return "D major"
        case ["E", "G#", "B"]:
            return "E major"
        case ["F", "A", "C"]:
            return "F major"
        case ["G", "B", "D"]:
            return "G major"
        case ["A", "C#", "E"]:
            return "A major"
        case ["B", "D#", "F#"]:
            return "B major"
        //Minor Chords
        case ["C", "D#", "G"]:
            return "C minor"
        case ["D", "F", "A"]:
            return "D minor"
        case ["E", "G", "B"]:
            return "E minor"
        case ["F", "G#", "C"]:
            return "F minor"
        case ["G", "A#", "D"]:
            return "G minor"
        case ["A", "C", "E"]:
            return "A minor"
        case ["B", "D", "F#"]:
            return "B minor"
        default:
            return "Unknown chord"
        }
    }
    
    func compareChords(formedChord: [String], generatedChord: [String]) -> Bool {
        let sortedFormedChord = formedChord.sorted()
        let sortedGeneratedChord = generatedChord.sorted()

        let areChordsEqual = sortedFormedChord == sortedGeneratedChord
        print("Are the chords the same? \(areChordsEqual)")

        return areChordsEqual
    }

    
    // Handle contact between characters
    func didBegin(_ contact: SKPhysicsContact) {
        let firstNode = contact.bodyA.node
        let secondNode = contact.bodyB.node
        
        if firstNode == Character_1 || secondNode == Character_1 {
            Character_1.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        if firstNode == Character_2 || secondNode == Character_2 {
            Character_2.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        if firstNode == Character_3 || secondNode == Character_3 {
            Character_3.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
    }
    
    //Function to proceed to the next level
    func advanceToNextLevel(){
        currentLevel += 1
        setupLevel(level: currentLevel)
    }
}


