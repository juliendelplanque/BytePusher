Class {
	#name : #BPPushLabelAddressOnStack,
	#superclass : #BPAssemblerInstruction,
	#instVars : [
		'label'
	],
	#category : #'BytePusher-Assembler-Assembler'
}

{ #category : #generating }
BPPushLabelAddressOnStack >> generateFor: anAssembler [
	| labelObject |
	labelObject := self label forAssembler: anAssembler.
	anAssembler pushOnReturnStack: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelObject asDataAccess byteIndex: 0).
	anAssembler pushOnReturnStack: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelObject asDataAccess byteIndex: 1).
	anAssembler pushOnReturnStack: (anAssembler reservedMemoryZoneNamed: #IDENTITY_PAGE) + (labelObject asDataAccess byteIndex: 2)
]

{ #category : #private }
BPPushLabelAddressOnStack >> generateLabel [
	self label: ('pcSerializationLabel' , UUIDGenerator next asString) asSymbol.
	^ self label
]

{ #category : #accessing }
BPPushLabelAddressOnStack >> label [
	^ label
]

{ #category : #accessing }
BPPushLabelAddressOnStack >> label: anObject [
	label := anObject
]
