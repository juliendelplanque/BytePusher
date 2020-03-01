Class {
	#name : #BPPushCurrentAddressOnStack,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'label'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPPushCurrentAddressOnStack >> generateFor: anAssembler [
	| label |
	self generateLabel.
	anAssembler label: self label.
	label := self label forAssembler: anAssembler.
	anAssembler pushOnDataStack: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (label asDataAccess byteIndex: 0).
	anAssembler pushOnDataStack: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (label asDataAccess byteIndex: 1).
	anAssembler pushOnDataStack: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (label asDataAccess byteIndex: 2)
]

{ #category : #private }
BPPushCurrentAddressOnStack >> generateLabel [
	self label: ('pcSerializationLabel' , UUIDGenerator next asString) asSymbol.
	^ self label
]

{ #category : #accessing }
BPPushCurrentAddressOnStack >> label [
	^ label
]

{ #category : #accessing }
BPPushCurrentAddressOnStack >> label: anObject [
	label := anObject
]
