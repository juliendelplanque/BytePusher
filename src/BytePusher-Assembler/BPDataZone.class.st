Class {
	#name : #BPDataZone,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'byteArray'
	],
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #'as yet unclassified' }
BPDataZone >> adjustedByteArray [
	^ self byteArray , ((self byteArray size \\ INSTRUCTION_SIZE) > 0
								ifTrue: [ ByteArray new: self byteArray size \\ INSTRUCTION_SIZE ]
								ifFalse: [ ByteArray new ])
]

{ #category : #accessing }
BPDataZone >> byteArray [
	^ byteArray
]

{ #category : #accessing }
BPDataZone >> byteArray: anObject [
	byteArray := anObject
]

{ #category : #generating }
BPDataZone >> generateFor: anAssembler [
	| instructionsCount |
	instructionsCount := self adjustedByteArray size // INSTRUCTION_SIZE.
		
	self adjustedByteArray readStreamDo: [ :bytesStream |
		instructionsCount timesRepeat: [ 
			self newInstruction
				from: (BPAddress fromByteArray: (bytesStream next: 3));
				to: (BPAddress fromByteArray: (bytesStream next: 3));
				jump: (BPAddress fromByteArray: (bytesStream next: 3));
				beAddedTo: anAssembler ] ]
]
