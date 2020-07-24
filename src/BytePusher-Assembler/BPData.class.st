Class {
	#name : #BPData,
	#superclass : #Object,
	#instVars : [
		'address',
		'data',
		'assemblerInstruction'
	],
	#category : #'BytePusher-Assembler-Model'
}

{ #category : #accessing }
BPData >> address [
	^ address
]

{ #category : #accessing }
BPData >> address: anObject [
	address := anObject
]

{ #category : #accessing }
BPData >> assemblerInstruction [
	^ assemblerInstruction
]

{ #category : #accessing }
BPData >> assemblerInstruction: anObject [
	assemblerInstruction := anObject
]

{ #category : #assembling }
BPData >> beAssembledIn: aBPAssembledCode [ 
	aBPAssembledCode addInstruction: self
]

{ #category : #'as yet unclassified' }
BPData >> bytesRequired [
	^ self data bytesRequired
]

{ #category : #accessing }
BPData >> data [
	^ data
]

{ #category : #accessing }
BPData >> data: anObject [
	data := anObject
]

{ #category : #'as yet unclassified' }
BPData >> tag [
	^ self assemblerInstruction tag
]

{ #category : #writing }
BPData >> writeOn: aByteArray [
	self data class = BPAddress
		ifTrue: [ 
			self address storeAddress: self data in: aByteArray.
			^ self ].

	self data doWithIndex: [ :byte :index |
		(self address + (index - 1)) store: byte in: aByteArray ]
]
